//
//  LMKYAdFormatDefine.h
//  LMKYAdSDK
//
//  Created by xuejingwei on 2025/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kLMKYSplashExtraCustomSkipButtonKey; // only supported UIButton

typedef NS_ENUM(NSInteger, LMKYBaseAdInitType) {
    LMKYBaseAdInitTypeMyOffer = 1,
    LMKYBaseAdInitTypeADX,
    LMKYBaseAdInitTypeDirect,
};

typedef NS_ENUM(NSInteger, LMKYAdFormat) {
    LMKYAdFormatNative = 0,
    LMKYAdFormatRewardedVideo = 1,
    LMKYAdFormatBanner = 2,
    LMKYAdFormatInterstitial = 3,
    LMKYAdFormatSplash = 4,
};

typedef NS_ENUM(NSInteger, LMKYNativeAdRenderType) {
    LMKYNativeAdRenderSelfRender = 1,
    LMKYNativeAdRenderExpress = 2,
};

NS_ASSUME_NONNULL_END
