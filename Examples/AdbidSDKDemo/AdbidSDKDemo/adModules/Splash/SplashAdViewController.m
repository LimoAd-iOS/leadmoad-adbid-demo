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
#import "AdbidSplashTokenTester.h"

@interface SplashAdViewController () <AdbidSplashAdDelegate>

@property (nonatomic, strong) AdbidSplashAd *splashAd;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UITextField *adIdTextField;
@property (nonatomic, strong) UISwitch *adTypeSwitch;
@property (nonatomic, strong) UILabel *bottomViewLabel;
/// 日志文本视图
@property (nonatomic, strong) UITextView *logTextView;
@property (nonatomic, strong) AdbidSplashTokenTester *tokenTester;

@end

@implementation SplashAdViewController

- (void)performOnMainThread:(dispatch_block_t)block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
- (void)dealloc
{
    [self destroyAd];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:247/255.0 blue:250/255.0 alpha:1.0];
    self.tokenTester = [[AdbidSplashTokenTester alloc] init];

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
    adIdLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    adIdLabel.textColor = [UIColor colorWithRed:0.34 green:0.38 blue:0.45 alpha:1.0];
    adIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:adIdLabel];

    self.adIdTextField = [[UITextField alloc] init];
    self.adIdTextField.placeholder = @"请输入广告ID";
    self.adIdTextField.text = AppConfig.openID;  // 默认图片广告ID
    self.adIdTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.adIdTextField.font = [UIFont systemFontOfSize:14];
    self.adIdTextField.backgroundColor = [UIColor whiteColor];
    self.adIdTextField.layer.cornerRadius = 8;
    self.adIdTextField.layer.borderWidth = 1;
    self.adIdTextField.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
    self.adIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self configurePlatformRightViewForTextField:self.adIdTextField];
    [self configureTextFieldStyle:self.adIdTextField];
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
    [self configureButton:loadButton backgroundColor:[self primaryColor]];
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
    [self configureButton:showButton backgroundColor:[UIColor colorWithRed:0.18 green:0.65 blue:0.35 alpha:1.0]];
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
    [self configureButton:winNoticeButton backgroundColor:[UIColor colorWithRed:0.18 green:0.65 blue:0.35 alpha:1.0]];
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
    [self configureButton:lossNoticeButton backgroundColor:[UIColor colorWithRed:0.42 green:0.46 blue:0.52 alpha:1.0]];
   // [lossNoticeButton setHidden:YES];
    [contentView addSubview:lossNoticeButton];

    // token test button
    UIButton *tokenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tokenButton setTitle:@"加载C2S广告" forState:UIControlStateNormal];
    [tokenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tokenButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateHighlighted];
    tokenButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    tokenButton.translatesAutoresizingMaskIntoConstraints = NO;
    [tokenButton addTarget:self action:@selector(loadC2SButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self configureButton:tokenButton backgroundColor:[UIColor colorWithRed:0.92 green:0.45 blue:0.12 alpha:1.0]];
    [contentView addSubview:tokenButton];

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
    [self configureStatusLabelStyle:self.statusLabel];
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
    [self configureLogTextViewStyle:self.logTextView];
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

        [loadButton.topAnchor constraintEqualToAnchor:self.adIdTextField.bottomAnchor constant:16],
      //  [loadButton.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [loadButton.leftAnchor constraintEqualToAnchor:self.adIdTextField.leftAnchor constant:10],
        [loadButton.widthAnchor constraintEqualToConstant:120],
        [loadButton.heightAnchor constraintEqualToConstant:46],
        // Show button constraints
        [showButton.topAnchor constraintEqualToAnchor:self.adIdTextField.bottomAnchor constant:16],
       // [showButton.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [showButton.rightAnchor constraintEqualToAnchor:self.adIdTextField.rightAnchor constant:-10],
        [showButton.widthAnchor constraintEqualToConstant:120],
        [showButton.heightAnchor constraintEqualToConstant:46],

        // Win Notice Button constraints
        [winNoticeButton.topAnchor constraintEqualToAnchor:loadButton.bottomAnchor constant:12],
        [winNoticeButton.leftAnchor constraintEqualToAnchor:loadButton.leftAnchor constant:0],
        [winNoticeButton.widthAnchor constraintEqualToConstant:120], [winNoticeButton.heightAnchor constraintEqualToConstant:46],

        // Loss Notice Button constraints
        [lossNoticeButton.topAnchor constraintEqualToAnchor:showButton.bottomAnchor constant:12],
        [lossNoticeButton.rightAnchor constraintEqualToAnchor:showButton.rightAnchor constant:0],
        [lossNoticeButton.widthAnchor constraintEqualToConstant:120], [lossNoticeButton.heightAnchor constraintEqualToConstant:46],

        // Token Button constraints
        [tokenButton.topAnchor constraintEqualToAnchor:winNoticeButton.bottomAnchor constant:12],
        [tokenButton.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [tokenButton.widthAnchor constraintEqualToConstant:140],
        [tokenButton.heightAnchor constraintEqualToConstant:46],

        // Status label constraints
        [self.statusLabel.topAnchor constraintEqualToAnchor:tokenButton.bottomAnchor constant:16],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [self.statusLabel.heightAnchor constraintGreaterThanOrEqualToConstant:38],
       
        // 日志文本视图
        [self.logTextView.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:15],
        [self.logTextView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [self.logTextView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        [self.logTextView.heightAnchor constraintGreaterThanOrEqualToConstant:200],
        [self.logTextView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-20]
        
    ]];
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

- (void)configureTextFieldStyle:(UITextField *)textField {
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 10;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor colorWithWhite:0.88 alpha:1.0].CGColor;
}

- (void)configureButton:(UIButton *)button backgroundColor:(UIColor *)backgroundColor {
    button.backgroundColor = backgroundColor;
    button.layer.cornerRadius = 10;
    button.layer.shadowColor = backgroundColor.CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 4);
    button.layer.shadowRadius = 10;
    button.layer.shadowOpacity = 0.16;
    button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
}

