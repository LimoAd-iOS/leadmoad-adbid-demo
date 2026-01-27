//
//  SplashAdViewController.m
//  LeadMoadAdSDKDemo
//
//  Created by youzhadoubao on 2025/9/19.
//

#import "SplashAdViewController.h"
#import <AdbidSDK/AdbidSDK.h>
@interface SplashAdViewController () <AdbidSplashAdDelegate>

@property (nonatomic, strong) AdbidSplashAd *splashAd;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UITextField *adIdTextField;
@property (nonatomic, strong) UISwitch *adTypeSwitch;
@property (nonatomic, strong) UILabel *bottomViewLabel;

@end

@implementation SplashAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];

    // 设置导航栏标题
    self.title = @"开屏广告测试";

    // 创建滚动视图以支持更多内容
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];

    UIView *contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:contentView];

    // 广告ID输入区域
    UILabel *adIdLabel = [[UILabel alloc] init];
    adIdLabel.text = @"广告ID";
    adIdLabel.font = [UIFont systemFontOfSize:16];
    adIdLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    adIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:adIdLabel];

    self.adIdTextField = [[UITextField alloc] init];
    self.adIdTextField.placeholder = @"请输入广告ID";

    // 尝试获取上次输入的ID
    NSString *savedId = [[NSUserDefaults standardUserDefaults] stringForKey:@"DemoSplashAdID"];
    if (savedId && savedId.length > 0) {
        self.adIdTextField.text = savedId;
    } else {
        self.adIdTextField.text = @"MTc1MzM0MzU1MzkzOQ==";  // 默认图片广告ID
    }

    self.adIdTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.adIdTextField.font = [UIFont systemFontOfSize:14];
    self.adIdTextField.backgroundColor = [UIColor whiteColor];
    self.adIdTextField.layer.cornerRadius = 8;
    self.adIdTextField.layer.borderWidth = 1;
    self.adIdTextField.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
    self.adIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:self.adIdTextField];

    // 底部视图开关区域
    self.bottomViewLabel = [[UILabel alloc] init];
    self.bottomViewLabel.text = @"底部视图";
    self.bottomViewLabel.font = [UIFont systemFontOfSize:16];
    self.bottomViewLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomViewLabel.numberOfLines = 0;
    self.bottomViewLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];

    // 设置底部视图的frame，不使用Auto Layout
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat bottomViewHeight = screenHeight * 0.19;
    self.bottomViewLabel.frame = CGRectMake(0, 0, 280, bottomViewHeight);

    // Ad type label
    UILabel *adTypeSwitchLabel = [[UILabel alloc] init];
    adTypeSwitchLabel.text = @"广告类型 (off 图片 / on 视频)";
    adTypeSwitchLabel.font = [UIFont systemFontOfSize:16];
    adTypeSwitchLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    adTypeSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [adTypeSwitchLabel setHidden:YES];
    [contentView addSubview:adTypeSwitchLabel];

    self.adTypeSwitch = [[UISwitch alloc] init];
    self.adTypeSwitch.on = NO;  // 默认图片广告
    self.adTypeSwitch.onTintColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
    self.adTypeSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adTypeSwitch addTarget:self
                          action:@selector(adTypeSwitchChanged:)
                forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:self.adTypeSwitch];

    // load button
    UIButton *loadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loadButton setTitle:@"Load Splash Ad" forState:UIControlStateNormal];
    [loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loadButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateHighlighted];
    loadButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    loadButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0];
    loadButton.layer.cornerRadius = 25;
    loadButton.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:0.3].CGColor;
    loadButton.layer.shadowOffset = CGSizeMake(0, 4);
    loadButton.layer.shadowRadius = 8;
    loadButton.layer.shadowOpacity = 1.0;
    [loadButton addTarget:self action:@selector(loadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    loadButton.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:loadButton];

    // show button
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [showButton setTitle:@"Show Splash Ad" forState:UIControlStateNormal];
    [showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateHighlighted];
    showButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    showButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0];
    showButton.layer.cornerRadius = 25;
    showButton.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:0.3].CGColor;
    showButton.layer.shadowOffset = CGSizeMake(0, 4);
    showButton.layer.shadowRadius = 8;
    showButton.layer.shadowOpacity = 1.0;
    [showButton addTarget:self action:@selector(showButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    showButton.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:showButton];

    // win notice button
    UIButton *winNoticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [winNoticeButton setTitle:@"竞胜上报" forState:UIControlStateNormal];
    [winNoticeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [winNoticeButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateHighlighted];
    winNoticeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    winNoticeButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
    winNoticeButton.layer.cornerRadius = 25;
    winNoticeButton.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:0.3].CGColor;
    winNoticeButton.layer.shadowOffset = CGSizeMake(0, 4);
    winNoticeButton.layer.shadowRadius = 8;
    winNoticeButton.layer.shadowOpacity = 1.0;
    [winNoticeButton addTarget:self action:@selector(winNoticeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    winNoticeButton.translatesAutoresizingMaskIntoConstraints = NO;
    //[winNoticeButton setHidden:YES];
    [contentView addSubview:winNoticeButton];

    // loss notice button
    UIButton *lossNoticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lossNoticeButton setTitle:@"竞败上报" forState:UIControlStateNormal];
    [lossNoticeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lossNoticeButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateHighlighted];
    lossNoticeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    lossNoticeButton.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    lossNoticeButton.layer.cornerRadius = 25;
    lossNoticeButton.layer.shadowColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3].CGColor;
    lossNoticeButton.layer.shadowOffset = CGSizeMake(0, 4);
    lossNoticeButton.layer.shadowRadius = 8;
    lossNoticeButton.layer.shadowOpacity = 1.0;
    [lossNoticeButton addTarget:self action:@selector(lossNoticeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    lossNoticeButton.translatesAutoresizingMaskIntoConstraints = NO;
   // [lossNoticeButton setHidden:YES];
    [contentView addSubview:lossNoticeButton];

    // status label
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"准备就绪";
    self.statusLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    self.statusLabel.layer.cornerRadius = 8;
    self.statusLabel.layer.borderWidth = 1;
    self.statusLabel.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:self.statusLabel];

    // Auto Layout constraints
    [NSLayoutConstraint activateConstraints:@[
        // ScrollView constraints
        [scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        // ContentView constraints
        [contentView.topAnchor constraintEqualToAnchor:scrollView.topAnchor],
        [contentView.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor],
        [contentView.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor],
        [contentView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor],
        [contentView.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor],

        // Ad ID label constraints
        [adIdLabel.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:30],
        [adIdLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],

        // Ad ID text field constraints
        [self.adIdTextField.topAnchor constraintEqualToAnchor:adIdLabel.bottomAnchor constant:8],
        [self.adIdTextField.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [self.adIdTextField.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [self.adIdTextField.heightAnchor constraintEqualToConstant:44],

        // Ad type switch label constraints
        [adTypeSwitchLabel.topAnchor constraintEqualToAnchor:self.adIdTextField.bottomAnchor constant:20],
        [adTypeSwitchLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],

        // Ad type switch constraints
        [self.adTypeSwitch.centerYAnchor constraintEqualToAnchor:adTypeSwitchLabel.centerYAnchor],
        [self.adTypeSwitch.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],

        // Load button constraints
        [loadButton.topAnchor constraintEqualToAnchor:adTypeSwitchLabel.bottomAnchor constant:40],
        [loadButton.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [loadButton.widthAnchor constraintEqualToConstant:200], [loadButton.heightAnchor constraintEqualToConstant:50],

        // Show button constraints
        [showButton.topAnchor constraintEqualToAnchor:loadButton.bottomAnchor constant:20],
        [showButton.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [showButton.widthAnchor constraintEqualToConstant:200], [showButton.heightAnchor constraintEqualToConstant:50],

        // Win Notice Button constraints
        [winNoticeButton.topAnchor constraintEqualToAnchor:showButton.bottomAnchor constant:20],
        [winNoticeButton.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [winNoticeButton.widthAnchor constraintEqualToConstant:200], [winNoticeButton.heightAnchor constraintEqualToConstant:50],

        // Loss Notice Button constraints
        [lossNoticeButton.topAnchor constraintEqualToAnchor:winNoticeButton.bottomAnchor constant:20],
        [lossNoticeButton.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [lossNoticeButton.widthAnchor constraintEqualToConstant:200], [lossNoticeButton.heightAnchor constraintEqualToConstant:50],

        // Status label constraints
        [self.statusLabel.topAnchor constraintEqualToAnchor:lossNoticeButton.bottomAnchor constant:30],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [self.statusLabel.heightAnchor constraintGreaterThanOrEqualToConstant:60],
        [self.statusLabel.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-30]
    ]];
}

- (void)loadButtonTapped:(UIButton *)sender {
    NSLog(@"loadButtonTapped");
    // 收起键盘
    [self.adIdTextField resignFirstResponder];

    // 保存输入的ID
    if (self.adIdTextField.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.adIdTextField.text forKey:@"DemoSplashAdID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.statusLabel.text = [NSString stringWithFormat:@"正在加载广告...\n广告ID: %@\n", self.adIdTextField.text];
    self.statusLabel.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0];

   self.splashAd = [[AdbidSplashAd alloc] initWithSlotId:self.adIdTextField.text];
    self.splashAd.delegate = self;
    // 加载广告，根据底部视图开关状态调整高度
    [self.splashAd loadAd];
}

- (void)showButtonTapped:(UIButton *)sender {
    NSLog(@"showButtonTapped");
    if (self.splashAd) {
        self.statusLabel.text = @"正在展示广告...";
        self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0];
        [self.splashAd showAd:self];
    } else {
        self.statusLabel.text = @"请先加载广告";
        self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0];
    }
}

- (void)winNoticeButtonTapped:(UIButton *)sender {
    NSLog(@"winNoticeButtonTapped");
    if (self.splashAd) {
        self.statusLabel.text = @"正在上报竞胜...";
        self.statusLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
        [self.splashAd winNotice:self.splashAd.eCPM];
        self.statusLabel.text = [NSString stringWithFormat:@"竞胜上报成功\n价格: %ld", (long)self.splashAd.eCPM];
    } else {
        self.statusLabel.text = @"请先加载广告";
        self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0];
    }
}

- (void)lossNoticeButtonTapped:(UIButton *)sender {
    NSLog(@"lossNoticeButtonTapped");
    if (self.splashAd) {
        self.statusLabel.text = @"正在上报竞败...";
        self.statusLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        
        AdbidBidLossInfo *info = [[AdbidBidLossInfo alloc] init];
        info.winnerPrice = self.splashAd.eCPM + 10; // 模拟竞胜价格高于我方
        info.winnerPlatform = AdbidPlatform_CSJ; // 模拟穿山甲竞胜
        
        [self.splashAd lossNotice:info];
        self.statusLabel.text = [NSString stringWithFormat:@"竞败上报成功\n竞胜价格: %ld", (long)info.winnerPrice];
    } else {
        self.statusLabel.text = @"请先加载广告";
        self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0];
    }
}

// MARK: - LMSplashAdDelegate
// 广告加载成功
- (void)splashAdDidLoad:(AdbidSplashAd *)splashAd {
    NSLog(@"splashAd:didLoadAd: %@ ecpm %ld", splashAd, splashAd.eCPM);
    self.statusLabel.text = @"✅ 广告加载成功！可以点击展示按钮";
    self.statusLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
}

// 广告加载失败
- (void)splashAd:(AdbidSplashAd *)splashAd didFailToLoadWithError:(NSError *)error {
    NSLog(@"splashAd:didFailToLoadWithError: %@", error);
    self.statusLabel.text = [NSString stringWithFormat:@"❌ 广告加载失败：%@", error.localizedDescription];
    self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
}
// 广告展示成功
- (void)splashAdDidShow:(AdbidSplashAd *)splashAd {
    NSLog(@"splashAdDidShow");
    self.statusLabel.text = @"🎉 广告展示成功";
    self.statusLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
}

// 广告展示失败
- (void)splashAd:(AdbidSplashAd *)splashAd didFailToShowWithError:(NSError *)error {
    NSLog(@"splashAdDidShowFailed: %@", error);
    self.statusLabel.text = [NSString stringWithFormat:@"❌ 广告展示失败：%@", error.localizedDescription];
    self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    // 展示失败时也需要销毁广告对象
    [self destroyAd];
}

// 广告被点击
- (void)splashAdDidClick:(AdbidSplashAd *)splashAd {
    NSLog(@"splashAdDidClick");
    self.statusLabel.text = @"👆 广告被点击";
    self.statusLabel.textColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.8 alpha:1.0];
}

// 广告被关闭
- (void)splashAdDidClose:(AdbidSplashAd *)splashAd {
    NSLog(@"splashAdDidClose");
    self.statusLabel.text = @"📱 广告已关闭";
    self.statusLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
}
// MARK: - Private Methods

- (void)adTypeSwitchChanged:(UISwitch *)sender {
    if (sender.isOn) {
        // 开启状态：视频广告
        self.adIdTextField.text = @"100130101000001";
        NSLog(@"切换到视频广告: %@", self.adIdTextField.text);
    } else {
        // 关闭状态：图片广告
        self.adIdTextField.text = @"100130101000001";
        NSLog(@"切换到图片广告: %@", self.adIdTextField.text);
    }
}

- (void)destroyAd {
    if (self.splashAd) {
        // 移除广告视图
        [self.splashAd removeSplashView];
        // 清空代理
        self.splashAd.delegate = nil;
        // 释放广告对象
        self.splashAd = nil;
        NSLog(@"广告对象已销毁");
    }
}

@end
