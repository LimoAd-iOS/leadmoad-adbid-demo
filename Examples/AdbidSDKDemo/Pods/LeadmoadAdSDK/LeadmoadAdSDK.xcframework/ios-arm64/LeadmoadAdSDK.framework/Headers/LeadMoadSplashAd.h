//
//  LeadMoadSplashAd.h
//  LeadmoadAdSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <LeadmoadAdSDK/LeadMoadAdBidLossInfo.h>
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

@class LeadMoadSplashAd;
@protocol LeadMoadSplashAdDelegate <NSObject>
@optional
/// 开屏广告素材加载成功
- (void)splashAdDidLoad:(LeadMoadSplashAd *)splashAd;
/// 开屏广告加载失败
- (void)splashAd:(LeadMoadSplashAd *)splashAd didFailToLoadWithError:(NSError *)error;
/// 开屏广告成功展示
- (void)splashAdDidShow:(LeadMoadSplashAd *)splashAd;
/// 开屏广告展示失败
- (void)splashAd:(LeadMoadSplashAd *)splashAd didFailToShowWithError:(NSError *)error;
/// 开屏广告点击
- (void)splashAdDidClick:(LeadMoadSplashAd *)splashAd;
/// 开屏广告关闭
- (void)splashAdDidClose:(LeadMoadSplashAd *)splashAd;
///跳到站外边
- (void)splashAdDidJumpToAppOutside:(LeadMoadSplashAd *)splashAd interactionType:(LMSplashAdLandingPageType)interactionType;

@end

@interface LeadMoadSplashAd : NSObject

@property (nonatomic, weak) id<LeadMoadSplashAdDelegate> delegate;

// 广告最大请求时长，单位毫秒。默认5000 , 最小500毫秒
@property (nonatomic, assign) NSInteger maxLoadTime;

//是否可以展示
@property (nonatomic, assign, readonly, getter=isAdValid) BOOL valid;

/// 返回广告的eCPM，单位：分
@property (nonatomic, readonly) NSInteger eCPM;

/// 竞价素材信息，字段对齐聚合 material：appName/appPackageName/url/title/desc/jump_url/logo/ imageUrl videoUrl landingPageUrl
@property (nonatomic, copy, readonly, nullable) NSDictionary *material;

@property (nonatomic, strong, nullable) UIViewController *baseViewController;// 落地页设置
/// 开屏底部品牌条。须在 showAdToWindow: 之前设置。非空时底部展示该视图，为空则全屏。
@property (nonatomic, strong, nullable) UIView *bottomView;

- (instancetype)initWithSlotId:(NSString *)slotId;

- (instancetype)initWithSlotId:(NSString *)slotId requestId:(NSString*)requestId;
    
/// 发起拉取广告请求
- (void)loadAd;
/// 通过token发起拉取广告请求
- (void)loadAdWithToken:(NSString*)token;
    
/*
 * 必须在主线程调用
 */
- (void)showAdToWindow:(UIWindow *)window;

/**
 * 展示开屏，并可附带底部品牌条。
 * @param window 展示窗口
 * @param bottomView 品牌条视图；传非空时，底部高度取该 view 的 frame/bounds 高度，上方留给广告。传 nil 则全屏展示，等同 showAdToWindow:
 */
- (void)showAdToWindow:(UIWindow *)window bottomView:(nullable UIView *)bottomView;

/// 竞胜/竞败上报
- (void)winNotice:(NSInteger)price;
- (void)lossNotice:(LeadMoadAdBidLossInfo *)info;

@end

NS_ASSUME_NONNULL_END
