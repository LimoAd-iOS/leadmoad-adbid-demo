//
//  LMAdSDKManager.h
//  AdbidSDK
//
//  Created by youzhadoubao on 2025/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdbidSDKManager : NSObject

+ (void)startWithAsyncCompletionHandler:(void (^ __nullable)(BOOL success ,NSError * __nullable error))completionHandler;
/**
 * @brief 设置额外的用户数据. 请在广告初始化前设置该属性
 * @details @"caid_value"  caid值
 * @details @"caid_version" caid版本
 */
+ (void)setExtraUserData:(NSDictionary <NSString *, NSString *>*)userDictionary;
@end

NS_ASSUME_NONNULL_END
