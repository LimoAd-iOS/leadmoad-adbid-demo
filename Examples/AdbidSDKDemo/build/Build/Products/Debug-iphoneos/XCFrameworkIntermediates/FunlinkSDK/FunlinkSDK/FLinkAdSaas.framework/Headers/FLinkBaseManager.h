//
//  FLinkBaseManager.h
//  AdDemo
//
//  Created by lurich on 2021/9/14.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <FLinkAdSaas/FLinkNativeAdRenderProtocol.h>
#import <FLinkAdSaas/FLinkProvideConst.h>

#define FLink_Log(frmt, ...)                                                           \
if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FLink_DEBUG_UNION"]) {         \
    NSLog(@"【FLinkAdSaas】%@", [NSString stringWithFormat:frmt,##__VA_ARGS__]);     \
}

@class FLinkFeedAdData,FLinkAdSourcesModel,FLinkConfigModelAdplace,FLinkLaunchView,FLinkFullscreenVideoAdd,FLinkSkipAdButton,FLinkInterstitialView,FLinkBannerView,FLinkVideoConfig;
NS_ASSUME_NONNULL_BEGIN

typedef void(^FLinkADSuccess)(FLinkAdSourcesModel *model);

@interface FLinkBaseManager : NSObject

@property (nonatomic, copy, nullable) FLinkADSuccess successBlock;
@property (nonatomic, strong) FLinkAdSourcesModel * _Nullable baseModel;

/// 半开屏时传入的 logo view
@property (nonatomic, strong, nullable) UIView *bottomView;
//开屏广告的背景图片  可以设置背景图片作为开屏加载时的默认背景
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIWindow *window;
/// 开发者传入用来弹出目标页的ViewController
@property (nonatomic, weak) UIViewController *showAdController;
@property (nonatomic, strong) UIViewController *backVC;

/// MARK: 加载广告方法必须子类实现
/// 加载广告
- (void)loadADWithModel:(FLinkAdSourcesModel *)model;
/// 联盟竞价获取参数
- (NSDictionary *)getAdImpWithModel:(FLinkAdSourcesModel *)model;
/// 加载bidding广告
- (void)loadBiddingADWithModel:(FLinkAdSourcesModel *)model;

/// 销毁属性，防止内存泄漏
- (void)deallocAllProperty;

@property (nonatomic, strong) FLinkAdSourcesModel * _Nullable sourceModel;
/// 联盟竞价失败原因上报
- (void)biddingAdFailWithPrice:(NSString *)price;
- (void)biddingAdFailWithPrice:(NSString *)price model:(FLinkAdSourcesModel *) model;
/// 联盟竞价成功上报
- (void)biddingAdSuccessWithPrice:(NSString *)price SecondPrice:(NSString *)secondPrice;
/// 竞价ECPM
- (void)s2sBidECPMWithPrice:(NSString *)price;
/// 竞价是否有效
- (void)isValidBidECPMWithPrice:(double)price;
- (void)isValidBidECPMWithPrice:(double)price withObject:(nullable NSObject *) baseAd;
/// 广告信息
- (void)adJsonDict:(NSObject *)baseAd;
- (void)adJsonDict:(NSObject *)baseAd complate:(nullable void(^)(void)) block;

/// 子类自定义时可实现的视图对象
@property (nonatomic, strong, nullable) FLinkLaunchView *yxADView;
@property (nonatomic, strong, nullable) FLinkInterstitialView *flink_InterstitialView;
@property (nonatomic, strong, nullable) FLinkBannerView *flink_bannerView;
@property (nonatomic, strong, nullable) UIButton *closeBtn;
@property (nonatomic, strong, nullable) FLinkSkipAdButton *skipButton;
@property (nonatomic, strong, nullable) FLinkVideoConfig *videoConfig;

/// 获取最顶层控制器
- (UIViewController *)topVC;
/// UIViewLayoutConstraintCreation
- (void)flink_ViewAnchorWithView:(UIView *)view Top:(NSLayoutYAxisAnchor *)top Left:(NSLayoutXAxisAnchor *)left Bottom:(NSLayoutYAxisAnchor *)bottom Right:(NSLayoutXAxisAnchor *)right Padding:(UIEdgeInsets)padding Size:(CGSize)size;
- (NSString *)getNowDateWithFormat:(NSString *)format;
- (UIImage*)imageFromView:(UIView*)view;

@end

@interface FLinkBaseManager (FLinkSplashAdd)

/// 开屏尺寸
@property (nonatomic) CGRect frame;
/// 跳过时间
@property (nonatomic) NSInteger duration;
/// 等待时间
@property (nonatomic) NSInteger waitDataDuration;
/// 是否
@property (nonatomic) NSInteger hotspot_type;
/// MARK: 展示开屏广告
- (void)showSplashAdInWindow:(UIWindow *)window withBottomView:(UIView *)bottomView;
- (void)showSplashAdWithBottomView:(UIView *)bottomView;
-(void) destorySplashAdView;

@end

@interface FLinkBaseManager (FLinkRewardVideoAdd)

/// MARK: 展示激励视频
- (void)showRewardVideoAD;

@end

@interface FLinkBaseManager (FLinkBannerAdd)

/// 广告尺寸
@property (nonatomic) CGSize size;
/// MARK: 展示横幅广告
- (void)showBannerAdWithView:(UIView *)view;

@end

@interface FLinkBaseManager (FLinkInterstitialAdd)

/// MARK: 展示插屏广告
- (void)showInterstitialAd;

@end

@interface FLinkBaseManager (FLinkFeedAdd)

/// 原生广告,模板广告的请求个数
@property (nonatomic) NSInteger adCount;

/// 原生广告绑定视图和注册
- (void)registerAdViewForBindImage:(UIImageView *)view adData:(FLinkFeedAdData *)adData clickableViews:(NSArray *)views;

/// 新版注册视图，必须子类去实现
- (void)registerAdForView:(UIView<FLinkNativeAdRenderProtocol> *)view adData:(FLinkFeedAdData *)adData;

/// 解绑视图点击
- (void)unregisterAdData:(FLinkFeedAdData *)adData;
/// 模板广告渲染视图
- (void)renderViewWithViewArray:(NSArray *)viewArray;
/// s2s专用
- (void) s2sAdDidLoadToScreen;
/// 更换 showAdController
- (void)changeAdViewController:(UIViewController *)adViewController Data:(FLinkFeedAdData *)adData;
-(void) destorySingleAD;

@end



@interface FLinkBaseManager (FLinkFullscreenVideoAdd)

/// MARK: 展示全屏视频广告
- (void)showFullscreenVideoAD;

@end
NS_ASSUME_NONNULL_END
