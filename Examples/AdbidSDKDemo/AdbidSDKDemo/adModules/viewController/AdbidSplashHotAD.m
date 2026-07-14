//
//  AdbidSplashHotAD.m
//  AdbidSDKDemo
//
//  Created by chaizhiyong on 2026/4/10.
//

#import "AdbidSplashHotAD.h"
#import "AppConfig.h"
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

- (void)performOnMainThread:(dispatch_block_t)block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

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
        self.havedLoad = NO;
    }
    return self;
}

#pragma mark - 公开方法
- (void)loadOrShowSplashHotAD {
    if (self.havedLoad) {
        [self showLimoSplashHotAD];
    } else {
        self.splashHotAD = [[AdbidSplashAd alloc] initWithSlotId:[AppConfig hotID]];
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
    self.havedLoad = NO;
    self.splashHotAD = nil;
    [self loadOrShowSplashHotAD];
}

#pragma mark - AdbidSplashAdDelegate
- (void)splashAdDidLoad:(AdbidSplashAd *)splashAd {
    BOOL callbackOnMainThread = [NSThread isMainThread];
    NSLog(@"热启动开屏广告加载成功回调 isMainThread=%@ 当前线程=%@",
          callbackOnMainThread ? @"YES" : @"NO",
          [NSThread currentThread]);
    [self performOnMainThread:^{
        if ([self.delegate respondsToSelector:@selector(splashHotAdDidLoad)]) {
            [self.delegate splashHotAdDidLoad];
        }
        self.havedLoad = YES;
    }];
}

- (void)splashAd:(AdbidSplashAd *)splashAd didFailToLoadWithError:(NSError *)error {
    [self performOnMainThread:^{
        self.havedLoad = NO;
        if ([self.delegate respondsToSelector:@selector(splashHotAdLoadFailed:)]) {
            [self.delegate splashHotAdLoadFailed:error];
        }
    }];
}

- (void)splashAdDidShow:(AdbidSplashAd *)splashAd {
    [self performOnMainThread:^{
        if ([self.delegate respondsToSelector:@selector(splashHotAdDidShow)]) {
            [self.delegate splashHotAdDidShow];
        }
    }];
}

- (void)splashAd:(AdbidSplashAd *)splashAd didFailToShowWithError:(NSError *)error {
    [self performOnMainThread:^{
        self.havedLoad = NO;
        if ([self.delegate respondsToSelector:@selector(splashHotAdShowFailed:)]) {
            [self.delegate splashHotAdShowFailed:error];
        }
        [self preloadAD]; // 预加载下一次
    }];
}

- (void)splashAdDidClick:(AdbidSplashAd *)splashAd {
    [self performOnMainThread:^{
        if ([self.delegate respondsToSelector:@selector(splashHotAdDidClick)]) {
            [self.delegate splashHotAdDidClick];
        }
    }];
}

- (void)splashAdDidClose:(AdbidSplashAd *)splashAd {
    [self performOnMainThread:^{
        if ([self.delegate respondsToSelector:@selector(splashHotAdDidClose)]) {
            [self.delegate splashHotAdDidClose];
        }
        [self preloadAD]; // 预加载下一次
    }];
}

- (void)splashAdDidFinishConversion:(AdbidSplashAd *)interstitialAd interactionType:(AdbidAdRedirectionType)interactionType {
    [self performOnMainThread:^{
        if ([self.delegate respondsToSelector:@selector(splashHotAdDeepLinkOrJump:)]) {
            [self.delegate splashHotAdDeepLinkOrJump:YES];
        }
    }];
}

@end
