//
//  AdbidSplashHotAD.h
//  AdbidSDKDemo
//
//  Created by chaizhiyong on 2026/4/10.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AdbidSDK/AdbidSDK.h>
NS_ASSUME_NONNULL_BEGIN

@protocol AdbidSplashHotADDelegate <NSObject>
/// 热启动加载成功
- (void)splashHotAdDidLoad;
/// 热启动加载失败
- (void)splashHotAdLoadFailed:(NSError *)error;
/// 热启动展示成功
- (void)splashHotAdDidShow;
/// 热启动展示失败
- (void)splashHotAdShowFailed:(NSError *)error;
/// 热启动点击
- (void)splashHotAdDidClick;
/// 热启动关闭
- (void)splashHotAdDidClose;
/// 热启动深链接跳转
/// @param success 是否成功
- (void)splashHotAdDeepLinkOrJump:(BOOL)success;
/// 热启动详情页已关闭
- (void)splashHotAdDetailDidClosed;

@end

@interface AdbidSplashHotAD : NSObject

+ (instancetype)shared;
@property (nonatomic, weak) id<AdbidSplashHotADDelegate> delegate;

/// 展示/加载热启动广告
- (void)loadOrShowSplashHotAD;
/// 停止广告（展示前）
- (void)stopSplashHotAD;

@end

NS_ASSUME_NONNULL_END
