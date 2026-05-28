//
//  LMNativeAd.h
//  LeadmoadAdSDK
//
//  Created by youzhadoubao on 2025/9/25.
//

#import <Foundation/Foundation.h>
#import <AdbidSDK/adbidNativeObj.h>
#import <UIKit/UIKit.h>
#import <AdbidSDK/AdbidBidLossInfo.h>
#import <AdbidSDK/AdbidAdInfoModel.h>
NS_ASSUME_NONNULL_BEGIN

@class AdbidNativeAd;
@class AdbidNativeMediaView;

@protocol AdbidNativeAdDelegate <NSObject>
/// 广告加载成功
- (void)nativeAdDidLoad:(AdbidNativeAd *)nativeAd;
/// 广告加载失败
- (void)nativeAd:(AdbidNativeAd *)nativeAd didFailToLoadWithError:(NSError *)error;

@optional

/**
 当自渲染广告被点击时调用
 */
- (void)nativeAdViewDidClick:(AdbidNativeAd *)nativeAd;

/**
 广告曝光回调
 */
- (void)nativeAdViewDidExpose:(AdbidNativeAd *)nativeAd;

@end

@interface AdbidNativeAd : NSObject

/**
 广告素材
 */
@property (atomic, strong, readonly, nullable) AdbidNativeObj *data;

/// 广告对象，在nativeAdViewDidClick回调后有值
@property (nonatomic, weak) id<AdbidNativeAdDelegate> delegate;
/**
 必传.
 处理广告点击事件的根视图控制器。
 */
@property (nonatomic, weak, readwrite) UIViewController *rootViewController;

@property (nonatomic, assign) BOOL shouldMuted; //设置静音

/// SDK 内部使用：由 AdbidNativeView 在 refreshData 时绑定，曝光回调到达后由 SDK 触发播放
@property (nonatomic, weak) AdbidNativeMediaView *mediaView;
/**
 *  广告最大请求时长，单位毫秒。默认3000 , 最小500毫秒
 */
@property (nonatomic, assign) NSInteger maxLoadTime;

@property (nonatomic, assign, readonly) NSInteger eCPM;

// 广告信息
@property (nonatomic, readonly) AdbidAdInfoModel* adInfo;

- (instancetype)initWithSlotId:(NSString *)slotId;

/**
 * 加载信息流广告
 */
- (void)loadAd;
/**
 * 通过Token加载信息流广告
 */
- (void)loadAdWithToken:(NSString *)token;
/**
 带额外配置的渲染（模版广告通过 extraConfig 透传 ADFrame / mediaViewFrame /
 sizeToFit / adLogoFrame / adOptionsFrame / networkLogoFrame / videoPlayType）
 自渲染时 extraConfig 可为 nil，行为等同 3 参重载

 extraConfig 已知 key：
   - adFrame           NSValue<CGRect>   ATNativeADConfiguration.ADFrame
   - mediaViewFrame    NSValue<CGRect>   ATNativeADConfiguration.mediaViewFrame
   - sizeToFit         NSNumber<BOOL>    ATNativeADConfiguration.sizeToFit
   - adLogoFrame       NSValue<CGRect>   context kATNativeAdConfigurationContextAdLogoViewFrameKey
   - adOptionsFrame    NSValue<CGRect>   context kATNativeAdConfigurationContextAdOptionsViewFrameKey
   - networkLogoFrame  NSValue<CGRect>   context kATNativeAdConfigurationContextNetworkLogoViewFrameKey
   - videoPlayType     NSNumber<NSInt>   ATNativeADConfiguration.videoPlayType
 */
- (void)registerContainer:(__kindof UIView *)containerView
            mainImageView:(__kindof UIImageView *)mainImageView
       withClickableViews:(NSArray<__kindof UIView *> *_Nullable)clickableViews
              extraConfig:(nullable NSDictionary *)extraConfig;
/**
 注册点击事件
 @param containerView 原生广告的容器视图。必传
 @param mainImageView 原生广告的大图容器
 @param clickableViews 可点击的视图数组。可选
 */
- (void)registerContainer:(__kindof UIView *)containerView mainImageView:(__kindof UIImageView *) mainImageView
       withClickableViews:(NSArray<__kindof UIView *> *_Nullable)clickableViews;
/// price 二价（即竞败方最高价）
- (void)winNotice:(NSInteger)price;
/// info 竞胜方平台  竞胜方最高价
- (void)lossNotice:(AdbidBidLossInfo *)info;

///是否准备好，准备好了才能加载广告
- (BOOL)isReady;
@end

NS_ASSUME_NONNULL_END
