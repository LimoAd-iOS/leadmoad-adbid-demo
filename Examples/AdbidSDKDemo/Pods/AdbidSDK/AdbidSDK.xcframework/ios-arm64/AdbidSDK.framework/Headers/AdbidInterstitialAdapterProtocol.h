//
//  Header.h
//  AdbidSDK
//
//  Created by chaizhiyong on 2026/1/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AdbidSDK/AdbidBidLossInfo.h>

NS_ASSUME_NONNULL_BEGIN

/// 开屏广告适配层代理（回调给AdbidSplashAd）
@protocol AdbidInterstitialAdapterDelegate <NSObject>
@optional
/// 素材加载成功 extra 扩展数据
- (void)adapterDidLoadInterstitialAd:(id)adapter extra:(NSDictionary*)extra;
/// 加载失败
- (void)adapter:(id)adapter didFailToLoadInterstitialAdWithError:(NSError *)error;
/// 展示成功
- (void)adapterDidShowInterstitialAd:(id)adapter;
/// 展示失败
- (void)adapter:(id)adapter didFailToShowInterstitialAdWithError:(NSError *)error;
/// 广告点击
- (void)adapterDidClickInterstitialAd:(id)adapter;
/// 广告关闭
- (void)adapterDidCloseInterstitialAd:(id)adapter;
/// 广告完成转化(关闭落地页)
- (void)adapterDidFinishConversion:(id)adapter interactionType:(int)interactionType;

@end

/// 开屏广告适配层抽象协议
@protocol AdbidInterstitialAdapterProtocol <NSObject>

/// 适配层代理（回调至AdbidSplashAd）
@property (nonatomic, weak) id<AdbidInterstitialAdapterDelegate> adapterDelegate;
/// 广告最大加载时长（毫秒）
@property (nonatomic, assign) NSInteger maxLoadTime;
/// 广告eCPM（分）
@property (nonatomic, readonly) NSInteger eCPM;
@property (nonatomic, assign) BOOL shouldMuted;///是否静音，默认 NO（非静音）
/// 广告位ID（不同广告商的ID，如穿山甲的slotID、广点通的placementID）
@property (nonatomic, copy, readonly) NSString *slotId;
@property (nonatomic, copy, readonly) NSString* currentRequestId;
/// 落地页控制器。由聚合层在展示时传入，适配器不保留。
@property (nonatomic, weak, nullable) UIViewController *viewController;

- (instancetype)initWithSlotId:(NSString *)slotId requestId:(NSString*)requestId;
/// 加载广告
- (void)loadAd;

/// 展示广告（主线程调用）
- (void)showAd:(UIViewController *)viewController;

/// 移除广告视图
- (void)removeInterstitialView;

/// 竞胜上报
- (void)winNotice:(NSInteger)price;

/// 竞败上报
- (void)lossNotice:(AdbidBidLossInfo *)info;

@optional
/// 通过 bidding token 加载。旧版 adapter 可不实现，聚合层会回落到 loadAd。
- (void)loadAdWithToken:(NSString *)token;

//是否可以显示
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
