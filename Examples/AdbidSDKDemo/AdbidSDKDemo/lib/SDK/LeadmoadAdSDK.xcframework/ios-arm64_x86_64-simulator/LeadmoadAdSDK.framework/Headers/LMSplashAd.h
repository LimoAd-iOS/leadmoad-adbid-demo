//
//  LMSplashAd.h
//  LeadmoadAdSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <LeadmoadAdSDK/LMAdBidLossInfo.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class LMSplashAd;
@protocol LMSplashAdDelegate <NSObject>
@optional
/// 开屏广告素材加载成功
- (void)splashAdDidLoad:(LMSplashAd *)splashAd;
/// 开屏广告加载失败
- (void)splashAd:(LMSplashAd *)splashAd didFailToLoadWithError:(NSError *)error;
/// 开屏广告成功展示
- (void)splashAdDidShow:(LMSplashAd *)splashAd;
/// 开屏广告展示失败
- (void)splashAd:(LMSplashAd *)splashAd didFailToShowWithError:(NSError *)error;
/// 开屏广告点击
- (void)splashAdDidClick:(LMSplashAd *)splashAd;
/// 开屏广告关闭
- (void)splashAdDidClose:(LMSplashAd *)splashAd;
@end

@interface LMSplashAd : NSObject

@property (nonatomic, weak) id<LMSplashAdDelegate> delegate;

// 广告最大请求时长，单位毫秒。默认5000 , 最小500毫秒
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
- (void)lossNotice:(LMAdBidLossInfo *)info;

@end

NS_ASSUME_NONNULL_END
