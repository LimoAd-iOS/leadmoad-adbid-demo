//
//  LMNativeAd.h
//  LeadmoadAdSDK
//
//  Created by youzhadoubao on 2025/9/25.
//

#import <Foundation/Foundation.h>
#import <AdbidSDK/adbidNativeObj.h>
#import <UIKit/UIKit.h>
#import <AdbidSDK/AdbidBidLossInfo.h>

NS_ASSUME_NONNULL_BEGIN

@class AdbidNativeAd;

@protocol AdbidNativeAdDelegate <NSObject>
/// 广告加载成功
- (void)nativeAdDidLoad:(AdbidNativeAd *)nativeAd;
/// 广告加载失败
- (void)nativeAd:(AdbidNativeAd *)nativeAd didFailToLoadWithError:(NSError *)error;

@optional

/**
 当自渲染广告被点击时调用
 */
- (void)nativeAdViewDidClick:(AdbidNativeAd *)nativeAd;

/**
 广告曝光回调
 */
- (void)nativeAdViewDidExpose:(AdbidNativeAd *)nativeAd;

@end

@interface AdbidNativeAd : NSObject

/**
 广告素材
 */
@property (atomic, strong, readonly, nullable) AdbidNativeObj *data;

/// 广告对象，在nativeAdViewDidClick回调后有值
@property (nonatomic, weak) id<AdbidNativeAdDelegate> delegate;
/**
 必传.
 处理广告点击事件的根视图控制器。
 */
@property (nonatomic, weak, readwrite) UIViewController *rootViewController;

@property (nonatomic, assign) BOOL shouldMuted; //设置静音
/**
 *  广告最大请求时长，单位毫秒。默认3000 , 最小500毫秒
 */
@property (nonatomic, assign) NSInteger maxLoadTime;

@property (nonatomic, assign, readonly) NSInteger eCPM;

- (instancetype)initWithSlotId:(NSString *)slotId;

/**
 * 加载信息流广告
 */
- (void)loadAd;

/**
 注册点击事件
 @param containerView 原生广告的容器视图。必传
 @param mainImageView 原生广告的大图容器
 @param clickableViews 可点击的视图数组。可选
 */
- (void)registerContainer:(__kindof UIView *)containerView mainImageView:(__kindof UIImageView *) mainImageView
       withClickableViews:(NSArray<__kindof UIView *> *_Nullable)clickableViews;

- (void)winNotice:(NSInteger)price;
 
- (void)lossNotice:(AdbidBidLossInfo *)info;

///是否准备好，准备好了才能加载广告
- (BOOL)isReady;
@end

NS_ASSUME_NONNULL_END
