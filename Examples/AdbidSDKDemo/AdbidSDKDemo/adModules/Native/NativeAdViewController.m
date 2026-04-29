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

    // 初始化广告
    [self setupNativeAd];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onBackgroundTapped)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
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

    // 广告容器约束
    self.adContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.adContainerView.topAnchor constraintEqualToAnchor:self.controlPanel.bottomAnchor constant:20],
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

#pragma mark - Native Ad Setup

- (void)setupNativeAd {
    AdbidNativeAd *nativeAd = [[AdbidNativeAd alloc] initWithSlotId:self.slotIdTextField.text];
    nativeAd.rootViewController = self;
    nativeAd.delegate = self;
    self.nativeAd = nativeAd;
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
    [self setupNativeAd];
    [self.nativeAd loadAd];
}

- (void)showButtonTapped:(UIButton *)sender {
    if (self.currentStatus != AdStatusLoaded) {
        return;  // 只有加载完成才能展示
    }

    [self updateStatus:AdStatusShowing];

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
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:imageArea];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.clipsToBounds = YES;
    [self.customAdView insertSubview:backgroundImageView belowSubview:self.customAdView.imageView];
    UIVisualEffectView *blurView =
        [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    blurView.frame = backgroundImageView.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [backgroundImageView addSubview:blurView];

    self.customAdView.imageView.frame = imageArea;
    self.customAdView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.customAdView.imageView.clipsToBounds = NO;
    [self.customAdView bringSubviewToFront:self.customAdView.imageView];
   
        AdbidNativeImageObj * objc = self.nativeObj.imageAdInfo;
        NSURL *iconURL = [NSURL URLWithString:objc.imageUrl];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imgData = [NSData dataWithContentsOfURL:iconURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *img = [UIImage imageWithData:imgData];
                self.customAdView.imageView.image = img;
                backgroundImageView.image = img;
            });
        });
    
  

    CGFloat overlayH = 74;
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, imageArea.size.height - overlayH, w, overlayH)];
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
    self.customAdView.imageView.userInteractionEnabled=YES;
    self.customAdView.descLabel.userInteractionEnabled=YES;
    [self.nativeAd registerContainer:self.customAdView mainImageView:self.customAdView.imageView
                  withClickableViews:@[ self.customAdView.imageView, self.customAdView.descLabel ]];
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
    [self.customAdView addSubview:self.customAdView.mediaView];

    self.customAdView.mediaView.frame = CGRectMake(0, 0, w, h - 50);
    self.customAdView.mediaView.delegate = self;
    [self.customAdView.mediaView setMuted:YES];

    // 标题
    self.customAdView.titleLabel.frame = CGRectMake(0, h - 50, w, 50);
    self.customAdView.titleLabel.text = self.nativeObj.title;

    // 给视图绑定点击事件
    [self.nativeAd registerContainer:self.customAdView
                       mainImageView:self.customAdView.imageView
                  withClickableViews:@[ self.customAdView.mediaView, self.customAdView.titleLabel ]];
    // 播放视频
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
 准备播放
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
        _slotIdTextField.text = AppConfig.nativeID;  // 默认广告位ID
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

- (void)onBackgroundTapped {
    [self.view endEditing:YES];
}
@end
