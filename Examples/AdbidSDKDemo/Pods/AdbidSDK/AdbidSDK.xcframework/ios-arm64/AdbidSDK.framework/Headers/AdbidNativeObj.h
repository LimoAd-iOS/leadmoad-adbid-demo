//
//  LMNativeObj.h
//  LeadmoadAdSDK
//
//  Created by youzhadoubao on 2025/9/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AdbidNativeVideoObj;
@class AdbidNativeImageObj;
@class AdbidEcommerceModel;
@interface AdbidNativeObj : NSObject

/**
 广告标题
 */
@property (nonatomic, copy, readonly) NSString *title;
/**
 广告描述
 */
@property (nonatomic, copy, readonly) NSString *desc;
/**
 广告图标
 */
@property (nonatomic, copy, readonly) NSString *iconUrl;

/**
 广告图标图片
 */
@property (nonatomic, strong, nullable) UIImage *iconImage;

/**
 广告logo
 */
@property (nonatomic, copy) UIImage *logoImage;

/**
 广告logo  logoImage 没值的话，判断logoUrl是否有返回。
 */
@property (nonatomic, copy, readonly) NSString *logoUrl;

/**
 广告是图片还是视频
 */
@property (nonatomic, assign, readonly) bool isVideoAd;

/**
 是否模版广告（YES 时调用方不再读 title/desc/iconUrl/imageAdInfo 等字段，
 调用 registerContainer 后由适配器把模版视图挂到 containerView 上）
 */
@property (nonatomic, assign) BOOL isExpressAd;

/**
 广告是图片，该属性有值
 */
@property (nonatomic, copy, readonly) AdbidNativeImageObj * imageAdInfo;

/**
  广告是视频，该属性有值
 */
@property (nonatomic, copy, readonly) AdbidNativeVideoObj * videoAdInfo;

/**
  锚点电商广告物料聚合信息
 */
@property (nonatomic, copy, readonly)  AdbidEcommerceModel *ecommerce;

@end

@interface AdbidNativeVideoObj : NSObject

@property (nonatomic, copy, readonly) NSString *videoUrl;

@property (nonatomic, copy, readonly) NSString *coverImageUrl;
 
@end

@interface AdbidNativeImageObj : NSObject

@property (nonatomic, copy,   readonly) NSString *imageUrl;
 
@property (nonatomic, assign, readonly) CGFloat height;

@property (nonatomic, assign, readonly) CGFloat width;

@end

NS_ASSUME_NONNULL_END
