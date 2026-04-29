//
//  LMInterstitialAd.h
//  LeadmoadAdSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <LeadmoadAdSDK/LMAdBidLossInfo.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LMInterstitialAdLandingPageType) {
    LMInterstitialAdLandingPageType_Unknow          = 0, // 未知
    LMInterstitialAdLandingPageType_lp    = 1, // 落地页（html/h5）
    LMInterstitialAdLandingPageType_Deeplink      = 2, // deep 类型广告落地页
    LMInterstitialAdLandingPageType_AppDownload    = 3, // 下载类广告（app下载页）
    LMInterstitialAdLandingPageType_WeChat          = 4, // 微信小程序/小游戏
    LMInterstitialAdLandingPageType_UniversalLink   = 5, // UniversalLink 唤起
    LMInterstitialAdLandingPageType_AppStore        = 6, // ios应用商店下载
};

@class LMInterstitialAd;
@protocol LMInterstitialAdDelegate <NSObject>
@optional
/// 开屏广告素材加载成功
- (void)interstitialAdDidLoad:(LMInterstitialAd *)InterstitialAd;
/// 开屏广告加载失败
- (void)interstitialAd:(LMInterstitialAd *)InterstitialAd didFailToLoadWithError:(NSError *)error;
/// 开屏广告成功展示
- (void)interstitialAdDidShow:(LMInterstitialAd *)InterstitialAd;
/// 开屏广告展示失败
- (void)interstitialAd:(LMInterstitialAd *)InterstitialAd didFailToShowWithError:(NSError *)error;
/// 开屏广告点击
- (void)interstitialAdDidClick:(LMInterstitialAd *)InterstitialAd;
/// 开屏广告关闭
- (void)interstitialAdDidClose:(LMInterstitialAd *)InterstitialAd;
///跳到站外边
- (void)interstitialAdDidJumpToAppOutside:(LMInterstitialAd *)InterstitialAd interactionType:(LMInterstitialAdLandingPageType)interactionType;

@end

@interface LMInterstitialAd : NSObject

@property (nonatomic, weak) id<LMInterstitialAdDelegate> delegate;

// 广告最大请求时长，单位毫秒。默认5000 , 最小500毫秒
@property (nonatomic, assign) NSInteger maxLoadTime;

//是否可以展示
@property (nonatomic, assign, readonly, getter=isAdValid) BOOL valid;

/// 返回广告的eCPM，单位：分
@property (nonatomic, readonly) NSInteger eCPM;

- (instancetype)initWithSlotId:(NSString *)slotId;

- (instancetype)initWithSlotId:(NSString *)slotId requestId:(NSString*)requestId;

/// 发起拉取广告请求
- (void)loadAd;

/*
 * 必须在主线程调用
 */
- (void)showAd:(UIViewController *)viewController;
/// 竞胜/竞败上报
- (void)winNotice:(NSInteger)price;
- (void)lossNotice:(LMAdBidLossInfo *)info;

@end

NS_ASSUME_NONNULL_END
