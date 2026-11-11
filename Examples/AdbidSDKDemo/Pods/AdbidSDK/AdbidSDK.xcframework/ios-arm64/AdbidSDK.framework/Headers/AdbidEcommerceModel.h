//
//  AdbidEcommerceModel.h
//  AdbidSDK
//
//  Created by chaizhiyong on 2026/9/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AdbidEcommerceCouponModel, AdbidEcommerceLiveModel, AdbidEcommerceProductModel, AdbidEcommerceShopModel;

/// 锚点电商广告物料聚合信息
@interface AdbidEcommerceModel : NSObject
/// 券信息
@property (nonatomic, strong) AdbidEcommerceCouponModel *coupon;
/// 是否有券 (无券必传商品信息)
@property (nonatomic, assign) BOOL has_coupon;
/// 直播信息
@property (nonatomic, strong) AdbidEcommerceLiveModel *live;
/// 商品信息
@property (nonatomic, strong) AdbidEcommerceProductModel *product;
/// 店铺信息
@property (nonatomic, strong) AdbidEcommerceShopModel *shop;
@end

/// 券信息小类
@interface AdbidEcommerceCouponModel : NSObject
/// 券过期时间 (秒级时间戳)
@property (nonatomic, assign) long long expire_time;
/// 券开始生效时间 (秒级时间戳)
@property (nonatomic, assign) long long start_time;
/// 使用门槛 (无门槛为0)
@property (nonatomic, assign) NSInteger threshold;
/// 券面额
@property (nonatomic, assign) NSInteger value;
@end

/// 直播信息小类
@interface AdbidEcommerceLiveModel : NSObject
/// 粉丝量 (非必传)
@property (nonatomic, assign) NSInteger fans_count;
/// 直播间logo
@property (nonatomic,   copy) NSString *logo;
/// 直播间名称
@property (nonatomic,   copy) NSString *name;
/// 在线观看人数 (非必传)
@property (nonatomic, assign) NSInteger online_viewers;
@end

/// 商品信息小类
@interface AdbidEcommerceProductModel : NSObject
/// 商品券后价 (建议以分为单位，避免精度丢失)
@property (nonatomic, assign) NSInteger coupon_price;
/// 商品名称
@property (nonatomic,   copy) NSString *name;
/// 商品价格 (建议以分为单位，避免精度丢失)
@property (nonatomic, assign) NSInteger price;
/// 商品图片 (原则上 30~50K左右)
@property (nonatomic,   copy) NSString *url;
@end

/// 店铺信息小类
@interface AdbidEcommerceShopModel : NSObject
/// 粉丝量 (非必传)
@property (nonatomic, assign) NSInteger fans_count;
/// 店铺logo (原则上 10K以内)
@property (nonatomic,   copy) NSString *logo;
/// 店铺名称 (最长7个汉字，超出会省略)
@property (nonatomic,   copy) NSString *name;
@end


NS_ASSUME_NONNULL_END
