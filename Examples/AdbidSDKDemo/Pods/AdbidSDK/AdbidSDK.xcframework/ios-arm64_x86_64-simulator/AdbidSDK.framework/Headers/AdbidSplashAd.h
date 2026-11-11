//
//  AdbidSplashAd.h
//  AdbidSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <AdbidSDK/AdbidBidLossInfo.h>
#import <AdbidSDK/AdbidAdInfoModel.h>
#import <AdbidSDK/AdbidMaterialModel.h>

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
/// 广告完成转化(关闭落地页)
- (void)splashAdDidFinishConversion:(AdbidSplashAd *)splashAd interactionType:(AdbidAdRedirectionType)interactionType;

@end

@interface AdbidSplashAd : NSObject

@property (nonatomic, weak) id<AdbidSplashAdDelegate> delegate;

// 返回广告的eCPM，单位：分
@property (nonatomic, readonly) NSInteger eCPM;
// 广告信息
@property (nonatomic, readonly) AdbidAdInfoModel* adInfo;
// 广告素材(兼容旧版本)
@property (nonatomic, copy, readonly) NSDictionary *material;
// 广告素材模型
@property (nonatomic, strong, readonly, nullable) AdbidMaterialModel *materialModel;
/// 落地页控制器。由调用方持有，SDK 不保留，避免和页面互相持有。
@property (nonatomic, weak, nullable) UIViewController *viewController;
/// 开屏底部品牌条。须在 loadAd 之前设置。非空时渠道按半屏展示；为空时全屏展示。
@property (nonatomic, strong, nullable) UIView *bottomView;

- (instancetype)initWithSlotId:(NSString *)slotId;

- (NSString*)getRequestId;

/// 发起拉取广告请求
- (void)loadAd;
/// 通过Token发起拉取广告请求
- (void)loadAdWithToken:(NSString *)token;
/// 已在主线程则直接展示；非主线程会切到主线程再展示。
- (void)showAdToWindow:(UIWindow *)window;
/// 即将失效。请在 loadAd 之前设置 bottomView，再调用 showAdToWindow:。
- (void)showAdToWindow:(UIWindow *)window bottomView:(UIView *)bottomView __attribute__((deprecated("即将失效，请在 loadAd 之前设置 bottomView，再调用 showAdToWindow:")));
/// price 二价（即竞败方最高价）
- (void)winNotice:(NSInteger)price;
/// info 竞胜方平台  竞胜方最高价
- (void)lossNotice:(AdbidBidLossInfo *)info;
///是否准备好，准备好了才能加载广告
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
