//
//  LMRewardVideoAd.h
//  LeadmoadAdSDK
//
//  Created by mark zhang  on 2025/10/3.
//

#import <Foundation/Foundation.h>
#import <LeadmoadAdSDK/LMAdBidLossInfo.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LMRewardVideoAd;

@protocol LMRewardVideoAdDelegate <NSObject>

@optional
/// 激励视频广告加载成功
- (void)rewardVideoAdDidLoad:(LMRewardVideoAd *)rewardVideoAd;

/// 激励视频广告加载失败
- (void)rewardVideoAd:(LMRewardVideoAd *)rewardVideoAd didFailToLoadWithError:(NSError *)error;

/// 激励视频广告开始展示
- (void)rewardVideoAdDidShow:(LMRewardVideoAd *)rewardVideoAd;

/// 激励视频广告展示失败
- (void)rewardVideoAd:(LMRewardVideoAd *)rewardVideoAd didFailToShowWithError:(NSError *)error;

/// 激励视频广告被点击
- (void)rewardVideoAdDidClick:(LMRewardVideoAd *)rewardVideoAd;

/// 激励视频广告关闭
- (void)rewardVideoAdDidClose:(LMRewardVideoAd *)rewardVideoAd;

/// 激励视频播放完成，用户获得奖励
- (void)rewardVideoAdDidReward:(LMRewardVideoAd *)rewardVideoAd;

@end

@interface LMRewardVideoAd : NSObject

/// 代理对象
@property (nonatomic, weak) id<LMRewardVideoAdDelegate> delegate;

/// 广告最大请求时长，单位毫秒。默认5000，最小500毫秒
@property (nonatomic, assign) NSInteger maxLoadTime;

/// 是否已加载完成
@property (nonatomic, assign, readonly) BOOL isAdLoaded;

/// 是否正在展示
@property (nonatomic, assign, readonly) BOOL isAdShowing;

/// 返回广告的eCPM，单位：分
@property (nonatomic, assign, readonly) NSInteger eCPM;

/// 初始化激励视频广告
/// @param slotId 广告位ID
- (instancetype)initWithSlotId:(NSString *)slotId;

/// 加载激励视频广告
- (void)loadAd;

/// 展示激励视频广告
/// @param viewController 用于展示广告的视图控制器
- (void)showAdFromViewController:(UIViewController *)viewController;

/// 检查广告是否可以展示
- (BOOL)isReady;

// 竞胜/竞败上报
- (void)winNotice:(NSInteger)price;
- (void)lossNotice:(LMAdBidLossInfo *)info;

@end

NS_ASSUME_NONNULL_END
