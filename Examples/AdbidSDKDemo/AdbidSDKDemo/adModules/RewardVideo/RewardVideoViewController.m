//
//  RewardVideoViewController.m
//  LeadMoadAdSDKDemo
//
//  Created by youzhadoubao on 2025/9/19.
//

#import "RewardVideoViewController.h"
#import <AdbidSDK/AdbidSDK.h>
#import "AppConfig.h"
@interface RewardVideoViewController () <AdbidRewardVideoAdDelegate>

/// 激励视频广告实例
@property (nonatomic, strong) AdbidRewardVideoAd *rewardVideoAd;

/// 加载按钮
@property (nonatomic, strong) UIButton *loadButton;

/// 展示按钮
@property (nonatomic, strong) UIButton *showButton;

/// 竞胜上报按钮
@property (nonatomic, strong) UIButton *winNoticeButton;

/// 竞败上报按钮
@property (nonatomic, strong) UIButton *lossNoticeButton;

/// 状态标签
@property (nonatomic, strong) UILabel *statusLabel;

/// 日志文本视图
@property (nonatomic, strong) UITextView *logTextView;

/// 广告位ID输入框
@property (nonatomic, strong) UITextField *slotIdTextField;

@end

@implementation RewardVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"激励视频广告测试";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupUI];
    [self setupRewardVideoAd];
}

#pragma mark - Setup

- (void)setupUI {
    // 广告位ID输入框
    self.slotIdTextField = [[UITextField alloc] init];
    self.slotIdTextField.placeholder = @"请输入广告位ID";

    // 尝试获取上次输入的ID
    NSString *savedId = [[NSUserDefaults standardUserDefaults] stringForKey:@"DemoRewardVideoAdID"];
    if (savedId && savedId.length > 0) {
        self.slotIdTextField.text = savedId;
    } else {
        self.slotIdTextField.text = AppConfig.rewardID;  // 默认广告位ID
    }

    self.slotIdTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.slotIdTextField.font = [UIFont systemFontOfSize:16];
    self.slotIdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.slotIdTextField];

    // 加载按钮
    self.loadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loadButton setTitle:@"加载激励视频广告" forState:UIControlStateNormal];
    self.loadButton.backgroundColor = [UIColor systemBlueColor];
    [self.loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loadButton.layer.cornerRadius = 8;
    self.loadButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.loadButton addTarget:self action:@selector(loadButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loadButton];

    // 展示按钮
    self.showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showButton setTitle:@"展示激励视频广告" forState:UIControlStateNormal];
    self.showButton.backgroundColor = [UIColor systemGreenColor];
    [self.showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.showButton.layer.cornerRadius = 8;
    self.showButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.showButton.enabled = NO;  // 初始禁用
    [self.showButton addTarget:self action:@selector(showButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.showButton];

    // 竞胜上报按钮
    self.winNoticeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.winNoticeButton setTitle:@"竞胜上报" forState:UIControlStateNormal];
    self.winNoticeButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
    [self.winNoticeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.winNoticeButton.layer.cornerRadius = 8;
    self.winNoticeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.winNoticeButton addTarget:self action:@selector(winNoticeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
  //  [self.winNoticeButton setHidden:YES];
    [self.view addSubview:self.winNoticeButton];

    // 竞败上报按钮
    self.lossNoticeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.lossNoticeButton setTitle:@"竞败上报" forState:UIControlStateNormal];
    self.lossNoticeButton.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    [self.lossNoticeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.lossNoticeButton.layer.cornerRadius = 8;
    self.lossNoticeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.lossNoticeButton addTarget:self action:@selector(lossNoticeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lossNoticeButton];
 //   [self.lossNoticeButton setHidden:YES];

    // 状态标签
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"状态: 未加载";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:self.statusLabel];

    // 日志文本视图
    self.logTextView = [[UITextView alloc] init];
    self.logTextView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    self.logTextView.font = [UIFont systemFontOfSize:12];
    self.logTextView.editable = NO;
    self.logTextView.layer.cornerRadius = 8;
    self.logTextView.layer.borderWidth = 1;
    self.logTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:self.logTextView];

    // 设置约束
    [self setupConstraints];
}

