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

@interface NativeAdViewController () <AdbidNativeAdDelegate,AdbidNativeMediaViewDelegate>

@property (nonatomic, strong) AdbidNativeAd *nativeAd;
@property (nonatomic, strong) NativeFeedAdView *customAdView;
@property (nonatomic, strong) AdbidNativeObj *nativeObj;

// UI 控件
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *controlPanel;
@property (nonatomic, strong) UITextField *slotIdTextField;
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
@property (nonatomic, strong) AVPlayer *testVideoPlayer;
@property (nonatomic, strong) AVPlayerLayer *testVideoLayer;
@property (nonatomic, strong) UIButton *testVideoButton;

// 状态管理
@property (nonatomic, assign) AdStatus currentStatus;

@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];
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
    [_testVideoPlayer pause];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.testVideoPlayer pause];
    [self.testVideoButton setTitle:@"▶️ 播放测试视频" forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_testVideoLayer) {
        _testVideoLayer.frame = self.testVideoSurface.bounds;
    }
}

#pragma mark - UI Setup

- (void)setupUI {
    // 创建滚动视图
    [self.view addSubview:self.scrollView];

    // 添加控制面板
    [self.scrollView addSubview:self.controlPanel];

    // 添加按钮和状态标签
    [self.controlPanel addSubview:self.slotIdTextField];
    [self.controlPanel addSubview:self.loadButton];
    [self.controlPanel addSubview:self.showButton];
    [self.controlPanel addSubview:self.winNoticeButton];
    [self.controlPanel addSubview:self.lossNoticeButton];
    [self.controlPanel addSubview:self.statusLabel];

    // 添加测试视频区域（用于验证 native 广告是否打断其他视频）
    [self.scrollView addSubview:self.testVideoContainer];
    [self.testVideoContainer addSubview:self.testVideoTitleLabel];
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
        [self.controlPanel.heightAnchor constraintEqualToConstant:350]
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
    self.loadButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.showButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.winNoticeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.lossNoticeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        // Load按钮
        [self.loadButton.topAnchor constraintEqualToAnchor:self.slotIdTextField.bottomAnchor constant:20],
        [self.loadButton.leadingAnchor constraintEqualToAnchor:self.controlPanel.leadingAnchor constant:20],
        [self.loadButton.trailingAnchor constraintEqualToAnchor:self.controlPanel.centerXAnchor constant:-10],
        [self.loadButton.heightAnchor constraintEqualToConstant:50],

        // Show按钮
        [self.showButton.topAnchor constraintEqualToAnchor:self.slotIdTextField.bottomAnchor constant:20],
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
    [NSLayoutConstraint activateConstraints:@[
        [self.testVideoContainer.topAnchor constraintEqualToAnchor:self.controlPanel.bottomAnchor constant:20],
        [self.testVideoContainer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.testVideoContainer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.testVideoContainer.heightAnchor constraintEqualToConstant:240],

        [self.testVideoTitleLabel.topAnchor constraintEqualToAnchor:self.testVideoContainer.topAnchor constant:8],
        [self.testVideoTitleLabel.leadingAnchor constraintEqualToAnchor:self.testVideoContainer.leadingAnchor constant:12],
        [self.testVideoTitleLabel.trailingAnchor constraintEqualToAnchor:self.testVideoContainer.trailingAnchor constant:-12],
        [self.testVideoTitleLabel.heightAnchor constraintEqualToConstant:24],

        [self.testVideoSurface.topAnchor constraintEqualToAnchor:self.testVideoTitleLabel.bottomAnchor constant:8],
        [self.testVideoSurface.leadingAnchor constraintEqualToAnchor:self.testVideoContainer.leadingAnchor constant:12],
        [self.testVideoSurface.trailingAnchor constraintEqualToAnchor:self.testVideoContainer.trailingAnchor constant:-12],
        [self.testVideoSurface.bottomAnchor constraintEqualToAnchor:self.testVideoButton.topAnchor constant:-8],

        [self.testVideoButton.leadingAnchor constraintEqualToAnchor:self.testVideoContainer.leadingAnchor constant:12],
        [self.testVideoButton.trailingAnchor constraintEqualToAnchor:self.testVideoContainer.trailingAnchor constant:-12],
        [self.testVideoButton.bottomAnchor constraintEqualToAnchor:self.testVideoContainer.bottomAnchor constant:-8],
        [self.testVideoButton.heightAnchor constraintEqualToConstant:36],
    ]];

    // 广告容器约束
    self.adContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.adContainerView.topAnchor constraintEqualToAnchor:self.testVideoContainer.bottomAnchor constant:20],
        [self.adContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.adContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.adContainerView.heightAnchor constraintEqualToConstant:300],
        [self.adContainerView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor constant:-20]
    ]];

    // containerView约束
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.adContainerView.topAnchor constant:20],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.adContainerView.leadingAnchor constant:20],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.adContainerView.trailingAnchor constant:-20],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.adContainerView.bottomAnchor constant:-20]
    ]];
}

