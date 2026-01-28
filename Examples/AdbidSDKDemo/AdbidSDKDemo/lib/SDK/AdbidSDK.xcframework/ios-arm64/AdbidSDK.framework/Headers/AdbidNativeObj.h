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
 广告创意图标
 */
@property (nonatomic, copy, readonly) NSString *iconUrl;
/**
 广告图片素材地址
 */
@property (nonatomic, copy, readonly) NSArray<AdbidNativeImageObj*> *images;
/**
 广告图片素材信息
 */
@property (nonatomic, copy, readonly) NSArray *imageURLs;

@property (nonatomic, assign, readonly) bool isVideoAd;

@property (nonatomic, copy, readonly) AdbidNativeVideoObj * videoAdInfo;

@end

@interface AdbidNativeVideoObj : NSObject

@property (nonatomic, copy, readonly) NSString *videoUrl;

@property (nonatomic, copy, readonly) NSString *coverImageUrl;
 
@end

@interface AdbidNativeImageObj : NSObject

@property (nonatomic, copy, readonly) NSString *imageUrl;

@property (nonatomic, copy, readonly) NSString *materialld;
 
@end

NS_ASSUME_NONNULL_END
