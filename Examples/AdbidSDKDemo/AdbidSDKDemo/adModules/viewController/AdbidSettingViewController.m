//
//  AdbidSettingViewController.m
//  AdbidSDKDemo
//
//  Created by chaizhiyong on 2026/4/9.
//

#import "AdbidSettingViewController.h"
#import "AppConfig.h"
#import <AdbidSDK/AdbidSDK.h>
#import <LeadmoadAdSDK/LeadmoadAdSDK.h>

@interface AdbidSettingViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *adTypeSwitch;
@property (nonatomic, strong) UISwitch *hotAdTypeSwitch;
@property (nonatomic, strong) UILabel *envTitleLabel;
@property (nonatomic, strong) UILabel *flatTitleLabel;
@property (nonatomic, strong) UIView *platformPopupOverlay;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *contentStackView;
@property (nonatomic, strong) NSArray *options;
@end

@implementation AdbidSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.options = [AppConfig availablePlatforms];
    [self setupGradientBackground];
    [self setupSwitchs];
    [self setupButtons];
}

- (void)setupGradientBackground {
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:247/255.0 blue:250/255.0 alpha:1.0];
}

- (void)setupSwitchs {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];

    self.contentStackView = [[UIStackView alloc] init];
    self.contentStackView.axis = UILayoutConstraintAxisVertical;
    self.contentStackView.spacing = 16;
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

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"广告调试配置";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    self.titleLabel.textColor = [UIColor colorWithRed:0.10 green:0.13 blue:0.18 alpha:1.0];
    [self.contentStackView addArrangedSubview:self.titleLabel];

    UIView *statusCard = [self createCardView];
    UIStackView *statusStack = [self createCardStackInView:statusCard];

    self.envTitleLabel = [self createValueLabelWithText:[AppConfig currentEnvironmentDisplayText]];
    [self addInfoRowToStack:statusStack title:@"当前环境" valueLabel:self.envTitleLabel];
    [statusStack addArrangedSubview:[self createDividerView]];

    self.flatTitleLabel = [self createValueLabelWithText:[AppConfig selectedPlatformsDisplayText]];
    [self addInfoRowToStack:statusStack title:@"广告平台" valueLabel:self.flatTitleLabel];
    [statusStack addArrangedSubview:[self createDividerView]];

    [self addInfoRowToStack:statusStack
                      title:@"LeadmoadAdSDK"
                 valueLabel:[self createValueLabelWithText:[LMAdSDKConfiguration sdkVersion]]];
    [statusStack addArrangedSubview:[self createDividerView]];

    [self addInfoRowToStack:statusStack
                      title:@"AdbidSDK"
                 valueLabel:[self createValueLabelWithText:[AdbidSDKConfiguration sdkVersion]]];

    [self addOptionalSDKVersionRowsToStack:statusStack];
    [self.contentStackView addArrangedSubview:statusCard];

    UILabel *switchTitleLabel = [self createSectionTitleLabelWithText:@"开屏设置"];
    [self.contentStackView addArrangedSubview:switchTitleLabel];

    UIView *switchCard = [self createCardView];
    UIStackView *switchStack = [self createCardStackInView:switchCard];

    self.adTypeSwitch = [[UISwitch alloc] init];
    self.adTypeSwitch.on = [AppConfig shared].isOpenAppOpenAd;  // 默认图片广告
    self.adTypeSwitch.onTintColor = [UIColor colorWithRed:0.18 green:0.48 blue:0.95 alpha:1.0];
    [self.adTypeSwitch addTarget:self
                          action:@selector(adTypeSwitchChanged:)
                forControlEvents:UIControlEventValueChanged];
    [self addSwitchRowToStack:switchStack title:@"开屏广告" switchView:self.adTypeSwitch];
    [switchStack addArrangedSubview:[self createDividerView]];

    self.hotAdTypeSwitch = [[UISwitch alloc] init];
    self.hotAdTypeSwitch.on = [AppConfig shared].isOpenHotAppOpenAd;  // 默认图片广告
    self.hotAdTypeSwitch.onTintColor = [UIColor colorWithRed:0.18 green:0.48 blue:0.95 alpha:1.0];
    [self.hotAdTypeSwitch addTarget:self
                          action:@selector(hotAdTypeSwitchChanged:)
                forControlEvents:UIControlEventValueChanged];
    [self addSwitchRowToStack:switchStack title:@"热启动开屏广告" switchView:self.hotAdTypeSwitch];
    [self.contentStackView addArrangedSubview:switchCard];
}

