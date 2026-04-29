//
//  LMNativeObj.h
//  LeadmoadAdSDK
//
//  Created by youzhadoubao on 2025/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AdbidNativeVideoObj;
@class AdbidNativeImageObj;
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
 广告是图片还是视频
 */
@property (nonatomic, assign, readonly) bool isVideoAd;

/**
 广告是图片，该属性有值
 */
@property (nonatomic, copy, readonly) AdbidNativeImageObj * imageAdInfo;

/**
 广告是视频，该属性有值
 */
@property (nonatomic, copy, readonly) AdbidNativeVideoObj * videoAdInfo;

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
