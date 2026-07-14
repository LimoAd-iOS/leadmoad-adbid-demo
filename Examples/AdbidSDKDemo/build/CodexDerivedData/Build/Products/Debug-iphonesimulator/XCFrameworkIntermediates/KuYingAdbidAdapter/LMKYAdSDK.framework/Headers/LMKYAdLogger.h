//
//  LMKYAdLogger.h
//  LMKYAdSDK
//
//  Created by Plutus on 28/04/2018.
//  Copyright © 2018 Plutus. All rights reserved.
//  Logger Tool

#import <Foundation/Foundation.h>
#import <LMKYAdSDK/LMKYAPI.h>

#define LMKYADPublicLogKEY @"publicLog"
#define LMKY_LMKYAdSDKAdTrack @"LMKYAdSDKAdTrack"
#define LMKYNETLog(format, ...) printf("%s\n\n",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])

@interface LMKYAdLogger : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (atomic) BOOL logEnabled;
@property (atomic) BOOL logCacheEnabled;

+ (instancetype)sharedManager;

+ (BOOL)shouldLogType:(LMKYLogType)type;
+ (void)logMessage:(NSString *)message type:(LMKYLogType)type;
+ (void)logWarning:(NSString *)warning type:(LMKYLogType)type;
+ (void)logError:(NSString *)error type:(LMKYLogType)type;
+ (void)logNetworkString:(NSString *)networkString typeString:(NSString *)typeString;
+ (void)logDeviceInfo;

/// for External message
/// @param message pStr
/// @param prefixStr prefix string
+ (void)showExternalLogMessage:(nullable NSString *)message
                     prefixStr:(nullable NSString *)prefixStr;

/// for External warning
/// @param warning pStr
/// @param prefixStr prefix string
+ (void)showExternalLogWarning:(nullable NSString *)warning
                     prefixStr:(nullable NSString *)prefixStr;
NS_ASSUME_NONNULL_END
@end