- (void)setupButtons {
    UILabel *actionTitleLabel = [self createSectionTitleLabelWithText:@"操作"];
    [self.contentStackView addArrangedSubview:actionTitleLabel];

    UIStackView *buttonStack = [[UIStackView alloc] init];
    buttonStack.axis = UILayoutConstraintAxisVertical;
    buttonStack.spacing = 10;
    buttonStack.translatesAutoresizingMaskIntoConstraints = NO;

    NSArray *buttonConfigs = @[
        @{@"title" : @"切换环境", @"icon" : @"server.rack", @"action" : @"splashButtonTapped:"},
        @{@"title" : @"切换广告平台", @"icon" : @"rectangle.3.group", @"action" : @"switchButtonTapped:"},
    ];

    for (int i = 0; i < buttonConfigs.count; i++) {
        NSDictionary *config = buttonConfigs[i];
        UIButton *button = [self createActionButtonWithTitle:config[@"title"]
                                                    iconName:config[@"icon"]
                                                      action:NSSelectorFromString(config[@"action"])];
        [buttonStack addArrangedSubview:button];
    }

    [self.contentStackView addArrangedSubview:buttonStack];
}

- (UIButton *)createActionButtonWithTitle:(NSString *)title iconName:(NSString *)iconName action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = NO;
    button.layer.shadowColor = [UIColor colorWithWhite:0 alpha:1.0].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 4);
    button.layer.shadowRadius = 14;
    button.layer.shadowOpacity = 0.06;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [button.heightAnchor constraintEqualToConstant:46].active = YES;

    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:iconName]];
    iconView.tintColor = [UIColor colorWithRed:0.18 green:0.48 blue:0.95 alpha:1.0];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    iconView.userInteractionEnabled = NO;
    [button addSubview:iconView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.textColor = [UIColor colorWithRed:0.14 green:0.18 blue:0.25 alpha:1.0];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.userInteractionEnabled = NO;
    [button addSubview:titleLabel];

    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.right"]];
    arrowView.tintColor = [UIColor colorWithRed:0.58 green:0.62 blue:0.68 alpha:1.0];
    arrowView.contentMode = UIViewContentModeScaleAspectFit;
    arrowView.translatesAutoresizingMaskIntoConstraints = NO;
    arrowView.userInteractionEnabled = NO;
    [button addSubview:arrowView];

    [NSLayoutConstraint activateConstraints:@[
        [iconView.leadingAnchor constraintEqualToAnchor:button.leadingAnchor constant:16],
        [iconView.centerYAnchor constraintEqualToAnchor:button.centerYAnchor],
        [iconView.widthAnchor constraintEqualToConstant:20],
        [iconView.heightAnchor constraintEqualToConstant:20],

        [titleLabel.leadingAnchor constraintEqualToAnchor:iconView.trailingAnchor constant:12],
        [titleLabel.centerYAnchor constraintEqualToAnchor:button.centerYAnchor],
        [titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:arrowView.leadingAnchor constant:-12],

        [arrowView.trailingAnchor constraintEqualToAnchor:button.trailingAnchor constant:-16],
        [arrowView.centerYAnchor constraintEqualToAnchor:button.centerYAnchor],
        [arrowView.widthAnchor constraintEqualToConstant:14],
        [arrowView.heightAnchor constraintEqualToConstant:14],
    ]];

    return button;
}

- (UIView *)createCardView {
    UIView *card = [[UIView alloc] init];
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 12;
    card.layer.shadowColor = [UIColor colorWithWhite:0 alpha:1.0].CGColor;
    card.layer.shadowOffset = CGSizeMake(0, 4);
    card.layer.shadowRadius = 16;
    card.layer.shadowOpacity = 0.06;
    return card;
}

