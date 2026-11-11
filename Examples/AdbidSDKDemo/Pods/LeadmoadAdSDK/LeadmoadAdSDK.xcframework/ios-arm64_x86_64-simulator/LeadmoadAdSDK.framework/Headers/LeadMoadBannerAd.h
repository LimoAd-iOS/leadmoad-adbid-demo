//
//  LeadMoadBannerAd.h
//  LeadmoadAdSDK
//

#import <UIKit/UIKit.h>
#import <LeadmoadAdSDK/LeadMoadAdBidLossInfo.h>

NS_ASSUME_NONNULL_BEGIN

@class LeadMoadBannerAd;

@protocol LeadMoadBannerAdDelegate <NSObject>

/// 广告加载成功
- (void)bannerAdDidLoad:(LeadMoadBannerAd *)bannerAd;

/// 广告加载失败
- (void)bannerAd:(LeadMoadBannerAd *)bannerAd didFailToLoadWithError:(NSError *)error;

@optional

/// 广告被点击
- (void)bannerAdViewDidClick:(LeadMoadBannerAd *)bannerAd;

/// 广告曝光
- (void)bannerAdViewDidExpose:(LeadMoadBannerAd *)bannerAd;

/// 广告关闭按钮被点击（开发者需自行从父视图移除）
- (void)bannerAdViewWillClose:(LeadMoadBannerAd *)bannerAd;

/// 自动刷新即将开始（仅当 autoRefreshInterval > 0 时触发）
- (void)bannerAdViewWillRefresh:(LeadMoadBannerAd *)bannerAd;

@end

@interface LeadMoadBannerAd : UIView

@property (nonatomic, weak) id<LeadMoadBannerAdDelegate> delegate;

/**
 必传。处理广告点击事件的根视图控制器。
 */
@property (nonatomic, weak) UIViewController *rootViewController;

/**
 广告最大请求时长，单位毫秒。默认 5000，最小 500。
 */
@property (nonatomic, assign) NSInteger maxLoadTime;

/**
 自动刷新间隔，单位秒。0 表示不自动刷新（默认）。建议 ≥ 30。
 */
@property (nonatomic, assign) NSInteger autoRefreshInterval;

/**
 是否显示关闭按钮。默认 NO。
 */
@property (nonatomic, assign) BOOL showCloseButton;

/**
 是否静音。客户显式设置时覆盖云端 is_mute；不设置则保留渠道默认（未下发时静音）。
 */
@property (nonatomic, assign) BOOL shouldMuted;

/**
 广告 eCPM（加载成功后可读）。
 */
@property (nonatomic, assign, readonly) NSInteger eCPM;

/**
 初始化 Banner 广告，使用默认尺寸（宽=屏幕宽，高=50pt）。
 @param slotId  广告位 ID
 */
- (instancetype)initWithSlotId:(NSString *)slotId;

- (instancetype)initWithSlotId:(NSString *)slotId requestId:(NSString *)requestId;

/**
 初始化 Banner 广告，使用自定义尺寸。
 @param slotId  广告位 ID
 @param frame   Banner 尺寸与位置；传 CGRectZero 则使用默认尺寸（宽=屏幕宽，高=50pt）
 */
- (instancetype)initWithSlotId:(NSString *)slotId frame:(CGRect)frame;

- (instancetype)initWithSlotId:(NSString *)slotId requestId:(NSString *)requestId frame:(CGRect)frame;

/// 加载广告
- (void)loadAd;
/// 服务器竞价通过token加载广告
- (void)loadAdWithToken:(NSString*)token;

/// 竞胜通知
- (void)winNotice:(NSInteger)price;

/// 竞败通知
- (void)lossNotice:(LeadMoadAdBidLossInfo *)info;

/// 广告是否可展示
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
