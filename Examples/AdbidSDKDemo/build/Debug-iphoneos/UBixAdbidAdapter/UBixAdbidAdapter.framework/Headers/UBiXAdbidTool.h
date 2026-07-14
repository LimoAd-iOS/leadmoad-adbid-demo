//
//  UBixAdbidTool.h
//  UBixAdbidAdapter
//
//  Created by chaizhiyong on 2026/5/22.
//

#import <Foundation/Foundation.h>
#import <UbiXAdSDK/UbiXAdSDK.h>
#import <AdbidSDK/AdbidSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface UBiXAdbidTool : NSObject
+ (NSString*)transPlatform:(AdbidPlatform)platform;
@end

NS_ASSUME_NONNULL_END
