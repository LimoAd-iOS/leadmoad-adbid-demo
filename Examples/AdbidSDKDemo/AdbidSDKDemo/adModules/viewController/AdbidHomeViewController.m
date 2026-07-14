//
//  AdbidHomeViewController.m
//  LeadMoadAdSDKDemo
//
//  Created by youzhadoubao on 2025/9/17.
//

#import "AdbidHomeViewController.h"
#import "NativeAdViewController.h"
#import "BottomNativeAdViewController.h"

#import "RewardVideoViewController.h"
#import "SplashAdViewController.h"
#import "InterstitialViewController.h"

// 导入头文件
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
@interface AdbidHomeViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStackView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation AdbidHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self setupUI];
}

- (void)setupUI {
    [self setupGradientBackground];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];

    self.contentStackView = [[UIStackView alloc] init];
    self.contentStackView.axis = UILayoutConstraintAxisVertical;
    self.contentStackView.spacing = 14;
    self.contentStackView.layoutMargins = UIEdgeInsetsMake(24, 20, 24, 20);
    self.contentStackView.layoutMarginsRelativeArrangement = YES;
    self.contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.contentStackView];

    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [self.contentStackView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [self.contentStackView.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.contentStackView.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.contentStackView.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor],
        [self.contentStackView.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor],
    ]];

    [self setupTitleLabel];
    [self setupButtons];
}

- (void)setupGradientBackground {
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:247/255.0 blue:250/255.0 alpha:1.0];
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"领摩聚合广告";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    self.titleLabel.textColor = [UIColor colorWithRed:0.10 green:0.13 blue:0.18 alpha:1.0];
    [self.contentStackView addArrangedSubview:self.titleLabel];

    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"选择广告类型进入调试页面";
    subtitleLabel.font = [UIFont systemFontOfSize:14];
    subtitleLabel.textColor = [UIColor colorWithRed:0.42 green:0.46 blue:0.52 alpha:1.0];
    [self.contentStackView addArrangedSubview:subtitleLabel];
    [self.contentStackView setCustomSpacing:20 afterView:subtitleLabel];
}

- (void)setupButtons {
    NSArray *buttonConfigs = @[
        @{@"title" : @"开屏广告", @"subtitle" : @"Splash", @"icon" : @"sparkles", @"action" : @"splashButtonTapped:"},
        @{@"title" : @"激励视频", @"subtitle" : @"Reward Video", @"icon" : @"play.rectangle.fill", @"action" : @"rewardVideoButtonTapped:"},
        @{@"title" : @"插屏广告", @"subtitle" : @"Interstitial", @"icon" : @"rectangle.stack", @"action" : @"interstitialButtonTapped:"},
        @{@"title" : @"信息流（draw）", @"subtitle" : @"Native", @"icon" : @"list.bullet.rectangle", @"action" : @"nativeButtonTapped:"},
        @{@"title" : @"底通信息流", @"subtitle" : @"Native", @"icon" : @"list.bullet.rectangle", @"action" : @"bottomNativeFeedButtonTapped:"},
    ];

    for (int i = 0; i < buttonConfigs.count; i++) {
        NSDictionary *config = buttonConfigs[i];
        UIButton *button = [self createAdEntryButtonWithTitle:config[@"title"]
                                                     subtitle:config[@"subtitle"]
                                                     iconName:config[@"icon"]
                                                       action:NSSelectorFromString(config[@"action"])];
        [self.contentStackView addArrangedSubview:button];
    }
}