- (void)setupConstraints {
    self.slotIdTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.loadButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.showButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.winNoticeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.lossNoticeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.logTextView.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        // 广告位ID输入框
        [self.slotIdTextField.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.slotIdTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.slotIdTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.slotIdTextField.heightAnchor constraintEqualToConstant:44],

        // 加载按钮
        [self.loadButton.topAnchor constraintEqualToAnchor:self.slotIdTextField.bottomAnchor constant:15],
        [self.loadButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.loadButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.loadButton.heightAnchor constraintEqualToConstant:50],

        // 展示按钮
        [self.showButton.topAnchor constraintEqualToAnchor:self.loadButton.bottomAnchor constant:15],
        [self.showButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.showButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.showButton.heightAnchor constraintEqualToConstant:50],

        // 竞胜上报按钮
        [self.winNoticeButton.topAnchor constraintEqualToAnchor:self.showButton.bottomAnchor constant:15],
        [self.winNoticeButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.winNoticeButton.trailingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:-10],
        [self.winNoticeButton.heightAnchor constraintEqualToConstant:50],

        // 竞败上报按钮
        [self.lossNoticeButton.topAnchor constraintEqualToAnchor:self.showButton.bottomAnchor constant:15],
        [self.lossNoticeButton.leadingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:10],
        [self.lossNoticeButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.lossNoticeButton.heightAnchor constraintEqualToConstant:50],

        // 状态标签
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.winNoticeButton.bottomAnchor constant:20],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.statusLabel.heightAnchor constraintEqualToConstant:30],

        // 日志文本视图
        [self.logTextView.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:15],
        [self.logTextView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.logTextView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.logTextView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20]
    ]];
}

- (void)setupRewardVideoAd {
    // 创建激励视频广告实例
    NSString *slotId = self.slotIdTextField.text.length > 0 ? self.slotIdTextField.text : @"100130105000001";
    self.rewardVideoAd = [[AdbidRewardVideoAd alloc] initWithSlotId:slotId];
    self.rewardVideoAd.delegate = self;

    [self addLog:[NSString stringWithFormat:@"激励视频广告实例已创建，广告位ID: %@", slotId]];
}

#pragma mark - Button Actions