#pragma mark - Button Actions

- (void)loadButtonTapped:(UIButton *)sender {
    if (self.currentStatus == AdStatusLoading) {
        return;  // 防止重复加载
    }

    [self updateStatus:AdStatusLoading];

    // 从输入框获取广告位ID，如果为空则使用默认ID 100130103000001
    NSString *slotId = self.slotIdTextField.text.length > 0 ? self.slotIdTextField.text : @"100130103000001";

    // 保存输入的ID，以便下次进入页面时使用
    if (self.slotIdTextField.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.slotIdTextField.text forKey:@"DemoNativeAdID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSLog(@"开始加载信息流广告，广告位ID: %@", slotId);
    AdbidNativeAd *nativeAd = [[AdbidNativeAd alloc] initWithSlotId:self.slotIdTextField.text];
    nativeAd.rootViewController = self;
    nativeAd.delegate = self;
    self.nativeAd = nativeAd;
    [self.nativeAd loadAdWithToken:@""];
}

- (void)showButtonTapped:(UIButton *)sender {
    if (self.currentStatus != AdStatusLoaded) {
        return;  // 只有加载完成才能展示
    }

    [self updateStatus:AdStatusShowing];
    if ([self.nativeAd isReady]) {
        // 这里可以添加展示广告的逻辑
        // 例如：将广告视图添加到容器中
        NSLog(@"展示广告");
        BOOL isVideoAd = self.nativeObj.isVideoAd;
        if (isVideoAd) {
            [self showVideoNativeAd];
        } else {
            [self showImageNativeAd];
        }
    }
}

- (void)showImageNativeAd {
    // 图片
    self.customAdView = [[NativeFeedAdView alloc] init];
    [self.containerView addSubview:self.customAdView];
    self.customAdView.frame = self.containerView.bounds;
    self.customAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGRect frame = self.customAdView.bounds;
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;

    CGRect imageArea = CGRectMake(0, 0, w, h - 50);
    
    self.customAdView.imageView.frame = imageArea;
    self.customAdView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.customAdView.imageView.clipsToBounds = NO;
    [self.customAdView bringSubviewToFront:self.customAdView.imageView];
    if (self.nativeObj.imageAdInfo) {
        AdbidNativeImageObj * objc = self.nativeObj.imageAdInfo;
        NSURL *iconURL = [NSURL URLWithString:objc.imageUrl];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imgData = [NSData dataWithContentsOfURL:iconURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *img = [UIImage imageWithData:imgData];
                self.customAdView.imageView.image = img;
            });
        });
    }
  

    CGFloat overlayH = 74;
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, imageArea.size.height, w, overlayH)];
    overlay.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.frame = overlay.bounds;
    grad.colors = @[
        (__bridge id)[UIColor colorWithWhite:0 alpha:0.0].CGColor,
        (__bridge id)[UIColor colorWithWhite:0 alpha:0.6].CGColor
    ];
    grad.startPoint = CGPointMake(0.5, 0.0);
    grad.endPoint = CGPointMake(0.5, 1.0);
    [overlay.layer insertSublayer:grad atIndex:0];
    [self.customAdView addSubview:overlay];
    [self.customAdView bringSubviewToFront:overlay];

    self.customAdView.titleLabel.text = self.nativeObj.title;
    self.customAdView.titleLabel.frame = CGRectMake(12, 8, w - 24, 28);
    self.customAdView.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.customAdView.titleLabel.textColor = [UIColor whiteColor];
    self.customAdView.titleLabel.backgroundColor = [UIColor clearColor];
    self.customAdView.titleLabel.numberOfLines = 1;
    self.customAdView.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.customAdView.titleLabel.layer.shadowOpacity = 0.3;
    self.customAdView.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.customAdView.titleLabel.layer.shadowRadius = 2;
    [overlay addSubview:self.customAdView.titleLabel];

    self.customAdView.descLabel.text = self.nativeObj.desc;
    self.customAdView.descLabel.frame = CGRectMake(12, 36, w - 24, overlayH - 44);
    self.customAdView.descLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.customAdView.descLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    self.customAdView.descLabel.backgroundColor = [UIColor clearColor];
    self.customAdView.descLabel.numberOfLines = 2;
    [overlay addSubview:self.customAdView.descLabel];
    self.customAdView.logoImageView.frame = CGRectMake(w - 40, 8, 28, 28);
    self.customAdView.logoImageView.image = self.nativeObj.logoImage;
    [self.customAdView.logoImageView setHidden:NO];
    [overlay addSubview:self.customAdView.logoImageView];
    
    self.customAdView.imageView.userInteractionEnabled=YES;
    self.customAdView.descLabel.userInteractionEnabled=YES;
    [self.nativeAd registerContainer:self.customAdView
                       mainImageView: self.customAdView.imageView
                  withClickableViews:@[self.customAdView]];
}

