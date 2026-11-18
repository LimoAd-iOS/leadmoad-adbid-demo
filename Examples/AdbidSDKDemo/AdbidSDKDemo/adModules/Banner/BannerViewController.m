//
//  BannerViewController.m
//  AdbidSDKDemo
//

#import "BannerViewController.h"
#import <AdbidSDK/AdbidSDK.h>
#import "AppConfig.h"

@interface BannerViewController () <AdbidBannerAdDelegate>

@property (nonatomic, strong) AdbidBannerAd *bannerAd;
@property (nonatomic, strong) UITextField *slotIdTextField;
@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UIButton *winNoticeButton;
@property (nonatomic, strong) UIButton *lossNoticeButton;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UITextView *logTextView;
@property (nonatomic, strong) UIView *bannerContainerView;

@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"横幅广告测试";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:247/255.0 blue:250/255.0 alpha:1.0];
    [self setupUI];
}

- (void)dealloc {
    _bannerAd.delegate = nil;
}

- (void)setupUI {
    self.slotIdTextField = [[UITextField alloc] init];
    self.slotIdTextField.placeholder = @"请输入广告位ID";
    self.slotIdTextField.text = AppConfig.bannerID;
    self.slotIdTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.slotIdTextField.font = [UIFont systemFontOfSize:16];
    self.slotIdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self configurePlatformRightViewForTextField:self.slotIdTextField];
    [self configureTextFieldStyle:self.slotIdTextField];
    [self.view addSubview:self.slotIdTextField];

    self.loadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loadButton setTitle:@"加载横幅广告" forState:UIControlStateNormal];
    [self.loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loadButton addTarget:self action:@selector(loadButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self configureButton:self.loadButton backgroundColor:[self primaryColor]];
    [self.view addSubview:self.loadButton];

    self.showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showButton setTitle:@"展示横幅广告" forState:UIControlStateNormal];
    [self.showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.showButton.enabled = NO;
    [self.showButton addTarget:self action:@selector(showButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self configureButton:self.showButton backgroundColor:[UIColor colorWithRed:0.18 green:0.65 blue:0.35 alpha:1.0]];
    [self.view addSubview:self.showButton];

    self.winNoticeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.winNoticeButton setTitle:@"竞胜上报" forState:UIControlStateNormal];
    [self.winNoticeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.winNoticeButton addTarget:self action:@selector(winNoticeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self configureButton:self.winNoticeButton backgroundColor:[UIColor colorWithRed:0.18 green:0.65 blue:0.35 alpha:1.0]];
    [self.view addSubview:self.winNoticeButton];

    self.lossNoticeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.lossNoticeButton setTitle:@"竞败上报" forState:UIControlStateNormal];
    [self.lossNoticeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.lossNoticeButton addTarget:self action:@selector(lossNoticeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self configureButton:self.lossNoticeButton backgroundColor:[UIColor colorWithRed:0.42 green:0.46 blue:0.52 alpha:1.0]];
    [self.view addSubview:self.lossNoticeButton];

    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"状态: 未加载";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textColor = [UIColor darkGrayColor];
    [self configureStatusLabelStyle:self.statusLabel];
    [self.view addSubview:self.statusLabel];

    self.logTextView = [[UITextView alloc] init];
    self.logTextView.editable = NO;
    [self configureLogTextViewStyle:self.logTextView];
    [self.view addSubview:self.logTextView];

    self.bannerContainerView = [[UIView alloc] init];
    self.bannerContainerView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    self.bannerContainerView.layer.cornerRadius = 4;
    self.bannerContainerView.clipsToBounds = YES;
    [self.view addSubview:self.bannerContainerView];

    [self setupConstraints];
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

- (void)setupConstraints {
    self.slotIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.loadButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.showButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.winNoticeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.lossNoticeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.logTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bannerContainerView.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.slotIdTextField.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.slotIdTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.slotIdTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.slotIdTextField.heightAnchor constraintEqualToConstant:44],

        [self.loadButton.topAnchor constraintEqualToAnchor:self.slotIdTextField.bottomAnchor constant:14],
        [self.loadButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.loadButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.loadButton.heightAnchor constraintEqualToConstant:46],

        [self.showButton.topAnchor constraintEqualToAnchor:self.loadButton.bottomAnchor constant:12],
        [self.showButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.showButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.showButton.heightAnchor constraintEqualToConstant:46],

        [self.winNoticeButton.topAnchor constraintEqualToAnchor:self.showButton.bottomAnchor constant:12],
        [self.winNoticeButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.winNoticeButton.trailingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:-10],
        [self.winNoticeButton.heightAnchor constraintEqualToConstant:46],

        [self.lossNoticeButton.topAnchor constraintEqualToAnchor:self.showButton.bottomAnchor constant:12],
        [self.lossNoticeButton.leadingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:10],
        [self.lossNoticeButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.lossNoticeButton.heightAnchor constraintEqualToConstant:46],

        [self.statusLabel.topAnchor constraintEqualToAnchor:self.winNoticeButton.bottomAnchor constant:16],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.statusLabel.heightAnchor constraintEqualToConstant:38],

        [self.logTextView.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:15],
        [self.logTextView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.logTextView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.logTextView.bottomAnchor constraintEqualToAnchor:self.bannerContainerView.topAnchor constant:-12],

        [self.bannerContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.bannerContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.bannerContainerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-8],
        [self.bannerContainerView.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (void)loadButtonTapped {
    NSString *currentSlotId = self.slotIdTextField.text.length > 0 ? self.slotIdTextField.text : AppConfig.bannerID;
    self.bannerAd.delegate = nil;
    self.bannerAd = [[AdbidBannerAd alloc] initWithSlotId:currentSlotId];
    self.bannerAd.delegate = self;
    self.bannerAd.viewController = self;

    [self addLog:[NSString stringWithFormat:@"开始加载横幅广告，广告位ID: %@", currentSlotId]];
    self.statusLabel.text = @"状态: 加载中...";
    self.loadButton.enabled = NO;
    self.showButton.enabled = NO;
    [self.bannerAd loadAd];
}

- (void)showButtonTapped {
    if ([self.bannerAd isReady]) {
        [self addLog:@"开始展示横幅广告..."];
        self.statusLabel.text = @"状态: 展示中...";
        [self.bannerAd showBannerAdWithView:self.bannerContainerView];
    } else {
        [self addLog:@"广告未准备好，无法展示"];
        self.statusLabel.text = @"状态: 广告未准备好";
    }
}

- (void)winNoticeButtonTapped {
    if (self.bannerAd && self.bannerAd.isReady) {
        [self.bannerAd winNotice:self.bannerAd.eCPM];
        [self addLog:[NSString stringWithFormat:@"竞胜上报成功，价格: %ld", (long)self.bannerAd.eCPM]];
    } else {
        [self addLog:@"请先加载广告"];
    }
}

- (void)lossNoticeButtonTapped {
    if (self.bannerAd && self.bannerAd.isReady) {
        AdbidBidLossInfo *info = [[AdbidBidLossInfo alloc] init];
        info.winnerPrice = self.bannerAd.eCPM + 10;
        info.winnerPlatform = AdbidPlatform_CSJ;
        [self.bannerAd lossNotice:info];
        [self addLog:[NSString stringWithFormat:@"竞败上报成功，竞胜价格: %ld", (long)info.winnerPrice]];
    } else {
        [self addLog:@"请先加载广告"];
    }
}

#pragma mark - AdbidBannerAdDelegate

- (void)bannerAdDidLoad:(AdbidBannerAd *)bannerAd {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLog:@"横幅广告加载成功"];
        self.statusLabel.text = @"状态: 已加载，可以展示";
        self.loadButton.enabled = YES;
        self.showButton.enabled = YES;
    });
}

