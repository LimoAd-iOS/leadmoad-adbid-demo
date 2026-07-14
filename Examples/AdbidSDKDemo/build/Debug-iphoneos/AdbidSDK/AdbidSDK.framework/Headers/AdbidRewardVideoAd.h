//
//  AdbidrewardVideoAd.h
//  AdbidSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <AdbidSDK/AdbidBidLossInfo.h>
#import <AdbidSDK/AdbidAdInfoModel.h>

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class AdbidRewardVideoAd;
@protocol AdbidRewardVideoAdDelegate <NSObject>
@optional
/// 开屏广告素材加载成功
- (void)rewardVideoAdDidLoad:(AdbidRewardVideoAd *)rewardVideoAd;
/// 开屏广告加载失败
- (void)rewardVideoAd:(AdbidRewardVideoAd *)rewardVideoAd didFailToLoadWithError:(NSError *)error;
/// 开屏广告成功展示
- (void)rewardVideoAdDidShow:(AdbidRewardVideoAd *)rewardVideoAd;
/// 开屏广告展示失败
- (void)rewardVideoAd:(AdbidRewardVideoAd *)rewardVideoAd didFailToShowWithError:(NSError *)error;
/// 开屏广告点击
- (void)rewardVideoAdDidClick:(AdbidRewardVideoAd *)rewardVideoAd;

/// 广告完成转化(关闭落地页)
- (void)rewardVideoAdDidFinishConversion:(AdbidRewardVideoAd *)interstitialAd interactionType:(AdbidAdRedirectionType)interactionType;
/// 开屏广告关闭
- (void)rewardVideoAdDidClose:(AdbidRewardVideoAd *)rewardVideoAd;

///激励视频开始播放
- (void)rewardVideoAdDidStartPlay:(AdbidRewardVideoAd *)rewardedVideoAd;

 ///激励视频播放完成或者发生错误时回调
- (void)rewardVideoAdDidEndPlay:(AdbidRewardVideoAd *)rewardedVideoAd withError:(NSError *_Nullable)error;

 ///视频广告播放达到激励条件回调
- (void)rewardVideoAdDidReward:(AdbidRewardVideoAd *)rewardedVideoAd;


@end

@interface AdbidRewardVideoAd : NSObject

@property (nonatomic, weak) id<AdbidRewardVideoAdDelegate> delegate;

// 广告最大请求时长，单位毫秒。默认3000 , 最小500毫秒
@property (nonatomic, assign) NSInteger maxLoadTime;
/// 返回广告的eCPM，单位：分
@property (nonatomic, readonly) NSInteger eCPM;
// 广告信息
@property (nonatomic, readonly) AdbidAdInfoModel* adInfo;

@property (nonatomic, assign) BOOL shouldMuted; //设置静音

@property (nonatomic, strong) NSDictionary* LocalExtra; //设置本地数据用于激励

- (instancetype)initWithSlotId:(NSString *)slotId;

- (NSString*)getRequestId;

/// 发起拉取广告请求
- (void)loadAd;

- (void)loadAdWithToken:(NSString *)token;

/// 必须在主线程调用
- (void)showAd:(UIViewController *)viewController;
/// price 二价（即竞败方最高价）
- (void)winNotice:(NSInteger)price;
/// info 竞胜方平台  竞胜方最高价
- (void)lossNotice:(AdbidBidLossInfo *)info;
///是否准备好
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
