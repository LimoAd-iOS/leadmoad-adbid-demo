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
@protocol AdbidRewardVideoAdapterDelegate <NSObject>
@optional
/// 素材加载成功
- (void)adapterDidLoadRewardVideoAd:(id)adapter;
/// 加载失败
- (void)adapter:(id)adapter didFailToLoadRewardVideoAdWithError:(NSError *)error;
/// 展示成功
- (void)adapterDidShowRewardVideoAd:(id)adapter;
/// 展示失败
- (void)adapter:(id)adapter didFailToShowRewardVideoAdWithError:(NSError *)error;
/// 广告点击
- (void)adapterDidClickRewardVideoAd:(id)adapter;
/// 广告关闭
- (void)adapterDidCloseRewardVideoAd:(id)adapter;
/// 广告完成转化(关闭落地页)
- (void)adapterRewardedVideoAdDidFinishConversion:(id)interstitialAd interactionType:(int)interactionType;

///激励视频开始播放
- (void)adapterRewardedVideoAdStartPlay:(id)rewardedVideoAd;

 ///激励视频播放完成或者发生错误时回调
- (void)adapterRewardedVideoAdDidPlayFinish:(id)rewardedVideoAd withError:(NSError *_Nullable)error;
 ///视频广告播放达到激励条件回调
- (void)adapterRewardVideoAdDidRewardEffective:(id)rewardedVideoAd;

@end

/// 开屏广告适配层抽象协议
@protocol AdbidRewardVideoAdapterProtocol <NSObject>

/// 适配层代理（回调至AdbidSplashAd）
@property (nonatomic, weak) id<AdbidRewardVideoAdapterDelegate> adapterDelegate;
/// 广告最大加载时长（毫秒）
@property (nonatomic, assign) NSInteger maxLoadTime;
///是否静音
@property (nonatomic, assign) BOOL shouldMuted;
/// 广告eCPM（分）
@property (nonatomic, readonly) NSInteger eCPM;
/// 广告位ID（不同广告商的ID，如穿山甲的slotID、广点通的placementID）
@property (nonatomic, copy, readonly) NSString *slotId;

/// 初始化方法
- (instancetype)initWithSlotId:(NSString *)slotId;

/// 加载广告
- (void)loadAd;

- (void)loadAdWithToken:(NSString *)token;
/// 展示广告（主线程调用）
- (void)showAd:(UIViewController *)viewController;


/// 竞胜上报
- (void)winNotice:(NSInteger)price;

/// 竞败上报
- (void)lossNotice:(AdbidBidLossInfo *)info;

//是否可以显示
- (BOOL)isReady;
@end

NS_ASSUME_NONNULL_END
