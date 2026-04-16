//
//  AppDelegate.m
//  LeadMoadAdSDKDemo
//
//  Created by youzhadoubao on 2025/9/17.
//
#import "AppDelegate.h"
#include <Foundation/Foundation.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdbidSDK/AdbidSDK.h>
#import "AdbidHomeViewController.h"
#import "GDTAction+convenience.h"
#import "GDTAction.h"
#import "TimeUtil.h"
#import "AdbidTabBarViewController.h"
#import "AppConfig.h"
#import "AdbidSplashHotAD.h"


@interface AppDelegate () <AdbidSplashAdDelegate>
@property (nonatomic, strong) AdbidSplashAd *splashAd;
@property (nonatomic, assign) BOOL isEnterForeground;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *keyWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    AdbidTabBarViewController *tabBar = [[AdbidTabBarViewController alloc] init];
    self.window = keyWindow;
    self.window.rootViewController = tabBar;
    [keyWindow makeKeyAndVisible];
    
    // 清除上次运行保存的广告ID，确保每次重启都使用默认值
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DemoNativeAdID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DemoRewardVideoAdID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DemoSplashAdID"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self setupAdbidAdSDK];
    return YES;
}
// MARK: - setup lm sdk
- (void)setupAdbidAdSDK {
    
    AdbidSDKConfiguration *configuration = [AdbidSDKConfiguration configuration];
    configuration.appID = [AppConfig appID];
//    configuration.debugMode = YES;
//    configuration.logLevel = AdbidLogLevelDebug;
    AdCustomPermissionController* adP = [[AdCustomPermissionController alloc]init];
    adP.allowLocation = YES;
    configuration.adCustomController = adP;
    NSString* sdkVersion = [AdbidSDKConfiguration sdkVersion];
    NSLog(@"领摩聚合SDK 初始化 version=%@ 时间=%@",sdkVersion,[TimeUtil times][0]);
    [AdbidSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *_Nullable error) {
        if (success) {
            NSLog(@"领摩聚合SDK 初始化成功！时间=%@",[TimeUtil times][0]);
            if ([AppConfig shared].isOpenAppOpenAd) {
                [self loadSplashAd];
            }
            if ([AppConfig shared].isOpenHotAppOpenAd) {
                [[AdbidSplashHotAD shared]loadOrShowSplashHotAD];
            }
           
        } else {
            NSLog(@"领摩聚合SDK 初始化失败！时间=%@",[TimeUtil times][0]);
        }
    }];
   // self.window.rootViewController = [self rootViewController];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestIDFATracking];
    });
}

- (void)requestIDFATracking {
    if (@available(iOS 14, *)) {
        // iOS14及以上版本需要先请求权限
        [ATTrackingManager
            requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                // 获取到权限后，依然使用老方法获取idfa
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                    NSLog(@"[AppDelegate] %@", idfa);
                } else {
                    NSLog(@"[AppDelegate] 请在设置-隐私-跟踪中允许App请求跟踪");
                }
            }];
    } else {
        // iOS14以下版本依然使用老方法
        // 判断在设置-隐私里用户是否打开了广告跟踪
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            NSLog(@"[AppDelegate] %@", idfa);
        } else {
            NSLog(@"[AppDelegate] 请在设置-隐私-广告中打开广告跟踪功能");
        }
    }
}

// MARK: - Splash
- (void)loadSplashAd {
    self.splashAd = [[AdbidSplashAd alloc] initWithSlotId:[AppConfig openID]];
    self.splashAd.viewController = self.window.rootViewController;
    self.splashAd.delegate = self;
    [self.splashAd loadAd];
}
// MARK: - LMSplashAdDelegate
// 广告加载成功
- (void)splashAdDidLoad:(AdbidSplashAd *)splashAd {
    NSLog(@"[AppDelegate] splashAd:didLoadAd: %@", splashAd);
    [self.splashAd showAdToWindow:self.window];
}

// 广告加载失败
- (void)splashAd:(AdbidSplashAd *)splashAd didFailToLoadWithError:(NSError *)error {
    NSLog(@"[AppDelegate] splashAd:didFailToLoadWithError:%ld %@", error.code,error.localizedDescription);
}
// 广告展示成功
- (void)splashAdDidShow:(AdbidSplashAd *)splashAd {
    NSLog(@"[AppDelegate] splashAdDidShow");
}

// 广告展示失败
- (void)splashAd:(AdbidSplashAd *)splashAd didFailToShowWithError:(NSError *)error {
    NSLog(@"[AppDelegate] splashAd:didFailToShowWithError: %@", error);
}

// 广告被点击
- (void)splashAdDidClick:(AdbidSplashAd *)splashAd {
    NSLog(@"[AppDelegate] splashAdDidClick");
}

// 广告被关闭
- (void)splashAdDidClose:(AdbidSplashAd *)splashAd {
    NSLog(@"[AppDelegate] splashAdDidClose");
}

- (void)removeSplashAd {
    if (self.splashAd) {
        self.splashAd = nil;
        self.window.rootViewController = [self rootViewController];
    }
}

- (UIViewController *)rootViewController {
    AdbidHomeViewController *mainViewController = [[AdbidHomeViewController alloc] init];
    UINavigationController *navigationVC =
        [[UINavigationController alloc] initWithRootViewController:mainViewController];
    return navigationVC;
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    self.isEnterForeground = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    if (self.isEnterForeground) {
        if ([AppConfig shared].isOpenHotAppOpenAd) {
            [[AdbidSplashHotAD shared]loadOrShowSplashHotAD];
        }
    }
}

@end
