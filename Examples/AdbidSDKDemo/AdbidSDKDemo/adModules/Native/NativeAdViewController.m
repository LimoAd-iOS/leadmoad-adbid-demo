//
//  NativeAdViewController.m
//  LeadMoadAdSDKDemo
//
//  Created by youzhadoubao on 2025/9/19.
//

#import "NativeAdViewController.h"
#import <AdbidSDK/AdbidSDK.h>
#import "NativeFeedAdView.h"
#import "AppConfig.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, AdStatus) {
    AdStatusIdle = 0,  // 空闲状态
    AdStatusLoading,   // 加载中
    AdStatusLoaded,    // 已加载
    AdStatusShowing,   // 展示中
    AdStatusError      // 错误状态
};

@interface NativeAdViewController () <AdbidNativeAdDelegate,AdbidNativeMediaViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) AdbidNativeAd *nativeAd;
@property (nonatomic, strong) NativeFeedAdView *customAdView;
@property (nonatomic, strong) AdbidNativeObj *nativeObj;
@property (nonatomic, strong) UIImage *prefetchedVideoCoverImage;
@property (nonatomic, copy) NSString *prefetchingVideoCoverUrl;
@property (nonatomic, strong) UIView *fullscreenAdOverlayView;
@property (nonatomic, strong) UIScrollView *fullscreenEpisodeScrollView;
@property (nonatomic, strong) UIView *fullscreenAdPageView;
@property (nonatomic, strong) NativeFeedAdView *fullscreenAdView;
@property (nonatomic, strong) UIView *fullscreenBottomCardView;
@property (nonatomic, strong) UIImageView *fullscreenIconImageView;
@property (nonatomic, strong) UIButton *fullscreenDetailButton;
@property (nonatomic, strong) UIButton *fullscreenMuteButton;
@property (nonatomic, strong) NSMutableArray<AVPlayer *> *fullscreenEpisodePlayers;
@property (nonatomic, strong) NSMutableArray<AVPlayerLayer *> *fullscreenEpisodePlayerLayers;
@property (nonatomic, strong) NSMutableArray<UIView *> *fullscreenEpisodeVideoSurfaces;
@property (nonatomic, assign) BOOL hasBoundFullscreenAdContent;
@property (nonatomic, assign) BOOL fullscreenMuted;

// UI 控件
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *controlPanel;
@property (nonatomic, strong) UITextField *slotIdTextField;
@property (nonatomic, strong) UISegmentedControl *mediaLayoutControl;
@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UIButton *winNoticeButton;
@property (nonatomic, strong) UIButton *lossNoticeButton;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *adContainerView;
@property (nonatomic, strong) UILabel *containerView;

// 测试视频（用于验证 native 广告是否打断其他播放器）
@property (nonatomic, strong) UIView *testVideoContainer;
@property (nonatomic, strong) UILabel *testVideoTitleLabel;
@property (nonatomic, strong) UIView *testVideoSurface;
@property (nonatomic, strong) UILabel *testVideoPlaceholderLabel;
@property (nonatomic, strong) AVPlayer *testVideoPlayer;
@property (nonatomic, strong) AVPlayerLayer *testVideoLayer;
@property (nonatomic, strong) UIButton *testVideoButton;
@property (nonatomic, strong) UIButton *testVideoToggleButton;
@property (nonatomic, strong) NSLayoutConstraint *testVideoContainerHeightConstraint;
@property (nonatomic, strong) NSArray<NSLayoutConstraint *> *testVideoExpandedConstraints;
@property (nonatomic, assign) BOOL testVideoExpanded;

// 状态管理
@property (nonatomic, assign) AdStatus currentStatus;

@end

@implementation NativeAdViewController

- (void)performOnMainThread:(dispatch_block_t)block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:247/255.0 blue:250/255.0 alpha:1.0];
    self.title = @"信息流广告Demo";

    // 初始化状态
    self.currentStatus = AdStatusIdle;

    // 设置UI
    [self setupUI];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onBackgroundTapped)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFullscreenNativeAdViewAndUpdateStatus:NO];
    _nativeAd.delegate = nil;
    _nativeAd.rootViewController = nil;
    [_testVideoPlayer pause];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.testVideoPlayer pause];
    [self.testVideoButton setTitle:@"▶️ 播放测试视频" forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateTestVideoLayerFrame];
    [self updateFullscreenEpisodePlayerLayerFrames];
}

#pragma mark - UI Setup

- (void)setupUI {
    // 创建滚动视图
    [self.view addSubview:self.scrollView];

    // 添加控制面板
    [self.scrollView addSubview:self.controlPanel];

    // 添加按钮和状态标签
    [self.controlPanel addSubview:self.slotIdTextField];
    [self.controlPanel addSubview:self.mediaLayoutControl];
    [self.controlPanel addSubview:self.loadButton];
    [self.controlPanel addSubview:self.showButton];
    [self.controlPanel addSubview:self.winNoticeButton];
    [self.controlPanel addSubview:self.lossNoticeButton];
    [self.controlPanel addSubview:self.statusLabel];

    // 添加测试视频区域（用于验证 native 广告是否打断其他视频）
    [self.scrollView addSubview:self.testVideoContainer];
    [self.testVideoContainer addSubview:self.testVideoTitleLabel];
    [self.testVideoContainer addSubview:self.testVideoToggleButton];
    [self.testVideoContainer addSubview:self.testVideoSurface];
    [self.testVideoContainer addSubview:self.testVideoButton];

    // 添加广告容器
    [self.scrollView addSubview:self.adContainerView];
    [self.adContainerView addSubview:self.containerView];

    // 设置约束
    [self setupConstraints];

    // 更新UI状态
    [self updateUIForStatus:self.currentStatus];
}

