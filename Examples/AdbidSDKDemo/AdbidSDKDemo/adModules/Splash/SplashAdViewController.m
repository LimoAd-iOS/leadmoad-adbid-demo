//
//  SplashAdViewController.m
//  LeadMoadAdSDKDemo
//
//  Created by youzhadoubao on 2025/9/19.
//

#import "SplashAdViewController.h"
#import <AdbidSDK/AdbidSDK.h>
#import "TimeUtil.h"
#import "AppConfig.h"
#import "AppDelegate.h"

@interface SplashAdViewController () <AdbidSplashAdDelegate>

@property (nonatomic, strong) AdbidSplashAd *splashAd;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UITextField *adIdTextField;
@property (nonatomic, strong) UISwitch *adTypeSwitch;
@property (nonatomic, strong) UILabel *bottomViewLabel;
/// 日志文本视图
@property (nonatomic, strong) UITextView *logTextView;

@end

@implementation SplashAdViewController
- (void)dealloc
{
    [self destroyAd];
}

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
        self.adIdTextField.text = AppConfig.openID;  // 默认图片广告ID
    }

    self.adIdTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.adIdTextField.font = [UIFont systemFontOfSize:14];
    self.adIdTextField.backgroundColor = [UIColor whiteColor];
    self.adIdTextField.layer.cornerRadius = 8;
    self.adIdTextField.layer.borderWidth = 1;
    self.adIdTextField.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
    self.adIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:self.adIdTextField];

    // load button
    UIButton *loadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loadButton setTitle:@"加载广告" forState:UIControlStateNormal];
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
    [showButton setTitle:@"显示开屏" forState:UIControlStateNormal];
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
    self.statusLabel.text = @" 准备就绪\n";
    self.statusLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    //self.statusLabel.numberOfLines = 2;
    self.statusLabel.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
   // self.statusLabel.layer.cornerRadius = 8;
   // self.statusLabel.layer.borderWidth = 1;
    self.statusLabel.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:self.statusLabel];
    
    // 日志文本视图
    self.logTextView = [[UITextView alloc] init];
    self.logTextView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    self.logTextView.font = [UIFont systemFontOfSize:12];
    self.logTextView.editable = NO;
    self.logTextView.layer.cornerRadius = 8;
    self.logTextView.layer.borderWidth = 1;
    self.logTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.logTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:self.logTextView];
    
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

        [loadButton.topAnchor constraintEqualToAnchor:self.adIdTextField.bottomAnchor constant:20],
      //  [loadButton.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [loadButton.leftAnchor constraintEqualToAnchor:self.adIdTextField.leftAnchor constant:10],
        [loadButton.widthAnchor constraintEqualToConstant:120],
        [loadButton.heightAnchor constraintEqualToConstant:50],
        // Show button constraints
        [showButton.topAnchor constraintEqualToAnchor:self.adIdTextField.bottomAnchor constant:20],
       // [showButton.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [showButton.rightAnchor constraintEqualToAnchor:self.adIdTextField.rightAnchor constant:-10],
        [showButton.widthAnchor constraintEqualToConstant:120],
        [showButton.heightAnchor constraintEqualToConstant:50],

        // Win Notice Button constraints
        [winNoticeButton.topAnchor constraintEqualToAnchor:loadButton.bottomAnchor constant:20],
        [winNoticeButton.leftAnchor constraintEqualToAnchor:loadButton.leftAnchor constant:0],
        [winNoticeButton.widthAnchor constraintEqualToConstant:120], [winNoticeButton.heightAnchor constraintEqualToConstant:50],

        // Loss Notice Button constraints
        [lossNoticeButton.topAnchor constraintEqualToAnchor:showButton.bottomAnchor constant:20],
        [lossNoticeButton.rightAnchor constraintEqualToAnchor:showButton.rightAnchor constant:0],
        [lossNoticeButton.widthAnchor constraintEqualToConstant:120], [lossNoticeButton.heightAnchor constraintEqualToConstant:50],

        // Status label constraints
        [self.statusLabel.topAnchor constraintEqualToAnchor:lossNoticeButton.bottomAnchor constant:10],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [self.statusLabel.heightAnchor constraintGreaterThanOrEqualToConstant:30],
       
        // 日志文本视图
        [self.logTextView.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:15],
        [self.logTextView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [self.logTextView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [self.logTextView.heightAnchor constraintGreaterThanOrEqualToConstant:200],
        [self.logTextView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-20]
        
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
    NSString* message = @" 正在加载广告";
    self.statusLabel.text = [self statusLog: message];
    self.statusLabel.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0];
    [self addLog:message];
    self.splashAd = [[AdbidSplashAd alloc] initWithSlotId:self.adIdTextField.text];
    self.splashAd.delegate = self;
    // 加载广告，根据底部视图开关状态调整高度
    [self.splashAd loadAd];
}

- (NSString*)statusLog:(NSString*)text {
   // NSArray* times = [TimeUtil times];
    return text;
}