- (void)showVideoNativeAd {
    // 视频
    self.customAdView = [[NativeFeedAdView alloc] init];
    [self.containerView addSubview:self.customAdView];
    self.customAdView.frame = self.containerView.bounds;
    self.customAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGRect frame = self.customAdView.bounds;
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    self.customAdView.backgroundColor = [UIColor grayColor];
    // 视频视图
 
    if (self.customAdView.mediaView.superview) {
        [self.customAdView.mediaView removeFromSuperview];
    }
    // 插入到最底层
    [self.customAdView insertSubview:self.customAdView.mediaView atIndex:0];
    
    self.customAdView.mediaView.frame = CGRectMake(0, 0, w, h - 50);
    self.customAdView.mediaView.delegate = self;

    // 标题
    self.customAdView.titleLabel.frame = CGRectMake(0, h - 50, w, 50);
    self.customAdView.titleLabel.text = self.nativeObj.title;

    // Logo —— 位置完全由开发者自定义。下面默认放在 mediaView 右下角；
    // 如需放到标题旁、与 title/desc 一起排列，只需改这里的 frame，例如：
    //   self.customAdView.logoImageView.frame = CGRectMake(w - 68, h - 42, 60, 34);
    CGFloat logoW = 28, logoH = 20, pad = 8;
    self.customAdView.logoImageView.frame =
        CGRectMake(w - logoW - pad, (h - 50) - logoH - pad, logoW, logoH);
    [self.customAdView.logoImageView setHidden:NO];
    self.customAdView.logoImageView.image = self.nativeObj.logoImage;

    // 给视图绑定点击事件
    [self.nativeAd registerContainer:self.customAdView
                       mainImageView: self.customAdView.imageView
                  withClickableViews:@[self.customAdView.mediaView, self.customAdView.titleLabel ]];

    // 静音初始值通过 AdbidNativeAd.shouldMuted 下发；默认 YES（信息流默认静音）
    // 想测试"出声打断"场景时，把下一行改成 NO
    self.nativeAd.shouldMuted = NO;
    // 播放视频（refreshData 内部会把 shouldMuted 同步到 mediaView）
    [self.customAdView refreshData:self.nativeAd];
}

#pragma mark - Status Management

- (void)updateStatus:(AdStatus)status {
    self.currentStatus = status;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUIForStatus:status];
    });
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
        self.loadButton.backgroundColor = [UIColor systemBlueColor];
        self.loadButton.alpha = 1.0;
    } else {
        self.loadButton.backgroundColor = [UIColor systemGrayColor];
        self.loadButton.alpha = 0.6;
    }

    // Show按钮样式
    if (self.showButton.enabled) {
        self.showButton.backgroundColor = [UIColor systemGreenColor];
        self.showButton.alpha = 1.0;
    } else {
        self.showButton.backgroundColor = [UIColor systemGrayColor];
        self.showButton.alpha = 0.6;
    }
}