- (UIButton *)createAdEntryButtonWithTitle:(NSString *)title subtitle:(NSString *)subtitle iconName:(NSString *)iconName action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 12;
    button.layer.masksToBounds = NO;
    button.layer.shadowColor = [UIColor colorWithWhite:0 alpha:1.0].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 4);
    button.layer.shadowRadius = 16;
    button.layer.shadowOpacity = 0.06;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [button.heightAnchor constraintEqualToConstant:64].active = YES;

    UIView *iconBackgroundView = [[UIView alloc] init];
    iconBackgroundView.backgroundColor = [UIColor colorWithRed:0.90 green:0.94 blue:1.0 alpha:1.0];
    iconBackgroundView.layer.cornerRadius = 9;
    iconBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    iconBackgroundView.userInteractionEnabled = NO;
    [button addSubview:iconBackgroundView];

    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:iconName]];
    iconView.tintColor = [UIColor colorWithRed:0.18 green:0.48 blue:0.95 alpha:1.0];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [iconBackgroundView addSubview:iconView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    titleLabel.textColor = [UIColor colorWithRed:0.12 green:0.16 blue:0.22 alpha:1.0];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.userInteractionEnabled = NO;
    [button addSubview:titleLabel];

    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = subtitle;
    subtitleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    subtitleLabel.textColor = [UIColor colorWithRed:0.48 green:0.52 blue:0.58 alpha:1.0];
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    subtitleLabel.userInteractionEnabled = NO;
    [button addSubview:subtitleLabel];

    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.right"]];
    arrowView.tintColor = [UIColor colorWithRed:0.58 green:0.62 blue:0.68 alpha:1.0];
    arrowView.contentMode = UIViewContentModeScaleAspectFit;
    arrowView.translatesAutoresizingMaskIntoConstraints = NO;
    arrowView.userInteractionEnabled = NO;
    [button addSubview:arrowView];

    [NSLayoutConstraint activateConstraints:@[
        [iconBackgroundView.leadingAnchor constraintEqualToAnchor:button.leadingAnchor constant:16],
        [iconBackgroundView.centerYAnchor constraintEqualToAnchor:button.centerYAnchor],
        [iconBackgroundView.widthAnchor constraintEqualToConstant:38],
        [iconBackgroundView.heightAnchor constraintEqualToConstant:38],

        [iconView.centerXAnchor constraintEqualToAnchor:iconBackgroundView.centerXAnchor],
        [iconView.centerYAnchor constraintEqualToAnchor:iconBackgroundView.centerYAnchor],
        [iconView.widthAnchor constraintEqualToConstant:20],
        [iconView.heightAnchor constraintEqualToConstant:20],

        [titleLabel.leadingAnchor constraintEqualToAnchor:iconBackgroundView.trailingAnchor constant:12],
        [titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:arrowView.leadingAnchor constant:-12],
        [titleLabel.bottomAnchor constraintEqualToAnchor:button.centerYAnchor constant:-2],

        [subtitleLabel.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
        [subtitleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:arrowView.leadingAnchor constant:-12],
        [subtitleLabel.topAnchor constraintEqualToAnchor:button.centerYAnchor constant:3],

        [arrowView.trailingAnchor constraintEqualToAnchor:button.trailingAnchor constant:-16],
        [arrowView.centerYAnchor constraintEqualToAnchor:button.centerYAnchor],
        [arrowView.widthAnchor constraintEqualToConstant:14],
        [arrowView.heightAnchor constraintEqualToConstant:14],
    ]];

    return button;
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
    [self pushSecondLevelViewController:splashVC];
}

- (void)rewardVideoButtonTapped:(UIButton *)sender {
    RewardVideoViewController *rewardVideoVC = [[RewardVideoViewController alloc] init];
    [self pushSecondLevelViewController:rewardVideoVC];
}

- (void)nativeButtonTapped:(UIButton *)sender {
    NativeAdViewController *splashVC = [[NativeAdViewController alloc] init];
    [self pushSecondLevelViewController:splashVC];
}

- (void)bottomNativeFeedButtonTapped:(UIButton *)sender {
    BottomNativeAdViewController *splashVC = [[BottomNativeAdViewController alloc] init];
    [self pushSecondLevelViewController:splashVC];
}

- (void)interstitialButtonTapped:(UIButton *)sender {
    InterstitialViewController *rewardVideoVC = [[InterstitialViewController alloc] init];
    [self pushSecondLevelViewController:rewardVideoVC];
}

- (void)pushSecondLevelViewController:(UIViewController *)viewController {
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
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