- (void)setupConstraints {
    // 滚动视图约束
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];

    // 控制面板约束
    self.controlPanel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.controlPanel.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:20],
        [self.controlPanel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.controlPanel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.controlPanel.heightAnchor constraintEqualToConstant:390]
    ]];

    // 广告位ID输入框约束
    self.slotIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.slotIdTextField.topAnchor constraintEqualToAnchor:self.controlPanel.topAnchor constant:20],
        [self.slotIdTextField.leadingAnchor constraintEqualToAnchor:self.controlPanel.leadingAnchor constant:20],
        [self.slotIdTextField.trailingAnchor constraintEqualToAnchor:self.controlPanel.trailingAnchor constant:-20],
        [self.slotIdTextField.heightAnchor constraintEqualToConstant:40]
    ]];

    // 按钮约束
    self.mediaLayoutControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.loadButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.showButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.winNoticeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.lossNoticeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.mediaLayoutControl.topAnchor constraintEqualToAnchor:self.slotIdTextField.bottomAnchor constant:12],
        [self.mediaLayoutControl.leadingAnchor constraintEqualToAnchor:self.controlPanel.leadingAnchor constant:20],
        [self.mediaLayoutControl.trailingAnchor constraintEqualToAnchor:self.controlPanel.trailingAnchor constant:-20],
        [self.mediaLayoutControl.heightAnchor constraintEqualToConstant:32],

        // Load按钮
        [self.loadButton.topAnchor constraintEqualToAnchor:self.mediaLayoutControl.bottomAnchor constant:16],
        [self.loadButton.leadingAnchor constraintEqualToAnchor:self.controlPanel.leadingAnchor constant:20],
        [self.loadButton.trailingAnchor constraintEqualToAnchor:self.controlPanel.centerXAnchor constant:-10],
        [self.loadButton.heightAnchor constraintEqualToConstant:50],

        // Show按钮
        [self.showButton.topAnchor constraintEqualToAnchor:self.mediaLayoutControl.bottomAnchor constant:16],
        [self.showButton.leadingAnchor constraintEqualToAnchor:self.controlPanel.centerXAnchor constant:10],
        [self.showButton.trailingAnchor constraintEqualToAnchor:self.controlPanel.trailingAnchor constant:-20],
        [self.showButton.heightAnchor constraintEqualToConstant:50],

        // Win Notice Button
        [self.winNoticeButton.topAnchor constraintEqualToAnchor:self.loadButton.bottomAnchor constant:20],
        [self.winNoticeButton.leadingAnchor constraintEqualToAnchor:self.controlPanel.leadingAnchor constant:20],
        [self.winNoticeButton.trailingAnchor constraintEqualToAnchor:self.controlPanel.centerXAnchor constant:-10],
        [self.winNoticeButton.heightAnchor constraintEqualToConstant:50],

        // Loss Notice Button
        [self.lossNoticeButton.topAnchor constraintEqualToAnchor:self.showButton.bottomAnchor constant:20],
        [self.lossNoticeButton.leadingAnchor constraintEqualToAnchor:self.controlPanel.centerXAnchor constant:10],
        [self.lossNoticeButton.trailingAnchor constraintEqualToAnchor:self.controlPanel.trailingAnchor constant:-20],
        [self.lossNoticeButton.heightAnchor constraintEqualToConstant:50],

        // 状态标签
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.winNoticeButton.bottomAnchor constant:20],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.controlPanel.leadingAnchor constant:20],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.controlPanel.trailingAnchor constant:-20],
        [self.statusLabel.heightAnchor constraintEqualToConstant:80]
    ]];

    // 测试视频容器约束
    self.testVideoContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.testVideoTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.testVideoSurface.translatesAutoresizingMaskIntoConstraints = NO;
    self.testVideoButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.testVideoToggleButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.testVideoContainerHeightConstraint = [self.testVideoContainer.heightAnchor constraintEqualToConstant:52];
    [NSLayoutConstraint activateConstraints:@[
        [self.testVideoContainer.topAnchor constraintEqualToAnchor:self.controlPanel.bottomAnchor constant:20],
        [self.testVideoContainer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.testVideoContainer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        self.testVideoContainerHeightConstraint,

        [self.testVideoTitleLabel.topAnchor constraintEqualToAnchor:self.testVideoContainer.topAnchor constant:14],
        [self.testVideoTitleLabel.leadingAnchor constraintEqualToAnchor:self.testVideoContainer.leadingAnchor constant:16],
        [self.testVideoTitleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.testVideoToggleButton.leadingAnchor constant:-12],
        [self.testVideoTitleLabel.heightAnchor constraintEqualToConstant:24],

        [self.testVideoToggleButton.trailingAnchor constraintEqualToAnchor:self.testVideoContainer.trailingAnchor constant:-16],
        [self.testVideoToggleButton.centerYAnchor constraintEqualToAnchor:self.testVideoTitleLabel.centerYAnchor],
        [self.testVideoToggleButton.widthAnchor constraintEqualToConstant:52],
        [self.testVideoToggleButton.heightAnchor constraintEqualToConstant:30],
    ]];

    self.testVideoExpandedConstraints = @[
        [self.testVideoSurface.topAnchor constraintEqualToAnchor:self.testVideoTitleLabel.bottomAnchor constant:8],
        [self.testVideoSurface.leadingAnchor constraintEqualToAnchor:self.testVideoContainer.leadingAnchor constant:12],
        [self.testVideoSurface.trailingAnchor constraintEqualToAnchor:self.testVideoContainer.trailingAnchor constant:-12],
        [self.testVideoSurface.bottomAnchor constraintEqualToAnchor:self.testVideoButton.topAnchor constant:-8],

        [self.testVideoButton.leadingAnchor constraintEqualToAnchor:self.testVideoContainer.leadingAnchor constant:12],
        [self.testVideoButton.trailingAnchor constraintEqualToAnchor:self.testVideoContainer.trailingAnchor constant:-12],
        [self.testVideoButton.bottomAnchor constraintEqualToAnchor:self.testVideoContainer.bottomAnchor constant:-8],
        [self.testVideoButton.heightAnchor constraintEqualToConstant:36],
    ];
    [self setTestVideoExpanded:NO animated:NO];

    // 广告容器约束
    self.adContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.adContainerView.topAnchor constraintEqualToAnchor:self.testVideoContainer.bottomAnchor constant:20],
        [self.adContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.adContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.adContainerView.heightAnchor constraintEqualToConstant:100],
        [self.adContainerView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor constant:-20]
    ]];

    // containerView约束
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.adContainerView.topAnchor constant:20],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.adContainerView.leadingAnchor],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.adContainerView.trailingAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.adContainerView.bottomAnchor constant:-20]
    ]];
}

#pragma mark - Button Actions

- (void)loadButtonTapped:(UIButton *)sender {
    if (self.currentStatus == AdStatusLoading) {
        return;  // 防止重复加载
    }

    [self removeFullscreenNativeAdViewAndUpdateStatus:NO];
    [self updateStatus:AdStatusLoading];

    // 从输入框获取广告位ID，如果为空则使用默认ID 100130103000001
    NSString *slotId = self.slotIdTextField.text.length > 0 ? self.slotIdTextField.text : @"100130103000001";

    NSLog(@"开始加载信息流广告，广告位ID: %@", slotId);
    AdbidNativeAd *nativeAd = [[AdbidNativeAd alloc] initWithSlotId:slotId];
    nativeAd.rootViewController = self;
    nativeAd.delegate = self;
    self.nativeAd = nativeAd;
    [self.nativeAd loadAd];
}

- (void)showButtonTapped:(UIButton *)sender {
    if (self.currentStatus != AdStatusLoaded) {
        return;  // 只有加载完成才能展示
    }

    [self updateStatus:AdStatusShowing];
    if ([self.nativeAd isReady]) {
        NSLog(@"在当前页展示全屏信息流广告");
        [self showFullscreenNativeAdInCurrentPage];
    } else {
        [self updateStatus:AdStatusLoaded];
    }
}

- (void)showFullscreenNativeAdInCurrentPage {
    [self removeFullscreenNativeAdViewAndUpdateStatus:NO];
    [self.testVideoPlayer pause];
    [self.testVideoButton setTitle:@"▶️ 播放测试视频" forState:UIControlStateNormal];

    self.nativeAd.rootViewController = self;
    self.hasBoundFullscreenAdContent = NO;
    self.fullscreenEpisodePlayers = [NSMutableArray array];
    self.fullscreenEpisodePlayerLayers = [NSMutableArray array];
    self.fullscreenEpisodeVideoSurfaces = [NSMutableArray array];

    UIView *hostView = self.navigationController.view ?: self.view;
    UIView *overlayView = [[UIView alloc] init];
    overlayView.translatesAutoresizingMaskIntoConstraints = NO;
    overlayView.backgroundColor = [UIColor blackColor];
    [hostView addSubview:overlayView];
    [NSLayoutConstraint activateConstraints:@[
        [overlayView.topAnchor constraintEqualToAnchor:hostView.topAnchor],
        [overlayView.leadingAnchor constraintEqualToAnchor:hostView.leadingAnchor],
        [overlayView.trailingAnchor constraintEqualToAnchor:hostView.trailingAnchor],
        [overlayView.bottomAnchor constraintEqualToAnchor:hostView.bottomAnchor],
    ]];
    self.fullscreenAdOverlayView = overlayView;
    [self setupFullscreenEpisodePagerInOverlayView:overlayView];

    self.fullscreenAdView = [[NativeFeedAdView alloc] init];
    self.fullscreenAdView.translatesAutoresizingMaskIntoConstraints = NO;
    self.fullscreenAdView.backgroundColor = [UIColor blackColor];
    [self.fullscreenAdPageView addSubview:self.fullscreenAdView];
    [NSLayoutConstraint activateConstraints:@[
        [self.fullscreenAdView.topAnchor constraintEqualToAnchor:self.fullscreenAdPageView.topAnchor],
        [self.fullscreenAdView.leadingAnchor constraintEqualToAnchor:self.fullscreenAdPageView.leadingAnchor],
        [self.fullscreenAdView.trailingAnchor constraintEqualToAnchor:self.fullscreenAdPageView.trailingAnchor],
        [self.fullscreenAdView.bottomAnchor constraintEqualToAnchor:self.fullscreenAdPageView.bottomAnchor],
    ]];

    if (self.nativeObj.isVideoAd) {
        [self setupFullscreenVideoAdView];
    } else {
        [self setupFullscreenImageAdView];
    }
    [self setupFullscreenBottomCardView];
    [self setupFullscreenMuteButtonIfNeeded];
    [self setupFullscreenCloseButton];

    [overlayView layoutIfNeeded];
    [self scrollFullscreenPagerToAdPageAnimated:NO];
    [self updateFullscreenEpisodePlayerLayerFrames];
    [self updateFullscreenEpisodePlaybackForCurrentPage];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self bindFullscreenAdContentIfNeeded];
    });
}

