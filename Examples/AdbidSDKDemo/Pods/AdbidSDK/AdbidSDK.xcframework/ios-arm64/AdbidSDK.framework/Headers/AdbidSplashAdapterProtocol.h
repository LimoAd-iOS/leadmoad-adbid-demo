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
@protocol AdbidSplashAdapterDelegate <NSObject>
@optional
/// 素材加载成功 extra 扩展数据
- (void)adapterDidLoadSplashAd:(id)adapter extra:(NSDictionary*)extra;
/// 加载失败
- (void)adapter:(id)adapter didFailToLoadSplashAdWithError:(NSError *)error;
/// 展示成功
- (void)adapterDidShowSplashAd:(id)adapter;
/// 展示失败
- (void)adapter:(id)adapter didFailToShowSplashAdWithError:(NSError *)error;
/// 广告点击
- (void)adapterDidClickSplashAd:(id)adapter;
/// 广告关闭
- (void)adapterDidCloseSplashAd:(id)adapter;
/// 广告完成转化(关闭落地页)
- (void)adapterSplashAdDidFinishConversion:(id)interstitialAd interactionType:(int)interactionType;

@end

/// 开屏广告适配层抽象协议
@protocol AdbidSplashAdapterProtocol <NSObject>

/// 适配层代理（回调至AdbidSplashAd）
@property (nonatomic, weak) id<AdbidSplashAdapterDelegate> adapterDelegate;
/// 广告最大加载时长（毫秒）
@property (nonatomic, assign) NSInteger maxLoadTime;
/// 广告eCPM（分）
@property (nonatomic, readonly) NSInteger eCPM;
@property (nonatomic, assign) BOOL shouldMuted;///是否静音，默认是静音
/// 广告位ID（不同广告商的ID，如穿山甲的slotID、广点通的placementID）
@property (nonatomic, copy, readonly) NSString *slotId;
@property (nonatomic, copy, readonly) NSString* currentRequestId;
@property (nonatomic, strong, nullable) UIViewController *viewController; //落地页显示控制器

/// 初始化方法
- (instancetype)initWithSlotId:(NSString *)slotId;

/// 加载广告
- (void)loadAd;

/// 展示广告（主线程调用）
- (void)showAd:(UIViewController *)viewController;

- (void)showAdToWindow:(UIWindow *)window;

/// 竞胜上报
- (void)winNotice:(NSInteger)price;

/// 竞败上报
- (void)lossNotice:(AdbidBidLossInfo *)info;

//是否可以显示
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