- (void)showButtonTapped:(UIButton *)sender {
    NSLog(@"showButtonTapped");
    if (self.splashAd && [self.splashAd isReady]) {
        NSString* message = @" 正在展示广告";
        self.statusLabel.text =  [self statusLog:message];
        [self addLog:message];
        self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if (appDelegate && appDelegate.window) {
                self.splashAd.viewController = appDelegate.window.rootViewController;
                [self.splashAd showAdToWindow:appDelegate.window];
            }
        });
    } else {
        NSString* message = @" 请先加载广告";
        self.statusLabel.text = [self statusLog:message];
        [self addLog:message];
        self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0];
    }
}

- (void)winNoticeButtonTapped:(UIButton *)sender {
    NSLog(@"winNoticeButtonTapped");
    if (self.splashAd) {
        NSString* message = @" 正在上报竞胜";
        self.statusLabel.text = [self statusLog:message];
        [self addLog:message];
        self.statusLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
        [self.splashAd winNotice:self.splashAd.eCPM];
        
        NSString* message2 = [NSString stringWithFormat:@" 竞胜上报成功 价格: %ld", (long)self.splashAd.eCPM];
        self.statusLabel.text = [self statusLog:message2];
        [self addLog:message2];
        
    } else {
        NSString* message = @"请先加载广告";
        self.statusLabel.text = [self statusLog:message];
        [self addLog:message];
        self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0];
    }
}

- (void)lossNoticeButtonTapped:(UIButton *)sender {
    NSLog(@"lossNoticeButtonTapped");
    if (self.splashAd) {
        NSString* message = @"正在上报竞败...";
        self.statusLabel.text = [self statusLog:message];
        [self addLog:message];
        self.statusLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        
        AdbidBidLossInfo *info = [[AdbidBidLossInfo alloc] init];
        info.winnerPrice = self.splashAd.eCPM + 10; // 模拟竞胜价格高于我方
        info.winnerPlatform = AdbidPlatform_CSJ; // 模拟穿山甲竞胜
        
        [self.splashAd lossNotice:info];
        NSString* message2 = [NSString stringWithFormat:@"竞败上报成功\n竞胜价格: %ld", (long)info.winnerPrice];
        self.statusLabel.text = [self statusLog:message2] ;
        [self addLog:message2];
    } else {
        NSString* message = @"请先加载广告";
        self.statusLabel.text = [self statusLog:message];
        [self addLog:message];
        self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0];
    }
}

// MARK: - AdbidSplashAdDelegate
// 广告加载成功
- (void)splashAdDidLoad:(AdbidSplashAd *)splashAd {
    NSLog(@"splashAd:didLoadAd: %@ ecpm %ld", splashAd, splashAd.eCPM);
    NSString* message = @" ✅  加载成功";
    self.statusLabel.text = [self statusLog:message];
    [self addLog:message];
    self.statusLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
}
// 广告加载失败
- (void)splashAd:(AdbidSplashAd *)splashAd didFailToLoadWithError:(NSError *)error {
    NSLog(@"splashAd:didFailToLoadWithError: %@", error);
    NSString* message = [NSString stringWithFormat:@" ❌  加载失败：%@", error.localizedDescription];
    self.statusLabel.text =  [self statusLog:message] ;
    [self addLog:message];
    self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
}
// 广告展示成功
- (void)splashAdDidShow:(AdbidSplashAd *)splashAd {
    NSLog(@"splashAdDidShow");
    NSString* message = @" 🎉  展示成功";
    self.statusLabel.text = [self statusLog:message];
    self.statusLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
    [self addLog:message];
}

// 广告展示失败
- (void)splashAd:(AdbidSplashAd *)splashAd didFailToShowWithError:(NSError *)error {
    NSLog(@"splashAdDidShowFailed: %@", error);
    NSString* message = [NSString stringWithFormat:@" ❌ 展示失败：%@", error.localizedDescription];
    self.statusLabel.text = [self statusLog: message];
    [self addLog:message];
    self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    // 展示失败时也需要销毁广告对象
    [self destroyAd];
}

// 广告被点击
- (void)splashAdDidClick:(AdbidSplashAd *)splashAd {
    NSLog(@"splashAdDidClick");
    NSString* message = @"👆  广告被点击";
    self.statusLabel.text = [self statusLog:message];
    [self addLog:message];
    self.statusLabel.textColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.8 alpha:1.0];
}

// 广告被关闭
- (void)splashAdDidClose:(AdbidSplashAd *)splashAd {
    NSLog(@"splashAdDidClose");
    NSString* message = @"👆  广告已关闭";
    self.statusLabel.text = [self statusLog:message];
    [self addLog:message];
    self.statusLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
}
- (void)destroyAd {
    if (self.splashAd) {
        // 清空代理
        self.splashAd.delegate = nil;
        // 释放广告对象
        self.splashAd = nil;
    }
}

#pragma mark - Helper Methods

- (void)addLog:(NSString *)message {
    NSLog(@"%@", message);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm:ss.SSS";
        NSString *timestamp = [formatter stringFromDate:[NSDate date]];

        NSString *logMessage = [NSString stringWithFormat:@"[%@] %@\n", timestamp, message];
        self.logTextView.text = [self.logTextView.text stringByAppendingString:logMessage];

        // 滚动到底部
        if (self.logTextView.text.length > 0) {
            NSRange bottom = NSMakeRange(self.logTextView.text.length - 1, 1);
            [self.logTextView scrollRangeToVisible:bottom];
        }
    });
}
@end
