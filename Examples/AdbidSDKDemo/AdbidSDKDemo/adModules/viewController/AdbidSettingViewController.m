//
//  AdbidSettingViewController.m
//  AdbidSDKDemo
//
//  Created by chaizhiyong on 2026/4/9.
//

#import "AdbidSettingViewController.h"
#import "AppConfig.h"

@interface AdbidSettingViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *adTypeSwitch;
@property (nonatomic, strong) UISwitch *hotAdTypeSwitch;
@end

@implementation AdbidSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGradientBackground];
    [self setupTitleLabel];
    [self setupSwitchs];
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
    [self.view addSubview:self.titleLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor
                                                  constant:100],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor
                                                      constant:20],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor
                                                       constant:-20],
        [self.titleLabel.heightAnchor constraintEqualToConstant:60]
    ]];
}

- (void)setupSwitchs {
    // Ad type label
    UILabel *adTypeSwitchLabel = [[UILabel alloc] init];
    adTypeSwitchLabel.text = @"开屏广告(off/on)";
    adTypeSwitchLabel.font = [UIFont systemFontOfSize:16];
    adTypeSwitchLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    adTypeSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:adTypeSwitchLabel];

    self.adTypeSwitch = [[UISwitch alloc] init];
    self.adTypeSwitch.on = [AppConfig shared].isOpenAppOpenAd;  // 默认图片广告
    self.adTypeSwitch.onTintColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
    self.adTypeSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adTypeSwitch addTarget:self
                          action:@selector(adTypeSwitchChanged:)
                forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.adTypeSwitch];
    
    UILabel *hotAdTypeSwitchLabel = [[UILabel alloc] init];
    hotAdTypeSwitchLabel.text = @"开屏热启动广告(off/on)";
    hotAdTypeSwitchLabel.font = [UIFont systemFontOfSize:16];
    hotAdTypeSwitchLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    hotAdTypeSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:hotAdTypeSwitchLabel];

    self.hotAdTypeSwitch = [[UISwitch alloc] init];
    self.hotAdTypeSwitch.on = [AppConfig shared].isOpenHotAppOpenAd;  // 默认图片广告
    self.hotAdTypeSwitch.onTintColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
    self.hotAdTypeSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.hotAdTypeSwitch addTarget:self
                          action:@selector(hotAdTypeSwitchChanged:)
                forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.hotAdTypeSwitch];
    
    [NSLayoutConstraint activateConstraints:@[
        [adTypeSwitchLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor
                                                  constant:30],
        [adTypeSwitchLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor
                                                      constant:20],
        [adTypeSwitchLabel.widthAnchor constraintEqualToConstant:200],
        [adTypeSwitchLabel.heightAnchor constraintEqualToConstant:44],
        
        [self.adTypeSwitch.leftAnchor constraintEqualToAnchor: adTypeSwitchLabel.rightAnchor
                                                  constant:20],
        [self.adTypeSwitch.centerYAnchor constraintEqualToAnchor:adTypeSwitchLabel.centerYAnchor],
        [self.adTypeSwitch.widthAnchor constraintEqualToConstant:60],
        [self.adTypeSwitch.heightAnchor constraintEqualToConstant:44],
        
        [hotAdTypeSwitchLabel.topAnchor constraintEqualToAnchor:self.adTypeSwitch.bottomAnchor
                                                  constant:10],
        [hotAdTypeSwitchLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor
                                                      constant:20],
        [hotAdTypeSwitchLabel.widthAnchor constraintEqualToConstant:200],
        [hotAdTypeSwitchLabel.heightAnchor constraintEqualToConstant:44],
        
        [self.hotAdTypeSwitch.leftAnchor constraintEqualToAnchor: hotAdTypeSwitchLabel.rightAnchor
                                                  constant:20],
        [self.hotAdTypeSwitch.centerYAnchor constraintEqualToAnchor:hotAdTypeSwitchLabel.centerYAnchor],
        [self.hotAdTypeSwitch.widthAnchor constraintEqualToConstant:60],
        [self.hotAdTypeSwitch.heightAnchor constraintEqualToConstant:44],
    ]];
}

- (void)setupButtons {
    NSArray *buttonConfigs = @[
        @{@"title" : @"切换环境", @"color" : @"#4285F4", @"action" : @"splashButtonTapped:"},
    ];

    UIView *previousButton = self.hotAdTypeSwitch;
    for (int i = 0; i < buttonConfigs.count; i++) {
        NSDictionary *config = buttonConfigs[i];
        UIButton *button = [self createStyledButtonWithTitle:config[@"title"]
                                                       color:config[@"color"]
                                                      action:NSSelectorFromString(config[@"action"])];
        [self.view addSubview:button];

        [NSLayoutConstraint activateConstraints:@[
            [button.topAnchor constraintEqualToAnchor:previousButton.bottomAnchor
                                             constant:60],
            [button.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor
                                                 constant:40],
            [button.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor
                                                  constant:-40],
            [button.heightAnchor constraintEqualToConstant:60]
        ]];
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
    // 弹出选择环境的弹窗
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择环境" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    // 选项1：切换测试
    UIAlertAction *testAction = [UIAlertAction actionWithTitle:@"切换测试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [AppConfig saveEnvironment:EnvironmentType_Test];
        exit(0);
    }];

    // 选项2：切换正式
    UIAlertAction *productAction = [UIAlertAction actionWithTitle:@"切换正式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [AppConfig saveEnvironment:EnvironmentType_Release];
        exit(0);
    }];

    // 取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:testAction];
    [alert addAction:productAction];
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)adTypeSwitchChanged:(UISwitch *)sender {
    [AppConfig shared].isOpenAppOpenAd = sender.isOn;
}

- (void)hotAdTypeSwitchChanged:(UISwitch *)sender {
    [AppConfig shared].isOpenHotAppOpenAd = sender.isOn;
}

@end
