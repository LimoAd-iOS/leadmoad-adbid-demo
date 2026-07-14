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

#import "NSDictionary+AdbidYSSafe.h"
#import "YSAdAdapterCommonHeader.h"
#import "YSAdAdbidInitAdapter.h"
#import "AdbidYSInterstitialAdapter.h"
#import "AdbidYSNativeAdapter.h"
#import "AdbidYSRewardVideAdapter.h"
#import "AdbidYSSplashAdapter.h"
#import "YSAdbidAdapter.h"
#import "YSAdvSDK-umbrella.h"
#import "YSAdvSDKExpressFeedAdManager.h"
#import "YSAdvSDKExpressFeedAdView.h"
#import "YSAdvSDKManager.h"
#import "YSAdvSDKMaterialMeta.h"
#import "YSAdvSDKNativeAd.h"
#import "YSAdvSDKNativeAdRelatedView.h"
#import "YSAdvSDKNativeAdsManager.h"
#import "YSAdvSDKRewardedVideoAdManager.h"
#import "YSAdvSDKRewardedVideoModel.h"
#import "YSAdvSDKSplashView.h"

FOUNDATION_EXPORT double YSAdbidAdapterVersionNumber;
FOUNDATION_EXPORT const unsigned char YSAdbidAdapterVersionString[];