- (void)loadButtonTapped {
    // 获取当前输入的广告位ID
    NSString *currentSlotId = self.slotIdTextField.text.length > 0 ? self.slotIdTextField.text : @"100130105000001";

    // 保存输入的ID
    if (self.slotIdTextField.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.slotIdTextField.text forKey:@"DemoRewardVideoAdID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    // 如果广告位ID发生变化，重新创建广告实例
    if (!self.rewardVideoAd || ![currentSlotId isEqualToString:self.rewardVideoAd.description]) {
        [self addLog:[NSString stringWithFormat:@"广告位ID已更改为: %@，重新创建广告实例", currentSlotId]];
        self.rewardVideoAd = [[AdbidRewardVideoAd alloc] initWithSlotId:currentSlotId];
        self.rewardVideoAd.delegate = self;
    }

    [self addLog:[NSString stringWithFormat:@"开始加载激励视频广告，广告位ID: %@", currentSlotId]];
    self.statusLabel.text = @"状态: 加载中...";
    self.loadButton.enabled = NO;
    self.showButton.enabled = NO;

    [self.rewardVideoAd loadAd];
}

- (void)showButtonTapped {
    //if ([self.rewardVideoAd isReady]) {
        [self addLog:@"开始展示激励视频广告..."];
        self.statusLabel.text = @"状态: 展示中...";
        [self.rewardVideoAd showAd:self];
//    } else {
//        [self addLog:@"广告未准备好，无法展示"];
//        self.statusLabel.text = @"状态: 广告未准备好";
//    }
}

- (void)winNoticeButtonTapped {
    if (self.rewardVideoAd && self.rewardVideoAd.isReady) {
        [self addLog:@"正在上报竞胜..."];
        [self.rewardVideoAd winNotice:self.rewardVideoAd.eCPM];
        [self addLog:[NSString stringWithFormat:@"竞胜上报成功，价格: %ld", (long)self.rewardVideoAd.eCPM]];
    } else {
        [self addLog:@"请先加载广告"];
    }
}

- (void)lossNoticeButtonTapped {
    if (self.rewardVideoAd && self.rewardVideoAd.isReady) {
        [self addLog:@"正在上报竞败..."];
        
        AdbidBidLossInfo *info = [[AdbidBidLossInfo alloc] init];
        info.winnerPrice = self.rewardVideoAd.eCPM + 10; // 模拟竞胜价格高于我方
        info.winnerPlatform = AdbidPlatform_CSJ; // 模拟穿山甲竞胜
        
        [self.rewardVideoAd lossNotice:info];
        [self addLog:[NSString stringWithFormat:@"竞败上报成功，竞胜价格: %ld", (long)info.winnerPrice]];
    } else {
        [self addLog:@"请先加载广告"];
    }
}

#pragma mark - AdbidRewardVideoAdDelegate

- (void)rewardVideoAdDidLoad:(AdbidRewardVideoAd *)rewardVideoAd {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLog:@"✅ 激励视频广告加载成功"];
        self.statusLabel.text = @"状态: 已加载，可以展示";
        self.loadButton.enabled = YES;
        self.showButton.enabled = YES;
    });
}

- (void)rewardVideoAd:(AdbidRewardVideoAd *)rewardVideoAd didFailToLoadWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLog:[NSString stringWithFormat:@"❌ 激励视频广告加载失败: %@", error.localizedDescription]];
        self.statusLabel.text = @"状态: 加载失败";
        self.loadButton.enabled = YES;
        self.showButton.enabled = NO;
    });
}

- (void)rewardVideoAdDidShow:(AdbidRewardVideoAd *)rewardVideoAd {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLog:@"📺 激励视频广告开始展示"];
        self.statusLabel.text = @"状态: 正在展示";
    });
}

- (void)rewardVideoAd:(AdbidRewardVideoAd *)rewardVideoAd didFailToShowWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLog:[NSString stringWithFormat:@"❌ 激励视频广告展示失败: %@", error.localizedDescription]];
        self.statusLabel.text = @"状态: 展示失败";
        self.showButton.enabled = [rewardVideoAd isReady];
    });
}

- (void)rewardVideoAdDidStartPlay:(AdbidRewardVideoAd *)rewardedVideoAd {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLog:@"▶️ 视频开始播放"];
    });
}

- (void)rewardVideoAdDidEndPlay:(AdbidRewardVideoAd *)rewardedVideoAd withError:(NSError *_Nullable)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error == nil) {
            [self addLog:@"⏹️ 视频播放完成"];
        } else {
            [self addLog:@"⏹️ 视频播放失败"];
        }
    });
}

- (void)rewardVideoAdDidReward:(AdbidRewardVideoAd *)rewardVideoAd {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLog:@"🎁 用户获得奖励！"];

        // 显示奖励提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜！"
                                                                       message:@"您已获得奖励！"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)rewardVideoAdDidClick:(AdbidRewardVideoAd *)rewardVideoAd {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLog:@"👆 用户点击了广告"];
    });
}

- (void)rewardVideoAdDidClose:(AdbidRewardVideoAd *)rewardVideoAd {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addLog:@"❌ 激励视频广告已关闭"];
        self.statusLabel.text = @"状态: 已关闭，可重新加载";
        self.showButton.enabled = NO;
    });
}

#pragma mark - Helper Methods

- (void)addLog:(NSString *)message {
    NSLog(@"%@", message);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm:ss";
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
