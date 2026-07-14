//
//  LMKYPublicLoadingDelegate.h
//  LMKYAdSDK
//
//  Created by xuejingwei on 2025/6/1.
//  Copyright © 2025 LMKYAdSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LMKYBaseAd;
NS_ASSUME_NONNULL_BEGIN

@protocol LMKYPublicLoadingDelegate <NSObject>

/// Callback when the successful loading of the ad
- (void)onAdLoaded:(LMKYBaseAd *)item;

/// Callback of ad loading failure
- (void)onAdLoadFail:(LMKYBaseAd *)item
               error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
