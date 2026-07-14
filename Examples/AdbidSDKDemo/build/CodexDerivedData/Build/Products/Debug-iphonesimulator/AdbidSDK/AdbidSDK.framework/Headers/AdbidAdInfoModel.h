//
//  AdbidAdInfoModel.h
//  AdbidSDK
//
//  Created by chaizhiyong on 2026/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdbidAdInfoModel : NSObject

@property (nonatomic,copy) NSString* platform; // 广告平台
@property (nonatomic,copy) NSString* positionId;//聚合广告位
@property (nonatomic,copy) NSString* adUnitId; //广告平台对应广告位
@end

NS_ASSUME_NONNULL_END