- (UIStackView *)createCardStackInView:(UIView *)card {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 0;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [card addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:card.topAnchor constant:10],
        [stack.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16],
        [stack.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16],
        [stack.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-10],
    ]];

    return stack;
}

- (UILabel *)createSectionTitleLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:0.36 green:0.40 blue:0.48 alpha:1.0];
    return label;
}

- (UILabel *)createValueLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor colorWithRed:0.12 green:0.16 blue:0.22 alpha:1.0];
    label.numberOfLines = 1;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.75;
    return label;
}

- (void)addInfoRowToStack:(UIStackView *)stack title:(NSString *)title valueLabel:(UILabel *)valueLabel {
    UIView *row = [[UIView alloc] init];
    [row.heightAnchor constraintEqualToConstant:38].active = YES;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithRed:0.34 green:0.38 blue:0.45 alpha:1.0];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [row addSubview:titleLabel];

    valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [row addSubview:valueLabel];

    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.leadingAnchor constraintEqualToAnchor:row.leadingAnchor],
        [titleLabel.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [titleLabel.widthAnchor constraintGreaterThanOrEqualToConstant:80],

        [valueLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:titleLabel.trailingAnchor constant:12],
        [valueLabel.trailingAnchor constraintEqualToAnchor:row.trailingAnchor],
        [valueLabel.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
    ]];

    [stack addArrangedSubview:row];
}

- (void)addOptionalSDKVersionRowsToStack:(UIStackView *)stack {
    NSArray<NSDictionary *> *sdkConfigs = @[
        @{@"title" : @"YSAdvSDK", @"className" : @"YSAdvSDKManager", @"selectorName" : @"sdkVersion"},
        @{@"title" : @"FunlinkSDK", @"className" : @"FLinkAdSDKManager", @"selectorName" : @"SDKVersion"},
        @{@"title" : @"UBiXMerakSDK", @"className" : @"UBiXAdSDKManager", @"selectorName" : @"SDKVersion"},
    ];

    for (NSDictionary *config in sdkConfigs) {
        NSString *version = [self sdkVersionForClassName:config[@"className"] selectorName:config[@"selectorName"]];
        if (version.length == 0) {
            continue;
        }

        [stack addArrangedSubview:[self createDividerView]];
        [self addInfoRowToStack:stack
                          title:config[@"title"]
                     valueLabel:[self createValueLabelWithText:version]];
    }
}

- (NSString *)sdkVersionForClassName:(NSString *)className selectorName:(NSString *)selectorName {
    Class sdkClass = NSClassFromString(className);
    SEL selector = NSSelectorFromString(selectorName);
    if (!sdkClass || ![sdkClass respondsToSelector:selector]) {
        return nil;
    }

    IMP implementation = [sdkClass methodForSelector:selector];
    NSString *(*versionFunction)(id, SEL) = (NSString *(*)(id, SEL))implementation;
    id version = versionFunction(sdkClass, selector);
    if (![version isKindOfClass:[NSString class]]) {
        return nil;
    }

    return version;
}

- (void)addSwitchRowToStack:(UIStackView *)stack title:(NSString *)title switchView:(UISwitch *)switchView {
    UIView *row = [[UIView alloc] init];
    [row.heightAnchor constraintEqualToConstant:38].active = YES;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.textColor = [UIColor colorWithRed:0.16 green:0.20 blue:0.27 alpha:1.0];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [row addSubview:titleLabel];

    switchView.translatesAutoresizingMaskIntoConstraints = NO;
    [row addSubview:switchView];

    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.leadingAnchor constraintEqualToAnchor:row.leadingAnchor],
        [titleLabel.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
        [titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:switchView.leadingAnchor constant:-12],

        [switchView.trailingAnchor constraintEqualToAnchor:row.trailingAnchor],
        [switchView.centerYAnchor constraintEqualToAnchor:row.centerYAnchor],
    ]];

    [stack addArrangedSubview:row];
}