- (void)winNoticeButtonTapped:(UIButton *)sender {
    NSLog(@"winNoticeButtonTapped");
    if (self.nativeAd && self.nativeAd.data) {
        self.statusLabel.text = @"正在上报竞胜...";
        self.statusLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
       // [self.nativeAd winNotice:self.nativeAd.eCPM];
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

 //       [self.nativeAd lossNotice:info];
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
    [self.testVideoPlayer play];
    [sender setTitle:@"⏸ 暂停测试视频" forState:UIControlStateNormal];
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
    [self updateStatus:AdStatusLoaded];
    self.nativeObj = nativeAd.data;
}

// 广告加载失败回调
- (void)nativeAd:(AdbidNativeAd *)nativeAd didFailToLoadWithError:(NSError *)error {
    NSLog(@"nativeAd didFailToLoadWithError: %@", error);
    [self updateStatus:AdStatusError];
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

- (UIView *)controlPanel {
    if (!_controlPanel) {
        _controlPanel = [[UIView alloc] init];
        _controlPanel.backgroundColor = [UIColor whiteColor];
        _controlPanel.layer.cornerRadius = 12;
        _controlPanel.layer.shadowColor = [UIColor blackColor].CGColor;
        _controlPanel.layer.shadowOffset = CGSizeMake(0, 2);
        _controlPanel.layer.shadowOpacity = 0.1;
        _controlPanel.layer.shadowRadius = 8;
    }
    return _controlPanel;
}

- (UITextField *)slotIdTextField {
    if (!_slotIdTextField) {
        _slotIdTextField = [[UITextField alloc] init];
        _slotIdTextField.placeholder = @"请输入广告位ID";

        // 尝试获取上次输入的ID
        NSString *savedId = [[NSUserDefaults standardUserDefaults] stringForKey:@"DemoNativeAdID"];
        if (savedId && savedId.length > 0) {
            _slotIdTextField.text = savedId;
        } else {
            _slotIdTextField.text =AppConfig.nativeID;  // 默认广告位ID
        }

        _slotIdTextField.borderStyle = UITextBorderStyleRoundedRect;
        _slotIdTextField.font = [UIFont systemFontOfSize:16];
        _slotIdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _slotIdTextField.backgroundColor = [UIColor whiteColor];
    }
    return _slotIdTextField;
}

- (UIButton *)loadButton {
    if (!_loadButton) {
        _loadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadButton setTitle:@"🔄 Load Ad" forState:UIControlStateNormal];
        [_loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loadButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _loadButton.backgroundColor = [UIColor systemBlueColor];
        _loadButton.layer.cornerRadius = 8;
        _loadButton.layer.shadowColor = [UIColor blackColor].CGColor;
        _loadButton.layer.shadowOffset = CGSizeMake(0, 2);
        _loadButton.layer.shadowOpacity = 0.2;
        _loadButton.layer.shadowRadius = 4;
        [_loadButton addTarget:self action:@selector(loadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadButton;
}

- (UIButton *)showButton {
    if (!_showButton) {
        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showButton setTitle:@"👁 Show Ad" forState:UIControlStateNormal];
        [_showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _showButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _showButton.backgroundColor = [UIColor systemGreenColor];
        _showButton.layer.cornerRadius = 8;
        _showButton.layer.shadowColor = [UIColor blackColor].CGColor;
        _showButton.layer.shadowOffset = CGSizeMake(0, 2);
        _showButton.layer.shadowOpacity = 0.2;
        _showButton.layer.shadowRadius = 4;
        [_showButton addTarget:self action:@selector(showButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showButton;
}

- (UIButton *)winNoticeButton {
    if (!_winNoticeButton) {
        _winNoticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_winNoticeButton setTitle:@"竞胜上报" forState:UIControlStateNormal];
        [_winNoticeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _winNoticeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _winNoticeButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
        _winNoticeButton.layer.cornerRadius = 8;
        _winNoticeButton.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:0.3].CGColor;
        _winNoticeButton.layer.shadowOffset = CGSizeMake(0, 2);
        _winNoticeButton.layer.shadowOpacity = 0.2;
        _winNoticeButton.layer.shadowRadius = 4;
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
        _lossNoticeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _lossNoticeButton.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        _lossNoticeButton.layer.cornerRadius = 8;
        _lossNoticeButton.layer.shadowColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3].CGColor;
        _lossNoticeButton.layer.shadowOffset = CGSizeMake(0, 2);
        _lossNoticeButton.layer.shadowOpacity = 0.2;
        _lossNoticeButton.layer.shadowRadius = 4;
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
        _statusLabel.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
        _statusLabel.layer.cornerRadius = 8;
        _statusLabel.layer.masksToBounds = YES;
        _statusLabel.text = @"📱 状态：空闲\n点击 Load 按钮加载广告";
        _statusLabel.textColor = [UIColor systemGrayColor];
    }
    return _statusLabel;
}

- (UIView *)adContainerView {
    if (!_adContainerView) {
        _adContainerView = [[UIView alloc] init];
        _adContainerView.backgroundColor = [UIColor whiteColor];
        _adContainerView.layer.cornerRadius = 12;
        _adContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
        _adContainerView.layer.shadowOffset = CGSizeMake(0, 2);
        _adContainerView.layer.shadowOpacity = 0.1;
        _adContainerView.layer.shadowRadius = 8;
    }
    return _adContainerView;
}

- (UILabel *)containerView {
    if (!_containerView) {
        _containerView = [[UILabel alloc] init];
        _containerView.frame = CGRectMake(20, 20, 0, 50);  // 宽度会被约束覆盖
        _containerView.userInteractionEnabled = YES;
        _containerView.textAlignment = NSTextAlignmentCenter;
        _containerView.text = @"🍊 广告展示区域 🍊\n广告内容将在这里显示";
        _containerView.numberOfLines = 0;
        _containerView.font = [UIFont systemFontOfSize:16];
        _containerView.textColor = [UIColor systemOrangeColor];
        _containerView.backgroundColor = [UIColor colorWithRed:1.0 green:0.95 blue:0.9 alpha:1.0];
        _containerView.layer.cornerRadius = 8;
        _containerView.layer.masksToBounds = YES;

        // 设置约束
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _containerView;
}

- (UIView *)testVideoContainer {
    if (!_testVideoContainer) {
        _testVideoContainer = [[UIView alloc] init];
        _testVideoContainer.backgroundColor = [UIColor whiteColor];
        _testVideoContainer.layer.cornerRadius = 12;
        _testVideoContainer.layer.shadowColor = [UIColor blackColor].CGColor;
        _testVideoContainer.layer.shadowOffset = CGSizeMake(0, 2);
        _testVideoContainer.layer.shadowOpacity = 0.1;
        _testVideoContainer.layer.shadowRadius = 8;
    }
    return _testVideoContainer;
}

- (UILabel *)testVideoTitleLabel {
    if (!_testVideoTitleLabel) {
        _testVideoTitleLabel = [[UILabel alloc] init];
        _testVideoTitleLabel.text = @"🎬 测试视频（用于验证 native 广告是否打断）";
        _testVideoTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        _testVideoTitleLabel.textColor = [UIColor darkGrayColor];
    }
    return _testVideoTitleLabel;
}

- (UIView *)testVideoSurface {
    if (!_testVideoSurface) {
        _testVideoSurface = [[UIView alloc] init];
        _testVideoSurface.backgroundColor = [UIColor blackColor];
        _testVideoSurface.layer.cornerRadius = 8;
        _testVideoSurface.layer.masksToBounds = YES;

        // 使用公开样片，作为"宿主 App 自有视频"的模拟
        NSURL *url = [NSURL URLWithString:@"https://vjs.zencdn.net/v/oceans.mp4"];
        _testVideoPlayer = [AVPlayer playerWithURL:url];
        _testVideoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;

        _testVideoLayer = [AVPlayerLayer playerLayerWithPlayer:_testVideoPlayer];
        _testVideoLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [_testVideoSurface.layer addSublayer:_testVideoLayer];

        // 循环播放，便于观察是否被打断
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(testVideoDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:_testVideoPlayer.currentItem];
    }
    return _testVideoSurface;
}

- (UIButton *)testVideoButton {
    if (!_testVideoButton) {
        _testVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testVideoButton setTitle:@"▶️ 播放测试视频" forState:UIControlStateNormal];
        [_testVideoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _testVideoButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _testVideoButton.backgroundColor = [UIColor systemPurpleColor];
        _testVideoButton.layer.cornerRadius = 6;
        [_testVideoButton addTarget:self action:@selector(testVideoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testVideoButton;
}

- (void)onBackgroundTapped {
    [self.view endEditing:YES];
}
@end