- (void)setupFullscreenEpisodePagerInOverlayView:(UIView *)overlayView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.pagingEnabled = YES;
    scrollView.bounces = YES;
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.scrollsToTop = NO;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [overlayView addSubview:scrollView];
    self.fullscreenEpisodeScrollView = scrollView;

    UIView *contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor blackColor];
    [scrollView addSubview:contentView];

    UIView *previousEpisodePage = [self createFullscreenEpisodePageWithTitle:@"第 1 集"];
    UIView *adPageView = [[UIView alloc] init];
    adPageView.translatesAutoresizingMaskIntoConstraints = NO;
    adPageView.backgroundColor = [UIColor blackColor];
    UIView *nextEpisodePage = [self createFullscreenEpisodePageWithTitle:@"第 2 集"];
    [contentView addSubview:previousEpisodePage];
    [contentView addSubview:adPageView];
    [contentView addSubview:nextEpisodePage];
    self.fullscreenAdPageView = adPageView;

    UILayoutGuide *contentGuide = scrollView.contentLayoutGuide;
    UILayoutGuide *frameGuide = scrollView.frameLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:overlayView.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:overlayView.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:overlayView.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:overlayView.bottomAnchor],

        [contentView.topAnchor constraintEqualToAnchor:contentGuide.topAnchor],
        [contentView.leadingAnchor constraintEqualToAnchor:contentGuide.leadingAnchor],
        [contentView.trailingAnchor constraintEqualToAnchor:contentGuide.trailingAnchor],
        [contentView.bottomAnchor constraintEqualToAnchor:contentGuide.bottomAnchor],
        [contentView.widthAnchor constraintEqualToAnchor:frameGuide.widthAnchor],

        [previousEpisodePage.topAnchor constraintEqualToAnchor:contentView.topAnchor],
        [previousEpisodePage.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor],
        [previousEpisodePage.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor],
        [previousEpisodePage.widthAnchor constraintEqualToAnchor:frameGuide.widthAnchor],
        [previousEpisodePage.heightAnchor constraintEqualToAnchor:frameGuide.heightAnchor],

        [adPageView.topAnchor constraintEqualToAnchor:previousEpisodePage.bottomAnchor],
        [adPageView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor],
        [adPageView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor],
        [adPageView.widthAnchor constraintEqualToAnchor:frameGuide.widthAnchor],
        [adPageView.heightAnchor constraintEqualToAnchor:frameGuide.heightAnchor],

        [nextEpisodePage.topAnchor constraintEqualToAnchor:adPageView.bottomAnchor],
        [nextEpisodePage.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor],
        [nextEpisodePage.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor],
        [nextEpisodePage.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor],
        [nextEpisodePage.widthAnchor constraintEqualToAnchor:frameGuide.widthAnchor],
        [nextEpisodePage.heightAnchor constraintEqualToAnchor:frameGuide.heightAnchor],
    ]];
}

- (UIView *)createFullscreenEpisodePageWithTitle:(NSString *)title {
    UIView *pageView = [[UIView alloc] init];
    pageView.translatesAutoresizingMaskIntoConstraints = NO;
    pageView.backgroundColor = [UIColor blackColor];

    UIView *videoSurface = [[UIView alloc] init];
    videoSurface.translatesAutoresizingMaskIntoConstraints = NO;
    videoSurface.backgroundColor = [UIColor blackColor];
    videoSurface.clipsToBounds = YES;
    [pageView addSubview:videoSurface];
    [NSLayoutConstraint activateConstraints:@[
        [videoSurface.topAnchor constraintEqualToAnchor:pageView.topAnchor],
        [videoSurface.leadingAnchor constraintEqualToAnchor:pageView.leadingAnchor],
        [videoSurface.trailingAnchor constraintEqualToAnchor:pageView.trailingAnchor],
        [videoSurface.bottomAnchor constraintEqualToAnchor:pageView.bottomAnchor],
    ]];

    NSURL *url = [self fullscreenEpisodeVideoURL];
    AVPlayer *player = [AVPlayer playerWithURL:url];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [videoSurface.layer insertSublayer:playerLayer atIndex:0];
    [self.fullscreenEpisodePlayers addObject:player];
    [self.fullscreenEpisodePlayerLayers addObject:playerLayer];
    [self.fullscreenEpisodeVideoSurfaces addObject:videoSurface];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fullscreenEpisodeDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:player.currentItem];

    UILabel *episodeLabel = [[UILabel alloc] init];
    episodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    episodeLabel.text = title;
    episodeLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    episodeLabel.textColor = [UIColor whiteColor];
    episodeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.42];
    episodeLabel.textAlignment = NSTextAlignmentCenter;
    episodeLabel.layer.cornerRadius = 15;
    episodeLabel.layer.masksToBounds = YES;
    [pageView addSubview:episodeLabel];
    [NSLayoutConstraint activateConstraints:@[
        [episodeLabel.leadingAnchor constraintEqualToAnchor:pageView.leadingAnchor constant:16],
        [episodeLabel.bottomAnchor constraintEqualToAnchor:pageView.safeAreaLayoutGuide.bottomAnchor constant:-24],
        [episodeLabel.widthAnchor constraintEqualToConstant:70],
        [episodeLabel.heightAnchor constraintEqualToConstant:30],
    ]];

    return pageView;
}

- (NSURL *)fullscreenEpisodeVideoURL {
    return [NSURL URLWithString:@"https://www.w3schools.com/html/mov_bbb.mp4"];
}

- (void)setupFullscreenVideoAdView {
    if (self.fullscreenAdView.mediaView.superview) {
        [self.fullscreenAdView.mediaView removeFromSuperview];
    }
    self.fullscreenAdView.mediaView.translatesAutoresizingMaskIntoConstraints = NO;
    self.fullscreenAdView.mediaView.delegate = self;
    self.fullscreenAdView.mediaView.backgroundColor = [self isFLinkNativeAd] ? [UIColor blackColor] : [UIColor clearColor];
    self.fullscreenAdView.mediaView.userInteractionEnabled = YES;
    [self.fullscreenAdView insertSubview:self.fullscreenAdView.mediaView aboveSubview:self.fullscreenAdView.imageView];
    [self pinFullscreenSubview:self.fullscreenAdView.mediaView toContainer:self.fullscreenAdView];

    self.fullscreenAdView.imageView.hidden = NO;
    self.fullscreenAdView.imageView.image = nil;
    self.fullscreenAdView.imageView.backgroundColor = [UIColor blackColor];
    self.fullscreenAdView.imageView.userInteractionEnabled = YES;
    self.fullscreenAdView.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.fullscreenAdView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.fullscreenAdView.imageView.clipsToBounds = YES;
    [self.fullscreenAdView insertSubview:self.fullscreenAdView.imageView belowSubview:self.fullscreenAdView.mediaView];
    [self pinFullscreenSubview:self.fullscreenAdView.imageView toContainer:self.fullscreenAdView];

    if (self.nativeObj.externalMediaView && ![self isFLinkNativeAd]) {
        self.fullscreenAdView.imageView.hidden = YES;
        return;
    }
    [self setupFullscreenPreparedVideoCoverIfNeeded];
}

- (void)setupFullscreenImageAdView {
    self.fullscreenAdView.imageView.hidden = NO;
    self.fullscreenAdView.imageView.alpha = 0;
    self.fullscreenAdView.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.fullscreenAdView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.fullscreenAdView.imageView.clipsToBounds = YES;
    self.fullscreenAdView.imageView.userInteractionEnabled = YES;
    [self.fullscreenAdView bringSubviewToFront:self.fullscreenAdView.imageView];
    [self pinFullscreenSubview:self.fullscreenAdView.imageView toContainer:self.fullscreenAdView];

    NSString *imageUrl = self.nativeObj.imageAdInfo.imageUrl ?: self.nativeObj.videoAdInfo.coverImageUrl;
    __weak typeof(self) weakSelf = self;
    [self loadImageWithURLString:imageUrl completion:^(UIImage *image) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || strongSelf.fullscreenAdView.superview == nil) {
            return;
        }
        strongSelf.fullscreenAdView.imageView.image = image;
        strongSelf.fullscreenAdView.imageView.alpha = 1;
    }];
}

- (void)setupFullscreenPreparedVideoCoverIfNeeded {
    if (!self.prefetchedVideoCoverImage) {
        return;
    }
    self.fullscreenAdView.imageView.image = self.prefetchedVideoCoverImage;
}

