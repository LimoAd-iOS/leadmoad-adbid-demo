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
#import "TimeUtil.h"
#import "AdbidTabBarViewController.h"
#import "AppConfig.h"
#import "AdbidSplashHotAD.h"
#import "HMLaunchController.h"
#import "AdbidSplashTokenTester.h"

@interface AppDelegate () <AdbidSplashAdDelegate>
@property (nonatomic, strong) AdbidSplashAd *splashAd;
@property (nonatomic, assign) BOOL isEnterForeground;
@property (nonatomic, strong) AdbidSplashAd *startupTestSplashAd;
@property (nonatomic, strong) AdbidSplashTokenTester *startupTokenTester;
@end

@implementation AppDelegate

- (void)performOnMainThread:(dispatch_block_t)block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestTrackingPermission];
    });
    UIWindow *keyWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    AdbidTabBarViewController *tabBar = [[AdbidTabBarViewController alloc] init];
    self.window = keyWindow;
    self.window.rootViewController = tabBar;
    [keyWindow makeKeyAndVisible];
    [self setupAdbidAdSDK];
    
  
    return YES;
}

- (void)requestTrackingPermission {
    if (@available(iOS 14, *)) {
        // 检查当前授权状态
        ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];
        NSLog(@"Current ATTrackingManager status: %lu", (unsigned long)status);

        if (status == ATTrackingManagerAuthorizationStatusNotDetermined) {
            // 只有在未确定状态时才请求权限
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"ATTrackingManager status after request: %lu", (unsigned long)status);
                });
            }];
        } else {
            // 已经有授权状态，直接初始化SDK
            NSLog(@"ATTrackingManager already determined, status: %lu", (unsigned long)status);
            
        }
    } else {
        // iOS 14以下版本直接初始化SDK
        NSLog(@"iOS version < 14, initializing SDK directly");
         
    }
}

// MARK: - setup lm sdk
- (void)setupAdbidAdSDK {
    
    AdbidSDKConfiguration *configuration = [AdbidSDKConfiguration configuration];
    configuration.appID = [AppConfig appID];
    configuration.debugMode = YES;
    configuration.logLevel = AdbidLogLevelInfo;
    AdCustomPermissionController* adP = [[AdCustomPermissionController alloc]init];
    configuration.adCustomController = adP;
    NSString* sdkVersion = [AdbidSDKConfiguration sdkVersion];
    NSTimeInterval initStartTime = [[NSDate date] timeIntervalSince1970];
   
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval taskStartTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval mainTaskWaitCost = (taskStartTime - initStartTime) * 1000.0;
        NSTimeInterval mockMainThreadTaskDuration = 2.0;
        NSLog(@"领摩聚合SDK 初始化主线程耗时任务开始，等待耗时=%.2fms 模拟耗时=%.2fs 时间=%@ 当前线程=%@",
              mainTaskWaitCost,
              mockMainThreadTaskDuration,
              [TimeUtil times][0],
              [NSThread isMainThread] ? @"主线程" : @"子线程");
        [NSThread sleepForTimeInterval:mockMainThreadTaskDuration];
        NSTimeInterval taskExecuteCost = ([[NSDate date] timeIntervalSince1970] - taskStartTime) * 1000.0;
        NSLog(@"领摩聚合SDK 初始化主线程耗时任务结束，执行耗时=%.2fms 时间=%@ 当前线程=%@",
              taskExecuteCost,
              [TimeUtil times][0],
              [NSThread isMainThread] ? @"主线程" : @"子线程");
    });
    NSLog(@"领摩聚合SDK 初始化开始 version=%@ 时间=%@",sdkVersion,[TimeUtil times][0]);
    [AdbidSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *_Nullable error) {
        NSTimeInterval initCost = ([[NSDate date] timeIntervalSince1970] - initStartTime) * 1000.0;
        BOOL callbackOnMainThread = [NSThread isMainThread];
        NSLog(@"AdbidSDK 初始化回调 isMainThread=%@ 时间=%@ 当前线程=%@",
              callbackOnMainThread ? @"YES" : @"NO",
              [TimeUtil times][0],
              [NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSLog(@"领摩聚合SDK 初始化成功第一次！耗时=%.2fms 时间=%@ 原始回调isMainThread=%@",
                      initCost,
                      [TimeUtil times][0],
                      callbackOnMainThread ? @"YES" : @"NO");
               //  [self triggerServerBidTokenConfigCostTestAfterInitialization];
            } else {
                NSLog(@"领摩聚合SDK 初始化失败第一次！耗时=%.2fms 时间=%@ error=%@ 原始回调isMainThread=%@",
                      initCost,
                      [TimeUtil times][0],
                      error.localizedDescription ?: @"",
                      callbackOnMainThread ? @"YES" : @"NO");
            }
        });
    }];
}

