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
@end

NS_ASSUME_NONNULL_END
