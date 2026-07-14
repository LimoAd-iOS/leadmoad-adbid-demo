//
//  LMKYDebuggerConfig.h
//  LMKYAdSDK
//
//  Created by GUO PENG on 2022/8/2.
//  Copyright © 2022 LMKYAdSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LMKYAdSDK/LMKYDebuggerConfigDefine.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMKYDebuggerConfig : NSObject

@property(nonatomic, assign,readonly) BOOL isDebugger;

@property(nonatomic, strong) NSString *deviceIdfaStr;
@property(nonatomic, assign) LMKYAdNetWorkType netWorkType;

#pragma mark - ADX

@property(nonatomic, assign) LMKYADXSplashAdType adx_splashAdType;

@property(nonatomic, assign) LMKYADXInterstitialAdType adx_interstitialAdType;

@property(nonatomic, assign) LMKYADXBannerAdType adx_bannerAdType;

@property(nonatomic, assign) LMKYADXNativeAdType adx_nativeAdType;


#pragma mark - api
- (NSDictionary *)getCurrentNetWorkConfig;




@end

NS_ASSUME_NONNULL_END
