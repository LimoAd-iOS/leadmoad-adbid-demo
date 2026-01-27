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
#import "ViewController.h"
#import "GDTAction+convenience.h"
#import "GDTAction.h"
@interface AppDelegate () <AdbidSplashAdDelegate>
@property (nonatomic, strong) AdbidSplashAd *splashAd;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *keyWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [keyWindow makeKeyAndVisible];
    self.window = keyWindow;
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    UIViewController *launchScreenViewController = [s instantiateInitialViewController];
    launchScreenViewController.view.frame = self.window.bounds;

    self.window.rootViewController = launchScreenViewController;

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
    configuration.appID = @"10004";
    configuration.debugMode = YES;
    
    AdCustomPermissionController* adP = [[AdCustomPermissionController alloc]init];
    adP.allowLocation = YES;
    configuration.adCustomController = adP;
    configuration.age = 12;
    configuration.gender = AdbidUserGenderMale;
    
    //configuration.logLevel = LMAdLogLevelDebug;
    NSDictionary *caidDict = [self saveCaidToUserDefaults];
    [AdbidSDKManager setExtraUserData:caidDict];
    NSLog(@"[AppDelegate] setupLMAdSDK");

    [AdbidSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *_Nullable error) {
        if (success) {
//            [self loadSplashAd];
        } else {
//            self.window.rootViewController = [self rootViewController];
        }
    }];
    self.window.rootViewController = [self rootViewController];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestIDFATracking];
    });
}

- (NSDictionary *)saveCaidToUserDefaults {
    // 检查是否已保存CAID
    NSDictionary *savedCaidDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"LMNativeDemoCaidsKey"];
    if (savedCaidDict && savedCaidDict.count > 0) {
        return savedCaidDict;
    }
    NSLog(@"[AppDelegate] saveCaidToUserDefaults");
    [GDTAction init:@"1209177436" secretKey:@"e22062d669e375ab459382163dbb34ee"];
    [GDTAction start];
    NSDictionary *caids = [GDTAction getCaid];
    // 结构[{"caid":"b0549fa553a4ea1da50c09c2069ebeda","version":"20250325"},{"caid":"712e8e31d2c13a37dec327341353b280","version":"20230330"}]
    NSArray *caidArray = caids[@"data"];
    NSDictionary *lastCaid = caidArray.lastObject;
    NSString *caid = lastCaid[@"value"];
    NSString *version = lastCaid[@"version"];
    NSLog(@"[AppDelegate] caidArray: %@", caidArray);
    NSDictionary *caidDict = @{@"caid_value": caid, @"caid_version": version};
    [[NSUserDefaults standardUserDefaults] setObject:caidDict forKey:@"LMNativeDemoCaidsKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return caidDict;
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
    self.splashAd = [[AdbidSplashAd alloc] initWithSlotId:@"100080101000001"];
    self.splashAd.delegate = self;
    [self.splashAd loadAd];
}
// MARK: - LMSplashAdDelegate
// 广告加载成功
- (void)splashAdDidLoad:(AdbidSplashAd *)splashAd {
    NSLog(@"[AppDelegate] splashAd:didLoadAd: %@", splashAd);
    self.window.rootViewController = [self rootViewController];
    [self.splashAd showAd:self.window.rootViewController];
}

// 广告加载失败
- (void)splashAd:(AdbidSplashAd *)splashAd didFailToLoadWithError:(NSError *)error {
    NSLog(@"[AppDelegate] splashAd:didFailToLoadWithError: %@", error);
    self.window.rootViewController = [self rootViewController];
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
        [self.splashAd removeSplashView];
        self.splashAd = nil;
        self.window.rootViewController = [self rootViewController];
    }
}

- (UIViewController *)rootViewController {
    ViewController *mainViewController = [[ViewController alloc] init];
    UINavigationController *navigationVC =
        [[UINavigationController alloc] initWithRootViewController:mainViewController];
    return navigationVC;
}

@end
