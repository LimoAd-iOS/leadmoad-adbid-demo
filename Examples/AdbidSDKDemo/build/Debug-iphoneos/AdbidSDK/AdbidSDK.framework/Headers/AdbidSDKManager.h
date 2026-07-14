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
//同步获取sdkInfo，新版本不再支持获取
+ (NSString*)getSDKInfo;

//异步获取sdkInfo
//返回block不一定是主线程，如果自己进行线程切换
+ (void)requestServerBidTokenConfigForPositionId:(NSString *)positionId
                                      completion:(void (^ _Nullable)(NSString *_Nullable sdkInfo, NSError *_Nullable error))completion;

+ (NSDictionary *)allServerBidTokenConfigs;

+ (NSString*)sdkVersion;

@end

NS_ASSUME_NONNULL_END