- (UIView *)createDividerView {
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1.0];
    [divider.heightAnchor constraintEqualToConstant:0.5].active = YES;
    return divider;
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
    UIAlertAction *testAction = [UIAlertAction actionWithTitle:@"切换到10011" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveEnvironmentAndShowRestartAlert:EnvironmentType_Test_10011];
    }];

    // 取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:testAction];
    [alert addAction:cancelAction];

    alert.popoverPresentationController.sourceView = sender;
    alert.popoverPresentationController.sourceRect = sender.bounds;
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveEnvironmentAndShowRestartAlert:(EnvironmentType)environment {
    [AppConfig saveEnvironment:environment];
    self.envTitleLabel.text = [AppConfig currentEnvironmentDisplayText];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"环境已切换"
                                                                   message:@"需要杀掉 App 后重新打开生效"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)switchButtonTapped:(UIButton *)sender {
    [self showSingleSelectPlatformPopup];
}

- (NSString *)currentSelectedPlatform {
    NSArray *savedPlatforms = [AppConfig selectedPlatforms];
    for (NSString *platform in savedPlatforms) {
        if ([self.options containsObject:platform]) {
            return platform;
        }
    }
    if ([self.options containsObject:@"other"]) {
        return @"other";
    }
    return self.options.firstObject;
}

