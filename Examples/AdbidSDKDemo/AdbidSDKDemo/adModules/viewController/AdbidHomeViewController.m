//
//  AdbidHomeViewController.m
//  LeadMoadAdSDKDemo
//
//  Created by youzhadoubao on 2025/9/17.
//

#import "AdbidHomeViewController.h"
#import "NativeAdViewController.h"
#import "RewardVideoViewController.h"
#import "SplashAdViewController.h"
#import "InterstitialViewController.h"

// 导入头文件
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
@interface AdbidHomeViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation AdbidHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    // 设置背景渐变色
    [self setupGradientBackground];

    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];

    // 创建内容视图
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.contentView];

    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor]
    ]];

    // 创建标题
    [self setupTitleLabel];

    // 创建按钮
    [self setupButtons];
}

- (void)setupGradientBackground {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[
        (id)[UIColor colorWithRed:245/255.0 green:247/255.0 blue:250/255.0 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:245/255.0 green:247/255.0 blue:250/255.0 alpha:1.0].CGColor,
    ];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"领摩聚合广告";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    self.titleLabel.textColor = [UIColor colorWithRed:66/255.0 green:133/255.0 blue:244/255.0 alpha:1.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor
                                                  constant:60],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor
                                                      constant:20],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor
                                                       constant:-20]
    ]];
}

- (void)setupButtons {
    NSArray *buttonConfigs = @[
        @{@"title" : @"🚀 开屏广告", @"color" : @"#4285F4", @"action" : @"splashButtonTapped:"},
        @{@"title" : @"🎬 激励视频", @"color" : @"#4285F4", @"action" : @"rewardVideoButtonTapped:"},
        @{@"title" : @"🎬 插屏", @"color" : @"#4285F4", @"action" : @"interstitialButtonTapped:"},
        @{@"title" : @"📱 信息流（draw)", @"color" : @"#4285F4", @"action" : @"nativeButtonTapped:"},
//        @{@"title" : @"⚙️ Settings", @"color" : @"#95A5A6", @"action" : @"settingsButtonTapped:"},
    ];

    UIView *previousButton = self.titleLabel;
    for (int i = 0; i < buttonConfigs.count; i++) {
        NSDictionary *config = buttonConfigs[i];
        UIButton *button = [self createStyledButtonWithTitle:config[@"title"]
                                                       color:config[@"color"]
                                                      action:NSSelectorFromString(config[@"action"])];
        [self.contentView addSubview:button];

        [NSLayoutConstraint activateConstraints:@[
            [button.topAnchor constraintEqualToAnchor:previousButton.bottomAnchor
                                             constant:30],
            [button.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor
                                                 constant:40],
            [button.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor
                                                  constant:-40],
            [button.heightAnchor constraintEqualToConstant:60]
        ]];

        previousButton = button;

        // 为最后一个按钮设置底部约束
        if (i == buttonConfigs.count - 1) {
            [button.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-60].active = YES;
        }
    }
}

- (UIButton *)createStyledButtonWithTitle:(NSString *)title color:(NSString *)colorHex action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;

    // 设置标题
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    // 设置背景颜色
    UIColor *backgroundColor = [self colorFromHexString:colorHex];
    button.backgroundColor = backgroundColor;

    // 设置圆角
    button.layer.cornerRadius = 15;
    button.layer.masksToBounds = NO;

//    // 设置阴影
//    button.layer.shadowColor = [UIColor blackColor].CGColor;
//    button.layer.shadowOffset = CGSizeMake(0, 4);
//    button.layer.shadowRadius = 8;
//    button.layer.shadowOpacity = 0.3;

    // 设置边框
    button.layer.borderWidth = 0;
    button.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;

    // 添加点击事件
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    // 添加按下效果
    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    return button;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];  // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                           green:((rgbValue & 0xFF00) >> 8) / 255.0
                            blue:(rgbValue & 0xFF) / 255.0
                           alpha:1.0];
}

- (void)buttonTouchDown:(UIButton *)button {
    [UIView animateWithDuration:0.1
                     animations:^{
                         button.transform = CGAffineTransformMakeScale(0.95, 0.95);
                         button.alpha = 0.8;
                     }];
}

- (void)buttonTouchUp:(UIButton *)button {
    [UIView animateWithDuration:0.1
                     animations:^{
                         button.transform = CGAffineTransformIdentity;
                         button.alpha = 1.0;
                     }];
}

// MARK: - Action

- (void)splashButtonTapped:(UIButton *)sender {
    SplashAdViewController *splashVC = [[SplashAdViewController alloc] init];
    [self.navigationController pushViewController:splashVC animated:YES];
}

- (void)rewardVideoButtonTapped:(UIButton *)sender {
    RewardVideoViewController *rewardVideoVC = [[RewardVideoViewController alloc] init];
    [self.navigationController pushViewController:rewardVideoVC animated:YES];
}

- (void)nativeButtonTapped:(UIButton *)sender {
    NativeAdViewController *splashVC = [[NativeAdViewController alloc] init];
    [self.navigationController pushViewController:splashVC animated:YES];
}

- (void)interstitialButtonTapped:(UIButton *)sender {
    InterstitialViewController *rewardVideoVC = [[InterstitialViewController alloc] init];
    [self.navigationController pushViewController:rewardVideoVC animated:YES];
}

- (void)settingsButtonTapped:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Settings"
                                                                   message:@"Enter App ID"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.placeholder = @"App ID";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        NSString *savedAppID = [[NSUserDefaults standardUserDefaults] stringForKey:@"LMAppIDKey"];
        if (savedAppID && savedAppID.length > 0) {
            textField.text = savedAppID;
        } else {
            textField.text = @"10001";  // Default
        }
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           UITextField *textField = alert.textFields.firstObject;
                                                           NSString *newAppID = textField.text;
                                                           if (newAppID && newAppID.length > 0) {
                                                               [[NSUserDefaults standardUserDefaults] setObject:newAppID forKey:@"LMAppIDKey"];
                                                               [[NSUserDefaults standardUserDefaults] synchronize];

                                                               // Show restart alert
                                                               UIAlertController *restartAlert = [UIAlertController alertControllerWithTitle:@"Saved"
                                                                                                                                     message:@"Please restart the app for the changes to take effect."
                                                                                                                              preferredStyle:UIAlertControllerStyleAlert];
                                                               [restartAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                                                               [self presentViewController:restartAlert animated:YES completion:nil];
                                                           }
                                                       }];

    [alert addAction:cancelAction];
    [alert addAction:saveAction];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