- (void)pinFullscreenSubview:(UIView *)subview toContainer:(UIView *)container {
    [NSLayoutConstraint activateConstraints:@[
        [subview.topAnchor constraintEqualToAnchor:container.topAnchor],
        [subview.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [subview.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [subview.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
    ]];
}

- (void)setupFullscreenBottomCardView {
    UIView *containerView = self.fullscreenAdPageView ?: self.fullscreenAdOverlayView;
    UIView *bottomCardView = [[UIView alloc] init];
    bottomCardView.translatesAutoresizingMaskIntoConstraints = NO;
    bottomCardView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.94];
    bottomCardView.layer.cornerRadius = 16;
    bottomCardView.layer.masksToBounds = NO;
    bottomCardView.layer.shadowColor = [UIColor blackColor].CGColor;
    bottomCardView.layer.shadowOffset = CGSizeMake(0, 8);
    bottomCardView.layer.shadowRadius = 24;
    bottomCardView.layer.shadowOpacity = 0.22;
    bottomCardView.userInteractionEnabled = YES;
    [containerView addSubview:bottomCardView];
    self.fullscreenBottomCardView = bottomCardView;

    self.fullscreenIconImageView = [[UIImageView alloc] init];
    self.fullscreenIconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.fullscreenIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.fullscreenIconImageView.clipsToBounds = YES;
    self.fullscreenIconImageView.layer.cornerRadius = 10;
    self.fullscreenIconImageView.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.96 alpha:1.0];
    [bottomCardView addSubview:self.fullscreenIconImageView];

    self.fullscreenAdView.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fullscreenAdView.titleLabel.text = self.nativeObj.title ?: @"广告";
    self.fullscreenAdView.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    self.fullscreenAdView.titleLabel.textColor = [UIColor colorWithRed:0.10 green:0.12 blue:0.16 alpha:1.0];
    self.fullscreenAdView.titleLabel.numberOfLines = 1;
    self.fullscreenAdView.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [bottomCardView addSubview:self.fullscreenAdView.titleLabel];

    self.fullscreenAdView.descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fullscreenAdView.descLabel.text = self.nativeObj.desc ?: @"";
    self.fullscreenAdView.descLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    self.fullscreenAdView.descLabel.textColor = [UIColor colorWithRed:0.38 green:0.42 blue:0.50 alpha:1.0];
    self.fullscreenAdView.descLabel.numberOfLines = 2;
    self.fullscreenAdView.descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [bottomCardView addSubview:self.fullscreenAdView.descLabel];

    self.fullscreenAdView.logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.fullscreenAdView.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bottomCardView addSubview:self.fullscreenAdView.logoImageView];

    UILabel *adTagLabel = [[UILabel alloc] init];
    adTagLabel.translatesAutoresizingMaskIntoConstraints = NO;
    adTagLabel.text = @"广告";
    adTagLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    adTagLabel.textAlignment = NSTextAlignmentCenter;
    adTagLabel.textColor = [UIColor colorWithRed:0.42 green:0.46 blue:0.52 alpha:1.0];
    adTagLabel.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.96 alpha:1.0];
    adTagLabel.layer.cornerRadius = 4;
    adTagLabel.layer.masksToBounds = YES;
    [bottomCardView addSubview:adTagLabel];

    self.fullscreenDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fullscreenDetailButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.fullscreenDetailButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.23 blue:0.17 alpha:1.0];
    self.fullscreenDetailButton.layer.cornerRadius = 18;
    self.fullscreenDetailButton.userInteractionEnabled = YES;
    self.fullscreenDetailButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    [self.fullscreenDetailButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [self.fullscreenDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomCardView addSubview:self.fullscreenDetailButton];

    UILayoutGuide *safeGuide = containerView.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [bottomCardView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:16],
        [bottomCardView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-16],
        [bottomCardView.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor constant:-18],
        [bottomCardView.heightAnchor constraintGreaterThanOrEqualToConstant:140],

        [self.fullscreenIconImageView.topAnchor constraintEqualToAnchor:bottomCardView.topAnchor constant:18],
        [self.fullscreenIconImageView.leadingAnchor constraintEqualToAnchor:bottomCardView.leadingAnchor constant:16],
        [self.fullscreenIconImageView.widthAnchor constraintEqualToConstant:50],
        [self.fullscreenIconImageView.heightAnchor constraintEqualToConstant:50],

        [self.fullscreenAdView.logoImageView.topAnchor constraintEqualToAnchor:bottomCardView.topAnchor constant:18],
        [self.fullscreenAdView.logoImageView.trailingAnchor constraintEqualToAnchor:bottomCardView.trailingAnchor constant:-16],
        [self.fullscreenAdView.logoImageView.widthAnchor constraintEqualToConstant:66],
        [self.fullscreenAdView.logoImageView.heightAnchor constraintEqualToConstant:24],

        [self.fullscreenAdView.titleLabel.topAnchor constraintEqualToAnchor:self.fullscreenIconImageView.topAnchor constant:1],
        [self.fullscreenAdView.titleLabel.leadingAnchor constraintEqualToAnchor:self.fullscreenIconImageView.trailingAnchor constant:12],
        [self.fullscreenAdView.titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.fullscreenAdView.logoImageView.leadingAnchor constant:-10],
        [self.fullscreenAdView.titleLabel.heightAnchor constraintEqualToConstant:22],

        [self.fullscreenAdView.descLabel.topAnchor constraintEqualToAnchor:self.fullscreenAdView.titleLabel.bottomAnchor constant:5],
        [self.fullscreenAdView.descLabel.leadingAnchor constraintEqualToAnchor:self.fullscreenAdView.titleLabel.leadingAnchor],
        [self.fullscreenAdView.descLabel.trailingAnchor constraintEqualToAnchor:bottomCardView.trailingAnchor constant:-16],

        [adTagLabel.leadingAnchor constraintEqualToAnchor:self.fullscreenAdView.titleLabel.leadingAnchor],
        [adTagLabel.bottomAnchor constraintEqualToAnchor:bottomCardView.bottomAnchor constant:-20],
        [adTagLabel.widthAnchor constraintEqualToConstant:36],
        [adTagLabel.heightAnchor constraintEqualToConstant:20],

        [self.fullscreenDetailButton.trailingAnchor constraintEqualToAnchor:bottomCardView.trailingAnchor constant:-16],
        [self.fullscreenDetailButton.bottomAnchor constraintEqualToAnchor:bottomCardView.bottomAnchor constant:-14],
        [self.fullscreenDetailButton.widthAnchor constraintEqualToConstant:104],
        [self.fullscreenDetailButton.heightAnchor constraintEqualToConstant:36],
        [self.fullscreenDetailButton.leadingAnchor constraintGreaterThanOrEqualToAnchor:adTagLabel.trailingAnchor constant:12],

        [self.fullscreenAdView.descLabel.bottomAnchor constraintLessThanOrEqualToAnchor:self.fullscreenDetailButton.topAnchor constant:-10],
    ]];

    [self populateFullscreenIconAndLogo];
}

- (void)populateFullscreenIconAndLogo {
    self.fullscreenIconImageView.image = [UIImage systemImageNamed:@"app.fill"];
    self.fullscreenIconImageView.tintColor = [UIColor colorWithRed:0.48 green:0.53 blue:0.60 alpha:1.0];
    self.fullscreenIconImageView.contentMode = UIViewContentModeCenter;

    __weak typeof(self) weakSelf = self;
    [self loadImageWithURLString:self.nativeObj.iconUrl completion:^(UIImage *image) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || strongSelf.fullscreenAdOverlayView.superview == nil) {
            return;
        }
        strongSelf.fullscreenIconImageView.contentMode = UIViewContentModeScaleAspectFill;
        strongSelf.fullscreenIconImageView.image = image;
    }];

    UIImage *logoImage = self.nativeObj.logoImage;
    self.fullscreenAdView.logoImageView.hidden = (logoImage == nil && self.nativeObj.logoUrl.length == 0);
    self.fullscreenAdView.logoImageView.image = logoImage;
    [self loadImageWithURLString:self.nativeObj.logoUrl completion:^(UIImage *image) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || strongSelf.fullscreenAdOverlayView.superview == nil) {
            return;
        }
        strongSelf.fullscreenAdView.logoImageView.hidden = NO;
        strongSelf.fullscreenAdView.logoImageView.image = image;
    }];
}

- (void)setupFullscreenCloseButton {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    closeButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.42];
    closeButton.layer.cornerRadius = 22;
    closeButton.tintColor = [UIColor whiteColor];
    UIImage *closeImage = [UIImage systemImageNamed:@"xmark"];
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeFullscreenButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullscreenAdOverlayView addSubview:closeButton];

    [NSLayoutConstraint activateConstraints:@[
        [closeButton.topAnchor constraintEqualToAnchor:self.fullscreenAdOverlayView.safeAreaLayoutGuide.topAnchor constant:12],
        [closeButton.trailingAnchor constraintEqualToAnchor:self.fullscreenAdOverlayView.trailingAnchor constant:-16],
        [closeButton.widthAnchor constraintEqualToConstant:44],
        [closeButton.heightAnchor constraintEqualToConstant:44],
    ]];
}

