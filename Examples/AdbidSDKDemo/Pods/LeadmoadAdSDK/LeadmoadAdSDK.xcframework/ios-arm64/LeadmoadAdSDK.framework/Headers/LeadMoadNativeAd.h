//
//  LeadMoadNativeAd.h
//  LeadmoadAdSDK
//
//  Created by youzhadoubao on 2025/9/25.
//

#import <Foundation/Foundation.h>
#import <LeadmoadAdSDK/LeadMoadAdBidLossInfo.h>
#import <LeadmoadAdSDK/LeadMoadNativeMediaView.h>
#import <LeadmoadAdSDK/LeadMoadNativeObj.h>
#import <LeadmoadAdSDK/LeadMoadNativeView.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LeadMoadNativeAd;

@protocol LeadMoadNativeAdDelegate <NSObject>
/// 广告加载成功
- (void)nativeAdDidLoad:(LeadMoadNativeAd *)nativeAd;
/// 广告加载失败
- (void)nativeAd:(LeadMoadNativeAd *)nativeAd didFailToLoadWithError:(NSError *)error;

@optional

/**
 当自渲染广告被点击时调用
 */
- (void)nativeAdViewDidClick:(LeadMoadNativeAd *)nativeAd withView:(UIView *_Nullable)view;

/**
 广告曝光回调
 */
- (void)nativeAdViewDidExpose:(LeadMoadNativeAd *)nativeAd;

@end

@interface LeadMoadNativeAd : NSObject

/**
 广告素材
 */
@property (atomic, strong, readonly, nullable) LeadMoadNativeObj *data;

@property (nonatomic, weak) id<LeadMoadNativeAdDelegate> delegate;
/**
 必传.
 处理广告点击事件的根视图控制器。
 */
@property (nonatomic, weak, readwrite) UIViewController *rootViewController;

/**
 * 广告最大请求时长，单位毫秒。默认5000
 */
@property (nonatomic, assign) NSInteger maxLoadTime;

@property (nonatomic, assign, readonly) NSInteger eCPM;

/// 竞价素材信息，字段对齐聚合 material：appName/appPackageName/url/title/desc/jump_url/logo
@property (nonatomic, copy, readonly, nullable) NSDictionary *material;

- (instancetype)initWithSlotId:(NSString *)slotId;

- (instancetype)initWithSlotId:(NSString *)slotId requestId:(NSString*)requestId;


/**
 * 加载信息流广告
 */
- (void)loadAd;
/**
 * 通过token加载信息流广告
 */
- (void)loadAdWithToken:(NSString*)token;
/**
 注册点击事件
 @param containerView 原生广告的容器视图。必传
 @param clickableViews 可点击的视图数组。可选
 */
- (void)registerContainer:(__kindof UIView *)containerView
       withClickableViews:(NSArray<__kindof UIView *> *_Nullable)clickableViews;

- (void)registerContainer:(__kindof UIView *)containerView
            mainImageView:(__kindof UIView *_Nullable)mainImageView
       withClickableViews:(NSArray<__kindof UIView *> *_Nullable)clickableViews;

- (void)winNotice:(NSInteger)price;
- (void)lossNotice:(LeadMoadAdBidLossInfo *)info;

/// 检查广告是否可以展示
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
