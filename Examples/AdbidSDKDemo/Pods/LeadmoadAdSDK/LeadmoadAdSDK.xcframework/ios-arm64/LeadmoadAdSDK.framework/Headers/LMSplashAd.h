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

typedef NS_ENUM(NSInteger, LMSplashAdLandingPageType) {
    LMSplashAdLandingPageType_Unknow          = 0, // 未知
    LMSplashAdLandingPageType_lp    = 1, // 落地页（html/h5）
    LMSplashAdLandingPageType_Deeplink      = 2, // deep 类型广告落地页
    LMSplashAdLandingPageType_AppDownload    = 3, // 下载类广告（app下载页）
    LMSplashAdLandingPageType_WeChat          = 4, // 微信小程序/小游戏
    LMSplashAdLandingPageType_UniversalLink   = 5, // UniversalLink 唤起
    LMSplashAdLandingPageType_AppStore        = 6, // ios应用商店下载
};

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
///跳到站外边
- (void)splashAdDidJumpToAppOutside:(LMSplashAd *)splashAd interactionType:(LMSplashAdLandingPageType)interactionType;

@end

@interface LMSplashAd : NSObject

@property (nonatomic, weak) id<LMSplashAdDelegate> delegate;

// 广告最大请求时长，单位毫秒。默认5000 , 最小500毫秒
@property (nonatomic, assign) NSInteger maxLoadTime;

//是否可以展示
@property (nonatomic, assign, readonly, getter=isAdValid) BOOL valid;

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