- (void)setupFullscreenMuteButtonIfNeeded {
    if (!self.nativeObj.isVideoAd) {
        return;
    }

    UIView *containerView = self.fullscreenAdPageView ?: self.fullscreenAdOverlayView;
    UIButton *muteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    muteButton.translatesAutoresizingMaskIntoConstraints = NO;
    muteButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.42];
    muteButton.layer.cornerRadius = 22;
    muteButton.tintColor = [UIColor whiteColor];
    muteButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    muteButton.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);
    muteButton.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
    muteButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    [muteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [muteButton addTarget:self action:@selector(fullscreenMuteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:muteButton];
    self.fullscreenMuteButton = muteButton;
    [self updateFullscreenMuteButton];

    [NSLayoutConstraint activateConstraints:@[
        [muteButton.topAnchor constraintEqualToAnchor:containerView.safeAreaLayoutGuide.topAnchor constant:12],
        [muteButton.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:16],
        [muteButton.widthAnchor constraintGreaterThanOrEqualToConstant:88],
        [muteButton.heightAnchor constraintEqualToConstant:44],
    ]];
}

- (void)updateFullscreenMuteButton {
    NSString *imageName = self.fullscreenMuted ? @"speaker.slash.fill" : @"speaker.wave.2.fill";
    NSString *title = self.fullscreenMuted ? @"静音" : @"非静音";
    UIImage *image = [UIImage systemImageNamed:imageName];
    [self.fullscreenMuteButton setImage:image forState:UIControlStateNormal];
    [self.fullscreenMuteButton setTitle:title forState:UIControlStateNormal];
    self.fullscreenMuteButton.accessibilityLabel = self.fullscreenMuted ? @"全屏信息流已静音" : @"全屏信息流非静音";
}

- (void)bindFullscreenAdContentIfNeeded {
    if (self.hasBoundFullscreenAdContent || !self.fullscreenAdView.superview) {
        return;
    }
    [self.fullscreenAdOverlayView layoutIfNeeded];
    [self.fullscreenAdView layoutIfNeeded];
    [self.fullscreenAdView.mediaView layoutIfNeeded];

    NSMutableArray<UIView *> *clickableViews = [NSMutableArray array];
    UIImageView *mainImageView = self.fullscreenAdView.imageView;
    if (self.nativeObj.isVideoAd) {
        if ([self isFLinkNativeAd]) {
            [clickableViews addObject:self.fullscreenAdView];
            [clickableViews addObject:self.fullscreenAdView.mediaView];
            [clickableViews addObject:self.fullscreenAdView.imageView];
        } else {
            [clickableViews addObject:self.fullscreenAdView.mediaView];
        }
    } else {
        [clickableViews addObject:self.fullscreenAdView.imageView];
    }
    [clickableViews addObject:self.fullscreenBottomCardView];
    [clickableViews addObject:self.fullscreenDetailButton];

    [self applyFullscreenMutedState];
    [self.nativeAd registerContainer:self.fullscreenAdView
                       mainImageView:mainImageView
                  withClickableViews:clickableViews];
    self.hasBoundFullscreenAdContent = YES;
    [self.fullscreenAdView refreshData:self.nativeAd];
    [self applyFullscreenMutedState];
    [self updateFullscreenEpisodePlaybackForCurrentPage];
}

- (void)closeFullscreenButtonTapped:(UIButton *)sender {
    [self removeFullscreenNativeAdViewAndUpdateStatus:YES];
}

- (void)fullscreenMuteButtonTapped:(UIButton *)sender {
    self.fullscreenMuted = !self.fullscreenMuted;
    [self applyFullscreenMutedState];
}

- (void)applyFullscreenMutedState {
    if (!self.nativeObj.isVideoAd) {
        return;
    }
    self.nativeAd.shouldMuted = self.fullscreenMuted;
    [self updateFullscreenMuteButton];
}

- (void)scrollFullscreenPagerToAdPageAnimated:(BOOL)animated {
    CGFloat pageHeight = CGRectGetHeight(self.fullscreenEpisodeScrollView.bounds);
    if (pageHeight <= 0) {
        return;
    }
    [self.fullscreenEpisodeScrollView setContentOffset:CGPointMake(0, pageHeight) animated:animated];
}

- (NSInteger)currentFullscreenPageIndex {
    CGFloat pageHeight = CGRectGetHeight(self.fullscreenEpisodeScrollView.bounds);
    if (pageHeight <= 0) {
        return 1;
    }
    NSInteger pageIndex = (NSInteger)llround(self.fullscreenEpisodeScrollView.contentOffset.y / pageHeight);
    return MAX(0, MIN(2, pageIndex));
}

- (void)updateFullscreenEpisodePlaybackForCurrentPage {
    if (!self.fullscreenAdOverlayView.superview) {
        return;
    }

    NSInteger pageIndex = [self currentFullscreenPageIndex];
    NSInteger activeEpisodeIndex = NSNotFound;
    if (pageIndex == 0) {
        activeEpisodeIndex = 0;
    } else if (pageIndex == 2) {
        activeEpisodeIndex = 1;
    }

    for (NSInteger index = 0; index < self.fullscreenEpisodePlayers.count; index++) {
        AVPlayer *player = self.fullscreenEpisodePlayers[index];
        if (index == activeEpisodeIndex) {
            [self configureFullscreenEpisodeAudioSession];
            [player play];
        } else {
            [player pause];
        }
    }

    if (!self.nativeObj.isVideoAd) {
        return;
    }
    if (pageIndex == 1 && self.hasBoundFullscreenAdContent) {
        [self.fullscreenAdView.mediaView play];
    } else {
        [self.fullscreenAdView.mediaView pause];
    }
}

- (void)configureFullscreenEpisodeAudioSession {
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                     withOptions:AVAudioSessionCategoryOptionMixWithOthers
                                           error:&error];
    if (error) {
        NSLog(@"setCategory Playback failed: %@", error);
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)updateFullscreenEpisodePlayerLayerFrames {
    NSUInteger count = MIN(self.fullscreenEpisodePlayerLayers.count, self.fullscreenEpisodeVideoSurfaces.count);
    for (NSUInteger index = 0; index < count; index++) {
        AVPlayerLayer *playerLayer = self.fullscreenEpisodePlayerLayers[index];
        UIView *videoSurface = self.fullscreenEpisodeVideoSurfaces[index];
        if (!CGRectEqualToRect(playerLayer.frame, videoSurface.bounds)) {
            playerLayer.frame = videoSurface.bounds;
        }
    }
}

- (void)fullscreenEpisodeDidReachEnd:(NSNotification *)note {
    AVPlayerItem *item = note.object;
    [item seekToTime:kCMTimeZero completionHandler:nil];
    if ([self currentFullscreenPageIndex] != 1) {
        [self updateFullscreenEpisodePlaybackForCurrentPage];
    }
}

- (void)pauseFullscreenEpisodePlayers {
    for (AVPlayer *player in self.fullscreenEpisodePlayers) {
        [player pause];
    }
}

- (void)clearFullscreenEpisodePlayers {
    for (AVPlayer *player in self.fullscreenEpisodePlayers) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:player.currentItem];
        [player pause];
    }
    self.fullscreenEpisodePlayers = nil;
    self.fullscreenEpisodePlayerLayers = nil;
    self.fullscreenEpisodeVideoSurfaces = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.fullscreenEpisodeScrollView) {
        [self updateFullscreenEpisodePlaybackForCurrentPage];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.fullscreenEpisodeScrollView && !decelerate) {
        [self updateFullscreenEpisodePlaybackForCurrentPage];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.fullscreenEpisodeScrollView) {
        [self updateFullscreenEpisodePlaybackForCurrentPage];
    }
}

- (void)removeFullscreenNativeAdViewAndUpdateStatus:(BOOL)updateStatus {
    [self clearFullscreenEpisodePlayers];
    [self.fullscreenAdView.mediaView stop];
    self.fullscreenEpisodeScrollView.delegate = nil;
    [self.fullscreenAdOverlayView removeFromSuperview];
    self.fullscreenAdOverlayView = nil;
    self.fullscreenEpisodeScrollView = nil;
    self.fullscreenAdPageView = nil;
    self.fullscreenAdView = nil;
    self.fullscreenBottomCardView = nil;
    self.fullscreenIconImageView = nil;
    self.fullscreenDetailButton = nil;
    self.fullscreenMuteButton = nil;
    self.hasBoundFullscreenAdContent = NO;

    if (!updateStatus) {
        return;
    }
    if ([self.nativeAd isReady]) {
        [self updateStatus:AdStatusLoaded];
    } else {
        [self updateStatus:AdStatusIdle];
    }
}

- (BOOL)isFLinkNativeAd {
    NSString *platform = self.nativeAd.adInfo.platform;
    if (platform.length == 0) {
        platform = AppConfig.selectedPlatforms.firstObject;
    }
    platform = platform.uppercaseString;
    return [platform isEqualToString:@"FL"];
}

- (void)loadImageWithURLString:(NSString *)urlString completion:(void (^)(UIImage *image))completion {
    if (urlString.length == 0 || completion == nil) {
        return;
    }

    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = data.length > 0 ? [UIImage imageWithData:data] : nil;
        if (!image) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

- (void)showImageNativeAd {
    // 图片
    self.customAdView = [[NativeFeedAdView alloc] init];
    [self configureNativeAdContainer:self.customAdView];
    [self.containerView addSubview:self.customAdView];
    self.customAdView.frame = self.containerView.bounds;
    self.customAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGRect frame = self.customAdView.bounds;
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;

    CGFloat mediaPadding = 6;
    CGFloat mediaWidth = MIN(112, w * 0.34);
    CGRect imageArea = CGRectMake(mediaPadding, mediaPadding, mediaWidth, MAX(0, h - mediaPadding * 2));
    self.customAdView.imageView.frame = imageArea;
    self.customAdView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.customAdView.imageView.clipsToBounds = YES;
    self.customAdView.imageView.layer.cornerRadius = 0;
    self.customAdView.imageView.layer.masksToBounds = YES;
    if (self.nativeObj.imageAdInfo) {
        AdbidNativeImageObj * objc = self.nativeObj.imageAdInfo;
        NSURL *imageUrl = [NSURL URLWithString:objc.imageUrl];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imgData = [NSData dataWithContentsOfURL:imageUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *img = [UIImage imageWithData:imgData];
                self.customAdView.imageView.image = img;
            });
        });
    }

    UIView *infoBar = [self addBottomInfoBarToAdView:self.customAdView
                                               frame:CGRectMake(mediaWidth + mediaPadding * 2, 0, MAX(0, w - mediaWidth - mediaPadding * 2), h)];
    [self.customAdView bringSubviewToFront:infoBar];
    
    self.customAdView.imageView.userInteractionEnabled=YES;
    infoBar.userInteractionEnabled = YES;
    self.customAdView.descLabel.userInteractionEnabled=YES;
    [self.nativeAd registerContainer:self.customAdView
                       mainImageView: self.customAdView.imageView
                  withClickableViews:@[self.customAdView, infoBar]];
}