- (void)showSingleSelectPlatformPopup {
    NSString *selectedPlatform = [self currentSelectedPlatform];

    UIView *overlay = [[UIView alloc] initWithFrame:self.view.bounds];
    overlay.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.platformPopupOverlay = overlay;
    [self.view addSubview:overlay];

    UIView *card = [[UIView alloc] init];
    card.tag = 998;
    card.backgroundColor = [UIColor whiteColor];
    card.layer.cornerRadius = 16;
    card.translatesAutoresizingMaskIntoConstraints = NO;
    [overlay addSubview:card];

    [NSLayoutConstraint activateConstraints:@[
        [card.centerXAnchor constraintEqualToAnchor:overlay.centerXAnchor],
        [card.centerYAnchor constraintEqualToAnchor:overlay.centerYAnchor],
        [card.widthAnchor constraintEqualToConstant:280],
    ]];

    UILabel *popupTitle = [[UILabel alloc] init];
    popupTitle.text = @"请选择广告平台";
    popupTitle.font = [UIFont boldSystemFontOfSize:18];
    popupTitle.textAlignment = NSTextAlignmentCenter;
    popupTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [card addSubview:popupTitle];

    [NSLayoutConstraint activateConstraints:@[
        [popupTitle.topAnchor constraintEqualToAnchor:card.topAnchor constant:20],
        [popupTitle.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16],
        [popupTitle.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16],
        [popupTitle.heightAnchor constraintEqualToConstant:24],
    ]];
    NSArray *options = self.options;
    UIView *previousView = popupTitle;

    for (int i = 0; i < (int)options.count; i++) {
        NSString *option = options[i];
        BOOL isSelected = [option isEqualToString:selectedPlatform];

        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBtn.tag = 100 + i;
        checkBtn.selected = isSelected;
        checkBtn.translatesAutoresizingMaskIntoConstraints = NO;
        checkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        checkBtn.tintColor = [UIColor colorWithRed:0.26 green:0.52 blue:0.96 alpha:1.0];

        [checkBtn setImage:[UIImage systemImageNamed:@"circle"] forState:UIControlStateNormal];
        [checkBtn setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"] forState:UIControlStateSelected];

        NSAttributedString *titleAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", option]
                                                                         attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:16],
            NSForegroundColorAttributeName: [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]
        }];
        [checkBtn setAttributedTitle:titleAttr forState:UIControlStateNormal];
        [checkBtn setAttributedTitle:titleAttr forState:UIControlStateSelected];
        [checkBtn addTarget:self action:@selector(platformOptionTapped:) forControlEvents:UIControlEventTouchUpInside];
        [card addSubview:checkBtn];

        [NSLayoutConstraint activateConstraints:@[
            [checkBtn.topAnchor constraintEqualToAnchor:previousView.bottomAnchor constant:12],
            [checkBtn.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:24],
            [checkBtn.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-24],
            [checkBtn.heightAnchor constraintEqualToConstant:44],
        ]];
        previousView = checkBtn;
    }

    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1.0];
    divider.translatesAutoresizingMaskIntoConstraints = NO;
    [card addSubview:divider];

    [NSLayoutConstraint activateConstraints:@[
        [divider.topAnchor constraintEqualToAnchor:previousView.bottomAnchor constant:16],
        [divider.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [divider.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [divider.heightAnchor constraintEqualToConstant:0.5],
    ]];

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithWhite:0.55 alpha:1.0] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [cancelBtn addTarget:self action:@selector(dismissPlatformPopup) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:cancelBtn];

    UIView *vDivider = [[UIView alloc] init];
    vDivider.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1.0];
    vDivider.translatesAutoresizingMaskIntoConstraints = NO;
    [card addSubview:vDivider];

    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithRed:0.26 green:0.52 blue:0.96 alpha:1.0] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    confirmBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [confirmBtn addTarget:self action:@selector(confirmSingleSelectPlatform) forControlEvents:UIControlEventTouchUpInside];
    [card addSubview:confirmBtn];

    [NSLayoutConstraint activateConstraints:@[
        [cancelBtn.topAnchor constraintEqualToAnchor:divider.bottomAnchor],
        [cancelBtn.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [cancelBtn.widthAnchor constraintEqualToAnchor:card.widthAnchor multiplier:0.5],
        [cancelBtn.heightAnchor constraintEqualToConstant:50],
        [cancelBtn.bottomAnchor constraintEqualToAnchor:card.bottomAnchor],

        [vDivider.centerXAnchor constraintEqualToAnchor:card.centerXAnchor],
        [vDivider.topAnchor constraintEqualToAnchor:divider.bottomAnchor],
        [vDivider.widthAnchor constraintEqualToConstant:0.5],
        [vDivider.heightAnchor constraintEqualToConstant:50],

        [confirmBtn.topAnchor constraintEqualToAnchor:divider.bottomAnchor],
        [confirmBtn.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [confirmBtn.widthAnchor constraintEqualToAnchor:card.widthAnchor multiplier:0.5],
        [confirmBtn.heightAnchor constraintEqualToConstant:50],
        [confirmBtn.bottomAnchor constraintEqualToAnchor:card.bottomAnchor],
    ]];

    overlay.alpha = 0;
    card.transform = CGAffineTransformMakeScale(0.85, 0.85);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:0 animations:^{
        overlay.alpha = 1;
        card.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)platformOptionTapped:(UIButton *)sender {
    UIView *card = [self.platformPopupOverlay viewWithTag:998];
    for (int i = 0; i < (int)self.options.count; i++) {
        UIButton *btn = (UIButton *)[card viewWithTag:100 + i];
        btn.selected = NO;
    }
    sender.selected = YES;
}

- (void)confirmSingleSelectPlatform {
    NSArray *options = self.options;
    UIView *card = [self.platformPopupOverlay viewWithTag:998];
    NSString *selectedPlatform = nil;
    for (int i = 0; i < (int)options.count; i++) {
        UIButton *btn = (UIButton *)[card viewWithTag:100 + i];
        if (btn.selected) {
            selectedPlatform = options[i];
            break;
        }
    }
    if (selectedPlatform == nil) {
        selectedPlatform = [self currentSelectedPlatform];
    }

    [AppConfig saveSelectedPlatforms:selectedPlatform ? @[selectedPlatform] : @[]];

    self.flatTitleLabel.text = [AppConfig selectedPlatformsDisplayText];
    [self dismissPlatformPopup];
}

- (void)dismissPlatformPopup {
    [UIView animateWithDuration:0.2 animations:^{
        self.platformPopupOverlay.alpha = 0;
    } completion:^(BOOL finished) {
        [self.platformPopupOverlay removeFromSuperview];
        self.platformPopupOverlay = nil;
    }];
}

- (void)adTypeSwitchChanged:(UISwitch *)sender {
    [AppConfig shared].isOpenAppOpenAd = sender.isOn;
}

- (void)hotAdTypeSwitchChanged:(UISwitch *)sender {
    [AppConfig shared].isOpenHotAppOpenAd = sender.isOn;
}

@end
