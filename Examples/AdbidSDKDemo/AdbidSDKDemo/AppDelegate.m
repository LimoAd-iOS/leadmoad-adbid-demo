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
#import <AdbidSDK/AdbidSDKConfiguration.h>

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
    configuration.userId = @"111111";
    configuration.IDFA = @"";
    NSString* sdkVersion = [AdbidSDKConfiguration sdkVersion];
    configuration.debugMode = YES;
    
    AdCustomPermissionController* adP = [[AdCustomPermissionController alloc]init];
    adP.allowLocation = YES;
    configuration.adCustomController = adP;
    configuration.age = 12;
    configuration.gender = AdbidUserGenderMale;
    [AdbidSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *_Nullable error) {
        if (success) {
             
        } else {
  
        }
    }];
    self.window.rootViewController = [self rootViewController];
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
    self.splashAd = [[AdbidSplashAd alloc] initWithSlotId:@"100080101000001"];
    self.splashAd.delegate = self;
    [self.splashAd loadAd];
}
// MARK: - LMSplashAdDelegate
// 广告加载成功
- (void)splashAdDidLoad:(AdbidSplashAd *)splashAd {
    NSLog(@"[AppDelegate] splashAd:didLoadAd: %@", splashAd);
    self.window.rootViewController = [self rootViewController];
    [self.splashAd showAdToWindow:self.window];
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
