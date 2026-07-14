//
//  LMKYPubSplashDelegate.h
//  LMKYAdSDK
//
//  Created by xuejingwei on 2025/6/17.
//  Copyright © 2025 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LMKYAdSDK/LMKYPublicLoadingDelegate.h>
NS_ASSUME_NONNULL_BEGIN

#pragma mark - Splash
@class LMKYSplashAd;

@protocol LMKYPubSplashDelegate <NSObject>
/// Splash ad displayed successfully
- (void)onAdShow:(LMKYSplashAd *)item;

/// Splash ad click
- (void)onAdClick:(LMKYSplashAd *)item extra:(nullable NSDictionary *)extra;

/// Splash ad closed
- (void)onAdClose:(LMKYSplashAd *)item extra:(nullable NSDictionary *)extra;

@optional
///  Whether the click jump of Splash ad is in the form of Deeplink
- (void)onDeeplinkCallback:(LMKYSplashAd *)item
                    result:(BOOL)success;
/// Splash ad show fail with error
- (void)onAdShowFail:(LMKYSplashAd *)item
               error:(NSError *)error;

@end

@protocol LMKYPubSplashLoadingDelegate <LMKYPublicLoadingDelegate>

/// Callback when the splash ad is loaded successfully
/// @param isTimeout whether timeout
- (void)onAdLoaded:(LMKYSplashAd *)item isTimeout:(BOOL)isTimeout;

/// Splash ad loading timeout callback
- (void)onAdLoadTimeout:(LMKYSplashAd *)item;

@end

NS_ASSUME_NONNULL_END