- (void)configureStatusLabelStyle:(UILabel *)label {
    label.backgroundColor = [UIColor whiteColor];
    label.layer.cornerRadius = 10;
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor colorWithWhite:0.90 alpha:1.0].CGColor;
    label.layer.masksToBounds = YES;
}

- (void)configureLogTextViewStyle:(UITextView *)textView {
    textView.backgroundColor = [UIColor whiteColor];
    textView.font = [UIFont monospacedSystemFontOfSize:12 weight:UIFontWeightRegular];
    textView.textColor = [UIColor colorWithRed:0.16 green:0.20 blue:0.27 alpha:1.0];
    textView.layer.cornerRadius = 10;
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = [UIColor colorWithWhite:0.88 alpha:1.0].CGColor;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)loadButtonTapped:(UIButton *)sender {
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
    [self.splashAd loadAd];
}

- (NSString*)statusLog:(NSString*)text {
   // NSArray* times = [TimeUtil times];
    return text;
}

- (void)runServerBidTokenConfigCostTestWithSlotId:(NSString *)slotId {
    [self loadViewIfNeeded];
    AdbidSplashAd *testSplashAd = [[AdbidSplashAd alloc] initWithSlotId:slotId];
    NSString *startLog = [NSString stringWithFormat:@"初始化成功后开始测试 requestServerBidTokenConfigBeforeLoadForSplashAd, slotId=%@", slotId ?: @""];
    NSLog(@"%@", startLog);
    [self addLog:startLog];
    [self requestServerBidTokenConfigBeforeLoadForSplashAd:testSplashAd slotId:slotId];
}

- (void)requestServerBidTokenConfigBeforeLoadForSplashAd:(AdbidSplashAd *)splashAd slotId:(NSString *)slotId {
    __weak typeof(self) weakSelf = self;
    CFAbsoluteTime methodStartTime = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime requestStartTime = CFAbsoluteTimeGetCurrent();
   
    [AdbidSDKManager requestServerBidTokenConfigForPositionId:slotId completion:^(NSString * _Nullable sdkInfoConfig, NSError * _Nullable configError) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        NSTimeInterval elapsedTime = (CFAbsoluteTimeGetCurrent() - requestStartTime) * 1000.0;
        NSString *costLog = [NSString stringWithFormat:@"requestServerBidTokenConfigForPositionId 耗时: %.2f ms, slotId=%@, %@", elapsedTime, slotId ?: @"", configError ? [NSString stringWithFormat:@"error=%@", configError.localizedDescription ?: @"unknown"] : @"success"];
        NSLog(@"%@", costLog);
        [strongSelf addLog:costLog];
        [strongSelf.tokenTester getTokenWithAdId:slotId sdkInfo:sdkInfoConfig completion:^(BOOL success, NSDictionary * _Nullable config, NSError * _Nullable error) {
            NSTimeInterval methodElapsedTime = (CFAbsoluteTimeGetCurrent() - methodStartTime) * 1000.0;
            NSString *methodCostLog = [NSString stringWithFormat:@"requestServerBidTokenConfigBeforeLoadForSplashAd 总耗时: %.2f ms, slotId=%@, %@", methodElapsedTime, slotId ?: @"", error ? [NSString stringWithFormat:@"error=%@", error.localizedDescription ?: @"unknown"] : @"success"];
            NSLog(@"%@", methodCostLog);
            [strongSelf addLog:methodCostLog];
            if (strongSelf.splashAd == splashAd) {
                NSString* token = [config objectForKey:@"token"];
                [splashAd loadAdWithToken:token];
            }
        }];
    }];
}

