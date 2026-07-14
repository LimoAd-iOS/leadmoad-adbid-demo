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

+ (NSString*)getSDKInfo;

+ (nullable NSDictionary *)serverBidTokenConfigForPositionId:(NSString *)positionId;

+ (void)requestServerBidTokenConfigForPositionId:(NSString *)positionId
                                      completion:(void (^ _Nullable)(NSString *_Nullable config, NSError *_Nullable error))completion;

+ (NSDictionary *)allServerBidTokenConfigs;

+ (NSString*)sdkVersion;

@end

NS_ASSUME_NONNULL_END
