//
//  LMKYSplashAd.h
//  LMKYAdSDK
//
//  Created by xuejingwei on 2025/5/27.
//  Copyright © 2025 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LMKYAdSDK/LMKYBaseAd.h>
#import <LMKYAdSDK/LMKYAdFormatDefine.h>
#import <LMKYAdSDK/LMKYPubSplashDelegate.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMKYSplashAd : LMKYBaseAd

@property (nonatomic, weak, nullable) id<LMKYPubSplashLoadingDelegate> loadDelegate;
@property (nonatomic, weak, nullable) id<LMKYPubSplashDelegate> showDelegate;
@property (nonatomic, weak, nullable) UIView *containerView;
@property (nonatomic, weak) UIWindow *window;
@property (nonatomic, assign) double fetchAdTimeout;

- (void)showAd;

@end

NS_ASSUME_NONNULL_END
