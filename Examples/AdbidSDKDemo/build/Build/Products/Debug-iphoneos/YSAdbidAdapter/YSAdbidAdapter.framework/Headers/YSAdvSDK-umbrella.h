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

#import "YSAdvSDKManager.h"
#import "YSAdvSDKExpressFullscreenVideoAdManager.h"
#import "YSAdvSDKSplashView.h"
#import "YSAdvSDKNativeAdsManager.h"
#import "YSAdvSDKMaterialMeta.h"
#import "YSAdvSDKNativeAd.h"
#import "YSAdvSDKNativeAdRelatedView.h"
#import "YSAdvSDKRewardedVideoAdManager.h"
#import "YSAdvSDKRewardedVideoModel.h"
#import "YSAdvSDKExpressFeedAdView.h"
#import "YSAdvSDKExpressFeedAdManager.h"

FOUNDATION_EXPORT double YSAdvSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char YSAdvSDKVersionString[];

