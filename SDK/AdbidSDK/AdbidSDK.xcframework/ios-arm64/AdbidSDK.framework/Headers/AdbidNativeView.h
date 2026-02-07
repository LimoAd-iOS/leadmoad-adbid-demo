//
//  LMNativeView.h
//  LeadmoadAdSDK
//
//  Created by youzhadoubao on 2025/9/25.
//

#import <UIKit/UIKit.h>
@class AdbidNativeView;
@class AdbidNativeMediaView;
@class AdbidNativeAd;
NS_ASSUME_NONNULL_BEGIN

@interface AdbidNativeView : UIView

/**
 视频广告的媒体View，绑定数据对象后自动生成，可自定义布局
 */
@property (nonatomic, strong, readonly) AdbidNativeMediaView *mediaView;

- (void)refreshData:(AdbidNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
