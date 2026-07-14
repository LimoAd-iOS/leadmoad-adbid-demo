#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSDictionary+AdbidUBixSafe.h"
#import "UBiXAdAdapterCommonHeader.h"
#import "UBiXAdAdbidInitAdapter.h"
#import "UBiXAdbidTool.h"
#import "AdbidUBiXInterstitialAdapter.h"
#import "AdbidUBiXNativeAdapter.h"
#import "AdbidUBiXRewardVideoAdapter.h"
#import "AdbidUBiXSplashAdapter.h"
#import "UBixAdbidAdapter.h"

FOUNDATION_EXPORT double UBixAdbidAdapterVersionNumber;
FOUNDATION_EXPORT const unsigned char UBixAdbidAdapterVersionString[];

