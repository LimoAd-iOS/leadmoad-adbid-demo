//
//  LMKYDebuggerConfigDefine.h
//  LMKYAdSDK
//
//  Created by GUO PENG on 2022/8/10.
//  Copyright © 2022 LMKYAdSDK. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#pragma mark - NetWorkType
typedef NS_ENUM(NSUInteger, LMKYAdNetWorkType) {
    LMKYAdNetWorkAdxType = 66,
};

#pragma mark - ADX
typedef NS_ENUM(NSUInteger, LMKYADXSplashAdType) {
    LMKYADXSplashAdDefaultType = 0
};

typedef NS_ENUM(NSUInteger, LMKYADXInterstitialAdType) {
    LMKYADXInterstitialAdFullScreenType = 1,
    LMKYADXInterstitialAdHalfScreenType = 2,
};

typedef NS_ENUM(NSUInteger, LMKYADXBannerAdType) {
    LMKYADXBannerAdType_320_50 = 1,
    LMKYADXBannerAdType_320_90 = 2,
    LMKYADXBannerAdType_300_250 = 3,
    LMKYADXBannerAdType_728_90 = 4,
};

typedef NS_ENUM(NSUInteger, LMKYADXNativeAdType) {
    LMKYADXNativeAdTypeExpressLeftPicRightText = 1,
    LMKYADXNativeAdTypeExpressLeftTextRightPic = 2,
    LMKYADXNativeAdTypeExpressTopPicBottomText = 3,
    LMKYADXNativeAdTypeExpressTopTextBottomPic = 4,
    LMKYADXNativeAdTypeExpressTextSuperposedLayer = 5,
    LMKYADXNativeAdTypeSelfRender = 6,
};

NS_ASSUME_NONNULL_END
