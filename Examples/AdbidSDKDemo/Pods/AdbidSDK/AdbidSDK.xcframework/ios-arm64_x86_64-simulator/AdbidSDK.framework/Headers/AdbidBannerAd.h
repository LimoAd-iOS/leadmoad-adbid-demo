//
//  AdbidBannerAd.h
//  AdbidSDK
//
//  Created by on 2025/9/17.
//

#import <Foundation/Foundation.h>
#import <AdbidSDK/AdbidBidLossInfo.h>
#import <AdbidSDK/AdbidPublicDefine.h>
#import <AdbidSDK/AdbidAdInfoModel.h>
#import <AdbidSDK/AdbidMaterialModel.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class AdbidBannerAd;
@protocol AdbidBannerAdDelegate <NSObject>
@optional
/// 广告请求成功
/// 
- (void)bannerAdDidLoad:(AdbidBannerAd *)bannerAd;
/// 广告请求失败
- (void)bannerAdFailedToLoad:(AdbidBannerAd *)bannerAd withError:(NSError *)error;
/// 开屏广告成功展示
- (void)bannerAdDidShow:(AdbidBannerAd *)bannerAd;
/// 开屏广告展示失败
- (void)bannerAdFailedToShow:(AdbidBannerAd *)bannerAd  withError:(NSError *)error;
/// 开屏广告点击
- (void)bannerAdDidClick:(AdbidBannerAd *)bannerAd;
/// 关闭按钮被点击。聚合不会自动从容器移除广告，使用方自行调用 removeBannerAdWithView: 决定是否清掉。
- (void)bannerAdDidClose:(AdbidBannerAd *)bannerAd;
/// 广告完成转化(关闭落地页)
- (void)bannerAdDidFinishConversion:(AdbidBannerAd *)bannerAd interactionType:(AdbidAdRedirectionType)interactionType;
/// 自动刷新即将开始（仅 autoRefreshInterval > 0 时）
- (void)bannerAdWillRefresh:(AdbidBannerAd *)bannerAd;

@end

@interface AdbidBannerAd : NSObject

@property (nonatomic, weak) id<AdbidBannerAdDelegate> delegate;

/// 落地页控制器。由调用方持有，SDK 不保留，避免和页面互相持有。
@property (nonatomic, weak, nullable) UIViewController *viewController;
/// 渠道 Banner 视图。加载成功后可自行添加到页面；也可用 showBannerAdWithView: 填入宿主容器。
@property (nonatomic, strong, readonly, nullable) UIView *bannerView;
/// 是否显示关闭按钮。默认 YES，需在 loadAd 前设置。
@property (nonatomic, assign) BOOL showCloseButton;
/// 自动刷新间隔，单位秒。0 表示不刷新（默认）。渠道侧最小 30 秒。需在展示前设置。
@property (nonatomic, assign) NSInteger autoRefreshInterval;
/// Banner 尺寸。CGSizeZero 使用渠道默认（屏宽 × 50pt）。需在 loadAd 前设置。
@property (nonatomic, assign) CGSize adSize;
/// 显式设置时写入渠道并覆盖其默认。未设置时不写入，实际播放保留渠道默认。
@property (nonatomic, assign) BOOL shouldMuted;
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
/**
 * 将 Banner 展示到宿主传入的容器中。容器高度需为 50pt，且必须已经加到窗口上。
 * 已在主线程则直接展示；非主线程会切到主线程再展示。
 */
- (void)showBannerAdWithView:(UIView *)view;
/**
 * 将 Banner 从宿主容器中移除。不会把容器本身从页面摘掉。
 * 点击关闭后请在 bannerAdDidClose: 里按需调用。必须在主线程调用。
 */
- (void)removeBannerAdWithView:(UIView *)view;

/// price 二价（即竞败方最高价）
- (void)winNotice:(NSInteger)price;
/// info 竞胜方平台  竞胜方最高价
- (void)lossNotice:(AdbidBidLossInfo *)info;
///是否准备好，准备好了才能加载广告
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
