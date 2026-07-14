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

/// 开屏广告适配层代理（回调给AdbidNativeAd）
@protocol AdbidNativeAdapterDelegate <NSObject>
@optional
/// 素材加载成功
/// data 素材
/// resource 本地素材
- (void)adapterDidLoadNativeAd:(id)adapter data:(NSDictionary*)data  localResource:(NSDictionary*)resource;
/// 加载失败
- (void)adapter:(id)adapter didFailToLoadNativeAdWithError:(NSError *)error;
/// 展示成功
- (void)adapterDidShowNativeAd:(id)adapter;
/// 展示失败
- (void)adapter:(id)adapter didFailToShowNativeAdWithError:(NSError *)error;
/// 广告点击
- (void)adapterDidClickNativeAd:(id)adapter;
/// 广告关闭
- (void)adapterDidCloseNativeAd:(id)adapter;

@end

/// 开屏广告适配层抽象协议
@protocol AdbidNativeAdapterProtocol <NSObject>
/**
 必传.
 处理广告点击事件的根视图控制器。
 */
@property (nonatomic, weak, readwrite) UIViewController *rootViewController;
/// 适配层代理（回调至AdbidNativeAd）
@property (nonatomic, weak) id<AdbidNativeAdapterDelegate> adapterDelegate;
/// 广告最大加载时长（毫秒）
@property (nonatomic, assign) NSInteger maxLoadTime;
/// 广告eCPM（分）
@property (nonatomic, readonly) NSInteger eCPM;
/// 广告位ID（不同广告商的ID，如穿山甲的slotID、广点通的placementID）
@property (nonatomic, copy, readonly) NSString *slotId;

/// 初始化方法
- (instancetype)initWithSlotId:(NSString *)slotId;

/// 加载广告
- (void)loadAd;

- (void)loadAdWithToken:(NSString *)token;
/// 竞胜上报
- (void)winNotice:(NSInteger)price;

/// 竞败上报
- (void)lossNotice:(AdbidBidLossInfo *)info;
/*
 * containerView 广告主视图(容器)
 * mainImageView 广告图
 * clickableViews 可点击view的数组
*/
- (void)registerContainer:(__kindof UIView *)containerView mainImageView:(__kindof UIImageView *) mainImageView
       withClickableViews:(NSArray<__kindof UIView *> *_Nullable)clickableViews;

@optional
/*
 * 带额外配置的注册方法。已知 extraConfig key：
 *   - mediaView      AdbidNativeMediaView*  App 持有的媒体视图,adapter 在视频广告时可把自家 SDK 的播放视图嵌进它
 *   - adFrame / mediaViewFrame / sizeToFit / adLogoFrame / adOptionsFrame / networkLogoFrame / videoPlayType
 *     模版广告专用,见 AdbidNativeAd.h 注释
 */
- (void)registerContainer:(__kindof UIView *)containerView
            mainImageView:(__kindof UIImageView *)mainImageView
       withClickableViews:(NSArray<__kindof UIView *> *)clickableViews
              extraConfig:(NSDictionary *)extraConfig;
//是否可以显示
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
