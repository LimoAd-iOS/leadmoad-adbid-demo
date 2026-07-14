//
//  AdbidSplashTokenTester.h
//  AdbidSDKDemo
//
//  Created by Codex on 2026/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^AdbidSplashTokenTestCompletion)(BOOL success, NSDictionary *_Nullable config, NSError *_Nullable error);

@interface AdbidSplashTokenTester : NSObject

- (void)getTokenWithAdId:(NSString *)adId sdkInfo:(NSString *_Nullable)sdkInfo completion:(AdbidSplashTokenTestCompletion _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
