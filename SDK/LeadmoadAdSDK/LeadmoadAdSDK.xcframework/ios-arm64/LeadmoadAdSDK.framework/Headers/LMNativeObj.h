//
//  LMNativeObj.h
//  LeadmoadAdSDK
//
//  Created by youzhadoubao on 2025/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMNativeObj : NSObject

/**
 广告标题
 */
@property (nonatomic, copy, readonly) NSString *title;

/**
 广告描述
 */
@property (nonatomic, copy, readonly) NSString *desc;

/**
 广告大图Url
 */
@property (nonatomic, copy, readonly) NSString *imageUrl;
/**
 视频URL
 */
@property (nonatomic, copy, readonly, nullable) NSString *videoUrl;

/**
 40201, // 640*100 横幅
 40202, // 16:9 横幅图文
 40501, // 9:16 竖版图片
 40502, // 16:9 横版图片
 40503, // 9:16 竖版视频
 40504, // 16:9 横版视频
 */
@property(nonatomic, assign, readonly) NSInteger style;

/**
 是否是视频广告
 */
@property(nonatomic,assign, readonly) BOOL isVideoAd;
@end

NS_ASSUME_NONNULL_END