- (void)showVideoNativeAd {
    // 视频
    self.customAdView = [[NativeFeedAdView alloc] init];
    [self configureNativeAdContainer:self.customAdView];
    [self.containerView addSubview:self.customAdView];
    self.customAdView.frame = self.containerView.bounds;
    self.customAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGRect frame = self.customAdView.bounds;
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    CGFloat mediaPadding = 6;
    CGFloat mediaWidth = MIN(112, w * 0.34);
    // 视频视图
 
    if (self.customAdView.mediaView.superview) {
        [self.customAdView.mediaView removeFromSuperview];
    }
    // 插入到最底层
    [self.customAdView insertSubview:self.customAdView.mediaView atIndex:0];

    BOOL useAutoLayout = (self.mediaLayoutControl.selectedSegmentIndex == 1);
    if (useAutoLayout) {
        self.customAdView.mediaView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.customAdView.mediaView.topAnchor constraintEqualToAnchor:self.customAdView.topAnchor constant:mediaPadding],
            [self.customAdView.mediaView.leadingAnchor constraintEqualToAnchor:self.customAdView.leadingAnchor constant:mediaPadding],
            [self.customAdView.mediaView.widthAnchor constraintEqualToConstant:mediaWidth],
            [self.customAdView.mediaView.bottomAnchor constraintEqualToAnchor:self.customAdView.bottomAnchor constant:-mediaPadding]
        ]];
        [self.customAdView layoutIfNeeded];
    } else {
        self.customAdView.mediaView.translatesAutoresizingMaskIntoConstraints = YES;
        self.customAdView.mediaView.frame = CGRectMake(mediaPadding, mediaPadding, mediaWidth, MAX(0, h - mediaPadding * 2));
    }
    [self.customAdView layoutIfNeeded];
    self.customAdView.mediaView.delegate = self;
    self.customAdView.mediaView.layer.cornerRadius = 0;
    self.customAdView.mediaView.layer.masksToBounds = YES;

    UIView *infoBar = [self addBottomInfoBarToAdView:self.customAdView
                                               frame:CGRectMake(mediaWidth + mediaPadding * 2, 0, MAX(0, w - mediaWidth - mediaPadding * 2), h)];
    [self.customAdView bringSubviewToFront:infoBar];
    self.nativeAd.shouldMuted = NO;
    // 给视图绑定点击事件
    [self.nativeAd registerContainer:self.customAdView
                       mainImageView: self.customAdView.imageView
                  withClickableViews:@[self.customAdView.mediaView, infoBar]];
    // 播放视频（refreshData 内部会把 shouldMuted 同步到 mediaView）
    [self.customAdView refreshData:self.nativeAd];
}

- (void)configureNativeAdContainer:(NativeFeedAdView *)adView {
    adView.backgroundColor = [UIColor colorWithRed:0.08 green:0.09 blue:0.11 alpha:1.0];
    adView.layer.cornerRadius = 0;
    adView.layer.masksToBounds = NO;
    adView.layer.borderWidth = 0;
    adView.layer.borderColor = nil;
}

- (UIView *)addBottomInfoBarToAdView:(NativeFeedAdView *)adView frame:(CGRect)frame {
    UIView *infoBar = [[UIView alloc] initWithFrame:frame];
    infoBar.backgroundColor = [UIColor colorWithRed:0.08 green:0.09 blue:0.11 alpha:1.0];
    infoBar.userInteractionEnabled = YES;
    [adView addSubview:infoBar];
    [adView bringSubviewToFront:infoBar];

    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 0.5, frame.size.height - 16)];
    divider.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.12];
    [infoBar addSubview:divider];

    CGFloat horizontalPadding = 10;
    CGFloat tagWidth = 30;
    CGFloat tagHeight = 16;
    CGFloat ctaWidth = 62;
    CGFloat ctaHeight = 26;
    CGFloat ctaX = frame.size.width - horizontalPadding - ctaWidth;
    CGFloat textX = horizontalPadding;
    CGFloat textWidth = MAX(0, ctaX - textX - 8);

    adView.titleLabel.text = self.nativeObj.title ?: @"广告";
    adView.titleLabel.frame = CGRectMake(textX, 8, textWidth, 21);
    adView.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    adView.titleLabel.textColor = [UIColor whiteColor];
    adView.titleLabel.backgroundColor = [UIColor clearColor];
    adView.titleLabel.numberOfLines = 1;
    adView.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [infoBar addSubview:adView.titleLabel];

    adView.descLabel.text = self.nativeObj.desc ?: @"";
    adView.descLabel.frame = CGRectMake(textX + tagWidth + 6, 34, MAX(0, textWidth - tagWidth - 6), 18);
    adView.descLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    adView.descLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.68];
    adView.descLabel.backgroundColor = [UIColor clearColor];
    adView.descLabel.numberOfLines = 1;
    adView.descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [infoBar addSubview:adView.descLabel];

    UILabel *adTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(textX, 35, tagWidth, tagHeight)];
    adTagLabel.text = @"广告";
    adTagLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    adTagLabel.textAlignment = NSTextAlignmentCenter;
    adTagLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.78];
    adTagLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.14];
    adTagLabel.layer.cornerRadius = 3;
    adTagLabel.layer.masksToBounds = YES;
    [infoBar addSubview:adTagLabel];

    UIButton *ctaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ctaButton.frame = CGRectMake(ctaX, (frame.size.height - ctaHeight) / 2.0, ctaWidth, ctaHeight);
    ctaButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.23 blue:0.17 alpha:1.0];
    ctaButton.layer.cornerRadius = 13;
    ctaButton.layer.masksToBounds = YES;
    ctaButton.userInteractionEnabled = NO;
    ctaButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    [ctaButton setTitle:@"查看" forState:UIControlStateNormal];
    [ctaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [infoBar addSubview:ctaButton];

    return infoBar;
}

#pragma mark - Status Management

- (void)updateStatus:(AdStatus)status {
    [self performOnMainThread:^{
        self.currentStatus = status;
        [self updateUIForStatus:status];
    }];
}

- (void)updateUIForStatus:(AdStatus)status {
    NSString *statusText = @"";
    UIColor *statusColor = [UIColor blackColor];

    switch (status) {
        case AdStatusIdle:
            statusText = @"📱 状态：空闲\n点击 Load 按钮加载广告";
            statusColor = [UIColor systemGrayColor];
            self.loadButton.enabled = YES;
            self.showButton.enabled = NO;
            break;

        case AdStatusLoading:
            statusText = @"⏳ 状态：加载中\n正在请求广告数据...";
            statusColor = [UIColor systemBlueColor];
            self.loadButton.enabled = NO;
            self.showButton.enabled = NO;
            break;

        case AdStatusLoaded:
            statusText = @"✅ 状态：已加载\n广告数据加载成功，可以展示";
            statusColor = [UIColor systemGreenColor];
            self.loadButton.enabled = YES;
            self.showButton.enabled = YES;
            break;

        case AdStatusShowing:
            statusText = @"👁 状态：展示中\n广告正在展示给用户";
            statusColor = [UIColor systemOrangeColor];
            self.loadButton.enabled = YES;
            self.showButton.enabled = NO;
            break;

        case AdStatusError:
            statusText = @"❌ 状态：错误\n广告加载失败，请重试";
            statusColor = [UIColor systemRedColor];
            self.loadButton.enabled = YES;
            self.showButton.enabled = NO;
            break;
    }

    self.statusLabel.text = statusText;
    self.statusLabel.textColor = statusColor;

    // 更新按钮样式
    [self updateButtonStyles];
}

