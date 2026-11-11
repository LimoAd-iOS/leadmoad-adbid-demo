//
//  AdbidInterstitialAd.h
//  AdbidSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <AdbidSDK/AdbidBidLossInfo.h>
#import <AdbidSDK/AdbidPublicDefine.h>
#import <AdbidSDK/AdbidAdInfoModel.h>
#import <AdbidSDK/AdbidMaterialModel.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class AdbidInterstitialAd;
@protocol AdbidInterstitialAdDelegate <NSObject>
@optional
/// 广告请求成功
- (void)interstitialAdDidLoad:(AdbidInterstitialAd *)interstitialAd;
/// 广告请求失败
- (void)interstitialAdFailedToLoad:(AdbidInterstitialAd *)interstitialAd withError:(NSError *)error;
/// 开屏广告成功展示
- (void)interstitialAdDidShow:(AdbidInterstitialAd *)interstitialAd;
/// 开屏广告展示失败
- (void)interstitialAdFailedToShow:(AdbidInterstitialAd *)interstitialAd  withError:(NSError *)error;
/// 开屏广告点击
- (void)interstitialAdDidClick:(AdbidInterstitialAd *)interstitialAd;
/// 开屏广告关闭
- (void)interstitialAdDidClose:(AdbidInterstitialAd *)interstitialAd;
/// 广告完成转化(关闭落地页)
- (void)interstitialAdDidFinishConversion:(AdbidInterstitialAd *)interstitialAd interactionType:(AdbidAdRedirectionType)interactionType;

@end

@interface AdbidInterstitialAd : NSObject

@property (nonatomic, weak) id<AdbidInterstitialAdDelegate> delegate;

/// 落地页控制器。由调用方持有，SDK 不保留，避免和页面互相持有。
@property (nonatomic, weak, nullable) UIViewController *viewController;
/// 返回广告的eCPM，单位：分
@property (nonatomic, readonly) NSInteger eCPM;
// 广告信息
@property (nonatomic, readonly) AdbidAdInfoModel* adInfo;
/// 广告素材。选出赢家后才赋值，字典和模型来自同一个渠道。
@property (nonatomic, copy, readonly, nullable) NSDictionary *material;
/// 广告素材模型。和 material 来自同一个赢家。
@property (nonatomic, strong, readonly, nullable) AdbidMaterialModel *materialModel;


- (instancetype)initWithSlotId:(NSString *)slotId;

- (NSString*)getRequestId;

/// 发起拉取广告请求
- (void)loadAd;
/**
 * 通过Token加载信息流广告
 */
- (void)loadAdWithToken:(NSString *)token;
/// 已在主线程则直接展示；非主线程会切到主线程再展示。
- (void)showAd:(UIViewController *)viewController;
/// price 二价（即竞败方最高价）
- (void)winNotice:(NSInteger)price;
/// info 竞胜方平台  竞胜方最高价
- (void)lossNotice:(AdbidBidLossInfo *)info;
///是否准备好，准备好了才能加载广告
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