- (NSString *)jsonStringFromObject:(id)object {
    if (!object) {
        return @"";
    }
    if (![NSJSONSerialization isValidJSONObject:object]) {
        return [object description] ?: @"";
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (data.length == 0 || error) {
        return [object description] ?: @"";
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString ?: @"";
}

- (void)loadC2SButtonTapped:(UIButton *)sender {
    [self.adIdTextField resignFirstResponder];

    // 保存输入的ID
    if (self.adIdTextField.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.adIdTextField.text forKey:@"DemoSplashAdID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    NSString *message = @" 正在加载C2S广告";
    self.statusLabel.text = [self statusLog:message];
    self.statusLabel.textColor = [UIColor colorWithRed:0.92 green:0.45 blue:0.12 alpha:1.0];
    [self addLog:message];

    self.splashAd = [[AdbidSplashAd alloc] initWithSlotId:self.adIdTextField.text];
    self.splashAd.delegate = self;
    [self requestServerBidTokenConfigBeforeLoadForSplashAd:self.splashAd slotId:self.adIdTextField.text];
}

- (void)showButtonTapped:(UIButton *)sender {
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
    BOOL callbackOnMainThread = [NSThread isMainThread];
    NSLog(@"开屏广告测试页加载成功回调 isMainThread=%@ 当前线程=%@",
          callbackOnMainThread ? @"YES" : @"NO",
          [NSThread currentThread]);
    [self performOnMainThread:^{
        NSString* message = [NSString stringWithFormat:@" ✅  加载成功 isMainThread=%@", callbackOnMainThread ? @"YES" : @"NO"];
        self.statusLabel.text = [self statusLog:message];
        [self addLog:message];
        self.statusLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
    }];
}
// 广告加载失败
- (void)splashAd:(AdbidSplashAd *)splashAd didFailToLoadWithError:(NSError *)error {
    [self performOnMainThread:^{
        NSString* message = [NSString stringWithFormat:@" ❌  加载失败：%@", error.localizedDescription];
        self.statusLabel.text =  [self statusLog:message] ;
        [self addLog:message];
        self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    }];
}
// 广告展示成功
- (void)splashAdDidShow:(AdbidSplashAd *)splashAd {
    [self performOnMainThread:^{
        NSString* message = @" 🎉  展示成功";
        self.statusLabel.text = [self statusLog:message];
        self.statusLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
        [self addLog:message];
    }];
}

// 广告展示失败
- (void)splashAd:(AdbidSplashAd *)splashAd didFailToShowWithError:(NSError *)error {
    [self performOnMainThread:^{
        NSString* message = [NSString stringWithFormat:@" ❌ 展示失败：%@", error.localizedDescription];
        self.statusLabel.text = [self statusLog: message];
        [self addLog:message];
        self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        // 展示失败时也需要销毁广告对象
        [self destroyAd];
    }];
}

// 广告被点击
- (void)splashAdDidClick:(AdbidSplashAd *)splashAd {
    [self performOnMainThread:^{
        NSString* message = @"👆  广告被点击";
        self.statusLabel.text = [self statusLog:message];
        [self addLog:message];
        self.statusLabel.textColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.8 alpha:1.0];
    }];
}

// 广告被关闭
- (void)splashAdDidClose:(AdbidSplashAd *)splashAd {
    [self performOnMainThread:^{
        NSString* message = @"👆  广告已关闭";
        self.statusLabel.text = [self statusLog:message];
        [self addLog:message];
        self.statusLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    }];
}
/// 广告完成转化(关闭落地页)
- (void)splashAdDidFinishConversion:(AdbidSplashAd *)interstitialAd interactionType:(AdbidAdRedirectionType)interactionType{
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
