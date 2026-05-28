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
#import "HMLaunchController.h"

@interface AppDelegate () <AdbidSplashAdDelegate>
@property (nonatomic, strong) AdbidSplashAd *splashAd;
@property (nonatomic, assign) BOOL isEnterForeground;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *keyWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    AdbidTabBarViewController *tabBar = [[AdbidTabBarViewController alloc] init];
    UINavigationController* vc = [[UINavigationController alloc]initWithRootViewController:tabBar];
    
    self.window = keyWindow;
    self.window.rootViewController = vc;
    [keyWindow makeKeyAndVisible];
    
    [self setupAdbidAdSDK];
    return YES;
}
// MARK: - setup lm sdk
- (void)setupAdbidAdSDK {
    AdbidSDKConfiguration *configuration = [AdbidSDKConfiguration configuration];
    configuration.appID = [AppConfig appID];
    AdCustomPermissionController* adP = [[AdCustomPermissionController alloc]init];
    configuration.adCustomController = adP;
    NSString* sdkVersion = [AdbidSDKConfiguration sdkVersion];
    configuration.debugMode = YES;
    configuration.logLevel = AdbidLogLevelWarning;
    NSLog(@"❤️领摩聚合SDK 第一次初始化开始 version=%@ 时间=%@",sdkVersion,[TimeUtil times][0]);
    [AdbidSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *_Nullable error) {
        if (success) {
            NSLog(@"❤️领摩聚合SDK 第一次初始化成功！时间=%@",[TimeUtil times][0]);
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                  [[AdbidSplashHotAD shared]loadOrShowSplashHotAD];
//            });
        } else {
            NSLog(@"❤️领摩聚合SDK 第一次初始化失败！时间=%@",[TimeUtil times][0]);
        }
    }];
    
    NSLog(@"❤️领摩聚合SDK 第二次初始化开始 version=%@ 时间=%@",sdkVersion,[TimeUtil times][0]);
    [AdbidSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *_Nullable error) {
        if (success) {
            NSLog(@"❤️领摩聚合SDK 第二次初始化成功！时间=%@",[TimeUtil times][0]);
            
        } else {
            NSLog(@"❤️领摩聚合SDK 第二次初始化失败！时间=%@",[TimeUtil times][0]);
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"❤️领摩聚合SDK 第三次初始化开始 version=%@ 时间=%@",sdkVersion,[TimeUtil times][0]);
        [AdbidSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *_Nullable error) {
            if (success) {
                NSLog(@"❤️领摩聚合SDK 第三次初始化成功！时间=%@",[TimeUtil times][0]);
                
            } else {
                NSLog(@"❤️领摩聚合SDK 第三次初始化失败！时间=%@",[TimeUtil times][0]);
            }
        }];
    });
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
        UINavigationController *nav = [self getCurrentNavigationController];
        if (nav && ![nav.topViewController isKindOfClass:[HMLaunchController class]]) {
            HMLaunchController *launchVC = [[HMLaunchController alloc] init];
            [nav pushViewController:launchVC animated:NO]; // 无动画 push
        }
    }
}

- (UINavigationController *)getCurrentNavigationController {
    UIViewController *topVC = [self getTopViewController];
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)topVC;
    }
    return topVC.navigationController;
}

// 获取顶层控制器
- (UIViewController *)getTopViewController {
    UIViewController *viewController = self.window.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}

@end