// MARK: - Splash
- (void)triggerServerBidTokenConfigCostTestAfterInitialization {
    NSString *slotId = [AppConfig openID];
    if (slotId.length == 0) {
        NSLog(@"初始化成功后跳过 requestServerBidTokenConfigBeforeLoadForSplashAd 测试: slotId 为空");
        return;
    }
    if (!self.startupTokenTester) {
        self.startupTokenTester = [[AdbidSplashTokenTester alloc] init];
    }
    self.startupTestSplashAd = [[AdbidSplashAd alloc] initWithSlotId:slotId];
    NSLog(@"初始化成功后开始调用 requestServerBidTokenConfigBeforeLoadForSplashAd 测试，slotId=%@ 时间=%@",
          slotId,
          [TimeUtil times][0]);
    [self requestServerBidTokenConfigBeforeLoadForSplashAd:self.startupTestSplashAd slotId:slotId];
}

- (void)requestServerBidTokenConfigBeforeLoadForSplashAd:(AdbidSplashAd *)splashAd slotId:(NSString *)slotId {
    __weak typeof(self) weakSelf = self;
    CFAbsoluteTime methodStartTime = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime requestStartTime = CFAbsoluteTimeGetCurrent();
    
//    [AdbidSDKManager requestServerBidTokenConfigForPositionId:slotId completion:^(NSString * _Nullable sdkInfoConfig, NSError * _Nullable configError) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        if (!strongSelf) {
//            return;
//        }
//        NSTimeInterval elapsedTime = (CFAbsoluteTimeGetCurrent() - requestStartTime) * 1000.0;
//        NSString *costLog = [NSString stringWithFormat:@"AppDelegate requestServerBidTokenConfigForPositionId 耗时: %.2f ms, slotId=%@, %@", elapsedTime, slotId ?: @"", configError ? [NSString stringWithFormat:@"error=%@", configError.localizedDescription ?: @"unknown"] : @"success"];
//        NSLog(@"%@", costLog);
//        [strongSelf.startupTokenTester getTokenWithAdId:slotId sdkInfo:sdkInfoConfig completion:^(BOOL success, NSDictionary * _Nullable config, NSError * _Nullable error) {
//            NSTimeInterval methodElapsedTime = (CFAbsoluteTimeGetCurrent() - methodStartTime) * 1000.0;
//            NSString *methodCostLog = [NSString stringWithFormat:@"AppDelegate requestServerBidTokenConfigBeforeLoadForSplashAd 总耗时: %.2f ms, slotId=%@, %@", methodElapsedTime, slotId ?: @"", error ? [NSString stringWithFormat:@"error=%@", error.localizedDescription ?: @"unknown"] : @"success"];
//            NSLog(@"%@", methodCostLog);
//            if (strongSelf.startupTestSplashAd == splashAd) {
//                NSString *token = [config objectForKey:@"token"];
//                [splashAd loadAdWithToken:token];
//            }
//        }];
//    }];
}

- (void)loadSplashAd {
    self.splashAd = [[AdbidSplashAd alloc] initWithSlotId:[AppConfig openID]];
    self.splashAd.viewController = self.window.rootViewController;
    self.splashAd.delegate = self;
    [self.splashAd loadAd];
}
// MARK: - LMSplashAdDelegate
// 广告加载成功
- (void)splashAdDidLoad:(AdbidSplashAd *)splashAd {
    BOOL callbackOnMainThread = [NSThread isMainThread];
    NSLog(@"冷启动开屏广告加载成功回调 isMainThread=%@ 时间=%@ 当前线程=%@",
          callbackOnMainThread ? @"YES" : @"NO",
          [TimeUtil times][0],
          [NSThread currentThread]);
    [self performOnMainThread:^{
        [self.splashAd showAdToWindow:self.window];
    }];
}

// 广告加载失败
- (void)splashAd:(AdbidSplashAd *)splashAd didFailToLoadWithError:(NSError *)error {
}
// 广告展示成功
- (void)splashAdDidShow:(AdbidSplashAd *)splashAd {
}

// 广告展示失败
- (void)splashAd:(AdbidSplashAd *)splashAd didFailToShowWithError:(NSError *)error {
}

// 广告被点击
- (void)splashAdDidClick:(AdbidSplashAd *)splashAd {
}

// 广告被关闭
- (void)splashAdDidClose:(AdbidSplashAd *)splashAd {
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
        UINavigationController *nav = [self getCurrentNavigationController];
        // 判断能不能 push
//        if (nav && ![nav.topViewController isKindOfClass:[HMLaunchController class]]) {
//            HMLaunchController *launchVC = [[HMLaunchController alloc] init];
//            [nav pushViewController:launchVC animated:NO]; // 无动画 push
//        }
        
       // if ([AppConfig shared].isOpenHotAppOpenAd) {
          //  [[AdbidSplashHotAD shared]loadOrShowSplashHotAD];
     //   }
    }
}

// 获取当前显示的导航（通用、稳定）
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
