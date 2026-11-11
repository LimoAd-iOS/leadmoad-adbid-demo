//
//  AdbidMaterialModel.h
//  AdbidSDK
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdbidMaterialModel : NSObject
/// 广告标题
@property (nonatomic, copy, nullable) NSString *title;
/// 广告描述
@property (nonatomic, copy, nullable) NSString *desc;
/// 应用名称
@property (nonatomic, copy, nullable) NSString *appName;
/// 应用包名
@property (nonatomic, copy, nullable) NSString *appPackageName;
/// 应用 Logo 地址
@property (nonatomic, copy, nullable) NSString *logo;
/// 原始素材地址
@property (nonatomic, copy, nullable) NSString *url;
/// 落地页地址
@property (nonatomic, copy, nullable) NSString *landingUrl;
/// 视频素材地址，图片素材时为空
@property (nonatomic, copy, nullable) NSString *videoUrl;
/// 图片素材地址，视频素材时为空
@property (nonatomic, copy, nullable) NSString *imageUrl;
/// 唤端链接或落地页地址
@property (nonatomic, copy, nullable) NSString *jump_url;

@end

NS_ASSUME_NONNULL_END