- (void)updateButtonStyles {
    // Load按钮样式
    if (self.loadButton.enabled) {
        self.loadButton.backgroundColor = [self primaryColor];
        self.loadButton.alpha = 1.0;
    } else {
        self.loadButton.backgroundColor = [UIColor colorWithRed:0.58 green:0.62 blue:0.68 alpha:1.0];
        self.loadButton.alpha = 0.6;
    }

    // Show按钮样式
    if (self.showButton.enabled) {
        self.showButton.backgroundColor = [UIColor colorWithRed:0.18 green:0.65 blue:0.35 alpha:1.0];
        self.showButton.alpha = 1.0;
    } else {
        self.showButton.backgroundColor = [UIColor colorWithRed:0.58 green:0.62 blue:0.68 alpha:1.0];
        self.showButton.alpha = 0.6;
    }
}

- (void)winNoticeButtonTapped:(UIButton *)sender {
    NSLog(@"winNoticeButtonTapped");
    if (self.nativeAd && self.nativeAd.data) {
        self.statusLabel.text = @"正在上报竞胜...";
        self.statusLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
        [self.nativeAd winNotice:self.nativeAd.eCPM];
        self.statusLabel.text = [NSString stringWithFormat:@"竞胜上报成功\n价格: %ld", (long)self.nativeAd.eCPM];
    } else {
        self.statusLabel.text = @"请先加载广告";
        self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0];
    }
}

- (void)lossNoticeButtonTapped:(UIButton *)sender {
    NSLog(@"lossNoticeButtonTapped");
    if (self.nativeAd && self.nativeAd.data) {
        self.statusLabel.text = @"正在上报竞败...";
        self.statusLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];

        AdbidBidLossInfo *info = [[AdbidBidLossInfo alloc] init];
        info.winnerPrice = self.nativeAd.eCPM + 10; // 模拟竞胜价格高于我方
        info.winnerPlatform = AdbidPlatform_GDT; // 模拟广点通竞胜

        [self.nativeAd lossNotice:info];
        self.statusLabel.text = [NSString stringWithFormat:@"竞败上报成功\n竞胜价格: %ld", (long)info.winnerPrice];
    } else {
        self.statusLabel.text = @"请先加载广告";
        self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0];
    }
}

#pragma mark - 测试视频（验证 native 广告是否打断其他播放器）

- (void)testVideoButtonTapped:(UIButton *)sender {
    if (self.testVideoPlayer.rate > 0) {
        [self.testVideoPlayer pause];
        [sender setTitle:@"▶️ 播放测试视频" forState:UIControlStateNormal];
        return;
    }

    // 模拟典型宿主播放器：Playback + MixWithOthers
    // - Playback：忽略侧边静音键，正常出声
    // - MixWithOthers：允许 SDK 内的广告视频音轨与本视频混音，互不打断
    NSError *err = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                     withOptions:AVAudioSessionCategoryOptionMixWithOthers
                                           error:&err];
    if (err) {
        NSLog(@"setCategory Playback failed: %@", err);
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [self updateTestVideoLayerFrame];
    self.testVideoPlaceholderLabel.hidden = YES;
    [self.testVideoPlayer play];
    [sender setTitle:@"⏸ 暂停测试视频" forState:UIControlStateNormal];
}

- (void)testVideoToggleButtonTapped:(UIButton *)sender {
    [self setTestVideoExpanded:!self.testVideoExpanded animated:YES];
}

- (void)setTestVideoExpanded:(BOOL)expanded animated:(BOOL)animated {
    self.testVideoExpanded = expanded;
    self.testVideoContainerHeightConstraint.constant = expanded ? 240 : 52;
    if (expanded) {
        [NSLayoutConstraint activateConstraints:self.testVideoExpandedConstraints];
    } else {
        [NSLayoutConstraint deactivateConstraints:self.testVideoExpandedConstraints];
    }
    self.testVideoSurface.hidden = !expanded;
    self.testVideoButton.hidden = !expanded;
    [self.testVideoToggleButton setTitle:(expanded ? @"收起" : @"展开") forState:UIControlStateNormal];

    if (!expanded) {
        [self.testVideoPlayer pause];
        [self.testVideoButton setTitle:@"▶️ 播放测试视频" forState:UIControlStateNormal];
        self.testVideoPlaceholderLabel.hidden = NO;
    }

    void (^layoutBlock)(void) = ^{
        [self.view layoutIfNeeded];
        [self updateTestVideoLayerFrame];
    };
    if (animated) {
        [UIView animateWithDuration:0.25 animations:layoutBlock];
    } else {
        layoutBlock();
    }
}

- (void)updateTestVideoLayerFrame {
    if (_testVideoLayer && !CGRectEqualToRect(_testVideoLayer.frame, self.testVideoSurface.bounds)) {
        _testVideoLayer.frame = self.testVideoSurface.bounds;
    }
}

- (void)testVideoDidReachEnd:(NSNotification *)note {
    AVPlayerItem *item = note.object;
    if (item == self.testVideoPlayer.currentItem) {
        [item seekToTime:kCMTimeZero completionHandler:nil];
        [self.testVideoPlayer play];
    }
}

#pragma mark - AdbidNativeAdDelegate

- (void)nativeAdDidLoad:(AdbidNativeAd *)nativeAd {
    NSLog(@"nativeAdDidLoad");
    [self performOnMainThread:^{
        self.nativeObj = nativeAd.data;
        self.prefetchedVideoCoverImage = nil;
        [self prefetchVideoCoverImageIfNeeded:nativeAd.data];
        [self updateStatus:AdStatusLoaded];
    }];
}

- (void)prefetchVideoCoverImageIfNeeded:(AdbidNativeObj *)nativeObj {
    NSString *coverImageUrl = (nativeObj.isVideoAd && !nativeObj.externalMediaView) ? nativeObj.videoAdInfo.coverImageUrl : nil;
    if (coverImageUrl.length == 0) {
        return;
    }

    NSURL *url = [NSURL URLWithString:coverImageUrl];
    if (!url) {
        return;
    }

    self.prefetchingVideoCoverUrl = coverImageUrl;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = data.length > 0 ? [UIImage imageWithData:data] : nil;
        if (!image) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakSelf.prefetchingVideoCoverUrl isEqualToString:coverImageUrl]) {
                weakSelf.prefetchedVideoCoverImage = image;
            }
        });
    });
}

// 广告加载失败回调
- (void)nativeAd:(AdbidNativeAd *)nativeAd didFailToLoadWithError:(NSError *)error {
    NSLog(@"nativeAd didFailToLoadWithError: %@", error);
    [self performOnMainThread:^{
        [self updateStatus:AdStatusError];
    }];
}

// 当自渲染广告被点击时调用
- (void)nativeAdViewDidClick:(AdbidNativeAd *)nativeAd withView:(UIView *_Nullable)view {
    NSLog(@"nativeAdViewDidClick");
}

// 广告曝光回调
- (void)nativeAdViewDidExpose:(AdbidNativeAd *)nativeAd {
    NSLog(@"nativeAdViewDidExpose");
}

// MARK: - LMNativeMediaViewDelegate

- (void)nativeMediaViewDidClick:(AdbidNativeMediaView *)mediaView {
    NSLog(@"nativeMediaViewDidClick");
}
/**
 开始播放
 */
- (void)nativeMediaViewReadyToPlay:(AdbidNativeMediaView *)mediaView {
    NSLog(@"nativeMediaViewReadyToPlay");
}

/**
 播放完成回调
 @param mediaView 播放器实例
 */
- (void)nativeMediaViewDidPlayFinished:(AdbidNativeMediaView *)mediaView {
    NSLog(@"nativeMediaViewDidPlayFinished");
}
/**
 播放失败回调
 */
- (void)nativeMediaView:(AdbidNativeMediaView *)mediaView didPlayFailWithError:(NSError *_Nullable)error {
    NSLog(@"nativeMediaView didPlayFailWithError: %@", error);
}

#pragma mark - Lazy Loading

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}

- (void)configurePlatformRightViewForTextField:(UITextField *)textField {
    NSString *platform = AppConfig.selectedPlatforms.firstObject ?: @"other";
    UILabel *platformLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 52, 24)];
    platformLabel.text = platform;
    platformLabel.textAlignment = NSTextAlignmentCenter;
    platformLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    platformLabel.textColor = [UIColor darkGrayColor];
    textField.rightView = platformLabel;
    textField.rightViewMode = UITextFieldViewModeAlways;
}

- (UIColor *)primaryColor {
    return [UIColor colorWithRed:0.18 green:0.48 blue:0.95 alpha:1.0];
}

- (void)configureCardView:(UIView *)view {
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 12;
    view.layer.shadowColor = [UIColor colorWithWhite:0 alpha:1.0].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 4);
    view.layer.shadowRadius = 16;
    view.layer.shadowOpacity = 0.06;
}

- (void)configureActionButton:(UIButton *)button backgroundColor:(UIColor *)backgroundColor {
    button.backgroundColor = backgroundColor;
    button.layer.cornerRadius = 10;
    button.layer.shadowColor = backgroundColor.CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 4);
    button.layer.shadowRadius = 10;
    button.layer.shadowOpacity = 0.16;
    button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
}

