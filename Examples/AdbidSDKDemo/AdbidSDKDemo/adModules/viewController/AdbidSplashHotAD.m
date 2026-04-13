//
//  AdbidSplashHotAD.m
//  AdbidSDKDemo
//
//  Created by chaizhiyong on 2026/4/10.
//

#import "AdbidSplashHotAD.h"
#import "AppConfig.h"
#import "TimeUtil.h"
#import "AppDelegate.h"

@interface AdbidSplashHotAD ()<AdbidSplashAdDelegate>
/// 广告实例
@property (nonatomic, strong) AdbidSplashAd *splashHotAD;
/// 是否已加载完成
@property (nonatomic, assign) BOOL havedLoad;

/// 加载广告
- (void)loadHotAD;
/// 展示广告
- (void)showLimoSplashHotAD;
/// 预加载下一次广告
- (void)preloadAD;

@end

@implementation AdbidSplashHotAD

#pragma mark - 单例
+ (instancetype)shared {
    static AdbidSplashHotAD *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        if (self.splashHotAD) {
            NSLog(@"【领摩广告】【热启动】 self..... = %@", self.splashHotAD);
        } else {
            NSLog(@"【领摩广告】【热启动】 self..... =  splashHotAD = nil");
        }
        self.havedLoad = NO;
    }
    return self;
}

#pragma mark - 公开方法
- (void)loadOrShowSplashHotAD {
    if (self.havedLoad) {
        NSLog(@"【领摩广告】【热启动】已缓存，去展示 -- %@", [TimeUtil times].firstObject);
        [self showLimoSplashHotAD];
    } else {
        NSLog(@"【领摩广告】【热启动】未缓存，去加载 -- %@", [TimeUtil times].firstObject);
        self.splashHotAD = [[AdbidSplashAd alloc] initWithSlotId:[AppConfig hotID]];
        NSLog(@"【领摩广告】【热启动】实际加载的splashHotAD = %@", self.splashHotAD);
        self.splashHotAD.delegate = self;
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate && appDelegate.window) {
            self.splashHotAD.viewController = appDelegate.window.rootViewController;
        }
        [self loadHotAD];
    }
}

- (void)stopSplashHotAD {
    self.havedLoad = NO;
}

#pragma mark - 私有方法
- (void)loadHotAD {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.splashHotAD loadAd];
    });
}

- (void)showLimoSplashHotAD {
    if (!self.havedLoad) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate && appDelegate.window) {
            [self.splashHotAD showAdToWindow:appDelegate.window];
        }
    });
}

- (void)preloadAD {
    NSLog(@"【领摩广告】【热启动】去预加载 --- %@", [TimeUtil times].firstObject);
    self.havedLoad = NO;
    self.splashHotAD = nil;
    [self loadOrShowSplashHotAD];
}

#pragma mark - AdbidSplashAdDelegate
- (void)splashAdDidLoad:(AdbidSplashAd *)splashAd {
    NSLog(@"【领摩广告】【热启动】加载成功 --- %@", [TimeUtil times].firstObject);
    if ([self.delegate respondsToSelector:@selector(splashHotAdDidLoad)]) {
        [self.delegate splashHotAdDidLoad];
    }
    self.havedLoad = YES;
}

- (void)splashAd:(AdbidSplashAd *)splashAd didFailToLoadWithError:(NSError *)error {
    NSLog(@"【领摩广告】【热启动】加载失败:%@ --- %@", error, [TimeUtil times].firstObject);
    self.havedLoad = NO;
    if ([self.delegate respondsToSelector:@selector(splashHotAdLoadFailed:)]) {
        [self.delegate splashHotAdLoadFailed:error];
    }
}

- (void)splashAdDidShow:(AdbidSplashAd *)splashAd {
    NSLog(@"【领摩广告】【热启动】展示成功 --- %@", [TimeUtil times].firstObject);
    if ([self.delegate respondsToSelector:@selector(splashHotAdDidShow)]) {
        [self.delegate splashHotAdDidShow];
    }
}

- (void)splashAd:(AdbidSplashAd *)splashAd didFailToShowWithError:(NSError *)error {
    NSLog(@"【领摩广告】【热启动】展示失败 --- %@", [TimeUtil times].firstObject);
    self.havedLoad = NO;
    if ([self.delegate respondsToSelector:@selector(splashHotAdShowFailed:)]) {
        [self.delegate splashHotAdShowFailed:error];
    }
    [self preloadAD]; // 预加载下一次
}

- (void)splashAdDidClick:(AdbidSplashAd *)splashAd {
    NSLog(@"【领摩广告】【热启动】被点击 --- %@", [TimeUtil times].firstObject);
    if ([self.delegate respondsToSelector:@selector(splashHotAdDidClick)]) {
        [self.delegate splashHotAdDidClick];
    }
}

- (void)splashAdDidClose:(AdbidSplashAd *)splashAd {
    NSLog(@"【领摩广告】【热启动】关闭 --- %@", [TimeUtil times].firstObject);
    if ([self.delegate respondsToSelector:@selector(splashHotAdDidClose)]) {
        [self.delegate splashHotAdDidClose];
    }
    [self preloadAD]; // 预加载下一次
}

- (void)splashAdDidFinishConversion:(AdbidSplashAd *)interstitialAd interactionType:(AdbidAdRedirectionType)interactionType {
    NSLog(@"【领摩广告】【热启动】深链接跳转%@ --- %@", @(YES), [TimeUtil times].firstObject);
    if ([self.delegate respondsToSelector:@selector(splashHotAdDeepLinkOrJump:)]) {
        [self.delegate splashHotAdDeepLinkOrJump:YES];
    }
}

@end
