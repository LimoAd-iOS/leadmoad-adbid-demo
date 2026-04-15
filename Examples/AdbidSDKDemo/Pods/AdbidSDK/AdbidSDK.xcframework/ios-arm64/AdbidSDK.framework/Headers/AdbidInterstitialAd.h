//
//  AdbidInterstitialAd.h
//  AdbidSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <AdbidSDK/AdbidBidLossInfo.h>
#import <AdbidSDK/AdbidPublicDefine.h>
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

// 广告最大请求时长，单位毫秒。默认3000 , 最小500毫秒
@property (nonatomic, assign) NSInteger maxLoadTime;

/// 是否静音，默认是静音
@property (nonatomic, assign) BOOL shouldMuted;

/// 返回广告的eCPM，单位：分
@property (nonatomic, readonly) NSInteger eCPM;

- (instancetype)initWithSlotId:(NSString *)slotId;
/// 发起拉取广告请求
- (void)loadAd;
/*
 * 必须在主线程调用
 */
- (void)showAd:(UIViewController *)viewController;
/// 竞胜/竞败上报
- (void)winNotice:(NSInteger)price;
- (void)lossNotice:(AdbidBidLossInfo *)info;
///是否准备好，准备好了才能加载广告
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
