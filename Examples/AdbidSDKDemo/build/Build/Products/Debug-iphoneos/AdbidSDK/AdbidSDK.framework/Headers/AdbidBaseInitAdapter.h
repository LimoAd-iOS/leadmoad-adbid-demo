//
//  AdbidBaseInitAdapter.h
//  AdbidSDK
//
//  Created by chaizhiyong on 2026/5/2.
//

#import <Foundation/Foundation.h>
#import <AdbidSDK/AdibidAdInitArgument.h>
NS_ASSUME_NONNULL_BEGIN

@interface AdbidBaseInitAdapter : NSObject


- (void)initWithInitArgument:(AdibidAdInitArgument *)adInitArgument complete:(void (^__nullable)(BOOL success, NSError *_Nullable error))completion;

+ (nullable NSString *)sdkVersion;

+ (nullable NSString *)adapterVersion;

+ (nullable NSString *)adapterProtocolVersion;

@end

NS_ASSUME_NONNULL_END