- (void)bannerAdFailedToLoad:(AdbidBannerAd *)bannerAd withError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLog:[NSString stringWithFormat:@"横幅广告加载失败: %@", error.localizedDescription]];
        self.statusLabel.text = @"状态: 加载失败";
        self.loadButton.enabled = YES;
        self.showButton.enabled = NO;
    });
}

- (void)bannerAdDidShow:(AdbidBannerAd *)bannerAd {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLog:@"横幅广告开始展示"];
        self.statusLabel.text = @"状态: 正在展示";
    });
}

- (void)bannerAdFailedToShow:(AdbidBannerAd *)bannerAd withError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLog:[NSString stringWithFormat:@"横幅广告展示失败: %@", error.localizedDescription]];
        self.statusLabel.text = @"状态: 展示失败";
        self.showButton.enabled = [bannerAd isReady];
    });
}

- (void)bannerAdDidClick:(AdbidBannerAd *)bannerAd {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLog:@"用户点击了横幅广告"];
    });
}

- (void)bannerAdDidClose:(AdbidBannerAd *)bannerAd {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLog:@"横幅广告已关闭"];
        self.statusLabel.text = @"状态: 已关闭，可重新加载";
        self.showButton.enabled = NO;
        [bannerAd removeBannerAdWithView:self.bannerContainerView];
    });
}

- (void)bannerAdDidFinishConversion:(AdbidBannerAd *)bannerAd interactionType:(AdbidAdRedirectionType)interactionType {
    [self addLog:[NSString stringWithFormat:@"横幅广告跳转完成 type=%d", (int)interactionType]];
}

- (void)addLog:(NSString *)message {
    NSLog(@"%@", message);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm:ss.SSS";
        NSString *timestamp = [formatter stringFromDate:[NSDate date]];
        NSString *logMessage = [NSString stringWithFormat:@"[%@] %@\n", timestamp, message];
        self.logTextView.text = [self.logTextView.text stringByAppendingString:logMessage];
        if (self.logTextView.text.length > 0) {
            NSRange bottom = NSMakeRange(self.logTextView.text.length - 1, 1);
            [self.logTextView scrollRangeToVisible:bottom];
        }
    });
}

@end
