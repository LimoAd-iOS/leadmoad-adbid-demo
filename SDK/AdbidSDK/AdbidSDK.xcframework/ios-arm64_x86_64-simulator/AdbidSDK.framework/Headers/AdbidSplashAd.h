//
//  AdbidSplashAd.h
//  AdbidSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <AdbidSDK/AdbidBidLossInfo.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class AdbidSplashAd;
@protocol AdbidSplashAdDelegate <NSObject>
@optional
/// 开屏广告素材加载成功
- (void)splashAdDidLoad:(AdbidSplashAd *)splashAd;
/// 开屏广告加载失败
- (void)splashAd:(AdbidSplashAd *)splashAd didFailToLoadWithError:(NSError *)error;
/// 开屏广告成功展示
- (void)splashAdDidShow:(AdbidSplashAd *)splashAd;
/// 开屏广告展示失败
- (void)splashAd:(AdbidSplashAd *)splashAd didFailToShowWithError:(NSError *)error;
/// 开屏广告点击
- (void)splashAdDidClick:(AdbidSplashAd *)splashAd;
/// 开屏广告关闭
- (void)splashAdDidClose:(AdbidSplashAd *)splashAd;
@end

@interface AdbidSplashAd : NSObject

@property (nonatomic, weak) id<AdbidSplashAdDelegate> delegate;

// 广告最大请求时长，单位毫秒。默认3000 , 最小500毫秒
@property (nonatomic, assign) NSInteger maxLoadTime;

/// 返回广告的eCPM，单位：分
@property (nonatomic, readonly) NSInteger eCPM;

- (instancetype)initWithSlotId:(NSString *)slotId;
/// 发起拉取广告请求
- (void)loadAd;
/*
 * 必须在主线程调用
 */
- (void)showAd:(UIViewController *)viewController;
///  移除SplashView
- (void)removeSplashView;
/// 竞胜/竞败上报
- (void)winNotice:(NSInteger)price;
- (void)lossNotice:(AdbidBidLossInfo *)info;
///是否准备好，准备好了才能加载广告
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