- (UIView *)controlPanel {
    if (!_controlPanel) {
        _controlPanel = [[UIView alloc] init];
        [self configureCardView:_controlPanel];
    }
    return _controlPanel;
}

- (UITextField *)slotIdTextField {
    if (!_slotIdTextField) {
        _slotIdTextField = [[UITextField alloc] init];
        _slotIdTextField.placeholder = @"请输入广告位ID";
        _slotIdTextField.text =AppConfig.nativeDrawID;  // 默认广告位ID
        _slotIdTextField.borderStyle = UITextBorderStyleRoundedRect;
        _slotIdTextField.font = [UIFont systemFontOfSize:16];
        _slotIdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _slotIdTextField.backgroundColor = [UIColor whiteColor];
        _slotIdTextField.layer.cornerRadius = 10;
        _slotIdTextField.layer.borderWidth = 1;
        _slotIdTextField.layer.borderColor = [UIColor colorWithWhite:0.88 alpha:1.0].CGColor;
        [self configurePlatformRightViewForTextField:_slotIdTextField];
    }
    return _slotIdTextField;
}

- (UISegmentedControl *)mediaLayoutControl {
    if (!_mediaLayoutControl) {
        _mediaLayoutControl = [[UISegmentedControl alloc] initWithItems:@[@"Frame", @"Auto Layout"]];
        _mediaLayoutControl.selectedSegmentIndex = 0;
    }
    return _mediaLayoutControl;
}

- (UIButton *)loadButton {
    if (!_loadButton) {
        _loadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadButton setTitle:@"🔄 Load Ad" forState:UIControlStateNormal];
        [_loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self configureActionButton:_loadButton backgroundColor:[self primaryColor]];
        [_loadButton addTarget:self action:@selector(loadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadButton;
}

- (UIButton *)showButton {
    if (!_showButton) {
        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showButton setTitle:@"👁 Show Ad" forState:UIControlStateNormal];
        [_showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self configureActionButton:_showButton backgroundColor:[UIColor colorWithRed:0.18 green:0.65 blue:0.35 alpha:1.0]];
        [_showButton addTarget:self action:@selector(showButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showButton;
}

- (UIButton *)winNoticeButton {
    if (!_winNoticeButton) {
        _winNoticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_winNoticeButton setTitle:@"竞胜上报" forState:UIControlStateNormal];
        [_winNoticeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self configureActionButton:_winNoticeButton backgroundColor:[UIColor colorWithRed:0.18 green:0.65 blue:0.35 alpha:1.0]];
        [_winNoticeButton addTarget:self action:@selector(winNoticeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
       // [_winNoticeButton setHidden:YES];
    }
    return _winNoticeButton;
}

- (UIButton *)lossNoticeButton {
    if (!_lossNoticeButton) {
        _lossNoticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lossNoticeButton setTitle:@"竞败上报" forState:UIControlStateNormal];
        [_lossNoticeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self configureActionButton:_lossNoticeButton backgroundColor:[UIColor colorWithRed:0.42 green:0.46 blue:0.52 alpha:1.0]];
        [_lossNoticeButton addTarget:self action:@selector(lossNoticeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
       // [_lossNoticeButton setHidden:YES];
    }
    return _lossNoticeButton;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.numberOfLines = 0;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = [UIFont systemFontOfSize:14];
        _statusLabel.backgroundColor = [UIColor colorWithRed:0.96 green:0.98 blue:1.0 alpha:1.0];
        _statusLabel.layer.cornerRadius = 10;
        _statusLabel.layer.masksToBounds = YES;
        _statusLabel.text = @"📱 状态：空闲\n点击 Load 按钮加载广告";
        _statusLabel.textColor = [UIColor systemGrayColor];
    }
    return _statusLabel;
}

- (UIView *)adContainerView {
    if (!_adContainerView) {
        _adContainerView = [[UIView alloc] init];
        _adContainerView.backgroundColor = [UIColor clearColor];
    }
    return _adContainerView;
}

- (UILabel *)containerView {
    if (!_containerView) {
        _containerView = [[UILabel alloc] init];
        _containerView.frame = CGRectMake(20, 20, 0, 50);  // 宽度会被约束覆盖
        _containerView.userInteractionEnabled = YES;
        _containerView.textAlignment = NSTextAlignmentCenter;
        _containerView.text = @"广告展示区域\n广告内容将在这里显示";
        _containerView.numberOfLines = 0;
        _containerView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _containerView.textColor = [UIColor colorWithRed:0.42 green:0.46 blue:0.52 alpha:1.0];
        _containerView.backgroundColor = [UIColor colorWithRed:0.96 green:0.98 blue:1.0 alpha:1.0];
        _containerView.layer.cornerRadius = 0;
        _containerView.layer.masksToBounds = NO;

        // 设置约束
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _containerView;
}

- (UIView *)testVideoContainer {
    if (!_testVideoContainer) {
        _testVideoContainer = [[UIView alloc] init];
        [self configureCardView:_testVideoContainer];
    }
    return _testVideoContainer;
}

- (UILabel *)testVideoTitleLabel {
    if (!_testVideoTitleLabel) {
        _testVideoTitleLabel = [[UILabel alloc] init];
        _testVideoTitleLabel.text = @"测试视频（用于验证 native 广告是否打断）";
        _testVideoTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        _testVideoTitleLabel.textColor = [UIColor colorWithRed:0.16 green:0.20 blue:0.27 alpha:1.0];
        _testVideoTitleLabel.numberOfLines = 1;
        _testVideoTitleLabel.adjustsFontSizeToFitWidth = YES;
        _testVideoTitleLabel.minimumScaleFactor = 0.75;
    }
    return _testVideoTitleLabel;
}

- (UIView *)testVideoSurface {
    if (!_testVideoSurface) {
        _testVideoSurface = [[UIView alloc] init];
        _testVideoSurface.backgroundColor = [UIColor blackColor];
        _testVideoSurface.layer.cornerRadius = 8;
        _testVideoSurface.layer.masksToBounds = YES;

        [_testVideoSurface addSubview:self.testVideoPlaceholderLabel];
        self.testVideoPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.testVideoPlaceholderLabel.centerXAnchor constraintEqualToAnchor:_testVideoSurface.centerXAnchor],
            [self.testVideoPlaceholderLabel.centerYAnchor constraintEqualToAnchor:_testVideoSurface.centerYAnchor],
            [self.testVideoPlaceholderLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:_testVideoSurface.leadingAnchor constant:12],
            [self.testVideoPlaceholderLabel.trailingAnchor constraintLessThanOrEqualToAnchor:_testVideoSurface.trailingAnchor constant:-12],
        ]];

        // 使用公开样片，作为"宿主 App 自有视频"的模拟
        NSURL *url = [NSURL URLWithString:@"https://www.w3schools.com/html/mov_bbb.mp4"];
        _testVideoPlayer = [AVPlayer playerWithURL:url];
        _testVideoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;

        _testVideoLayer = [AVPlayerLayer playerLayerWithPlayer:_testVideoPlayer];
        _testVideoLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [_testVideoSurface.layer insertSublayer:_testVideoLayer atIndex:0];

        // 循环播放，便于观察是否被打断
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(testVideoDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:_testVideoPlayer.currentItem];
    }
    return _testVideoSurface;
}

- (UILabel *)testVideoPlaceholderLabel {
    if (!_testVideoPlaceholderLabel) {
        _testVideoPlaceholderLabel = [[UILabel alloc] init];
        _testVideoPlaceholderLabel.text = @"点击下方按钮播放测试视频";
        _testVideoPlaceholderLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        _testVideoPlaceholderLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.72];
        _testVideoPlaceholderLabel.textAlignment = NSTextAlignmentCenter;
        _testVideoPlaceholderLabel.layer.zPosition = 1;
    }
    return _testVideoPlaceholderLabel;
}

- (UIButton *)testVideoToggleButton {
    if (!_testVideoToggleButton) {
        _testVideoToggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testVideoToggleButton setTitle:@"展开" forState:UIControlStateNormal];
        [_testVideoToggleButton setTitleColor:[self primaryColor] forState:UIControlStateNormal];
        _testVideoToggleButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _testVideoToggleButton.layer.cornerRadius = 8;
        _testVideoToggleButton.backgroundColor = [UIColor colorWithRed:0.90 green:0.94 blue:1.0 alpha:1.0];
        [_testVideoToggleButton addTarget:self action:@selector(testVideoToggleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testVideoToggleButton;
}

- (UIButton *)testVideoButton {
    if (!_testVideoButton) {
        _testVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testVideoButton setTitle:@"▶️ 播放测试视频" forState:UIControlStateNormal];
        [_testVideoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self configureActionButton:_testVideoButton backgroundColor:[UIColor colorWithRed:0.40 green:0.32 blue:0.86 alpha:1.0]];
        [_testVideoButton addTarget:self action:@selector(testVideoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testVideoButton;
}

- (void)onBackgroundTapped {
    [self.view endEditing:YES];
}
@end
