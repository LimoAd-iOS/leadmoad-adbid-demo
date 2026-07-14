//
//  LMKYAd.h
//  LMKYAdSDK
//
//  Created by xuejingwei on 2025/8/21.
//  Ads Info

#import <Foundation/Foundation.h>
#import <LMKYAdSDK/LMKYAdEcpmInfo.h>
#import <LMKYAdSDK/LMKYAdPlaceInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMKYAd : NSObject

@property (nonatomic, strong, readonly) LMKYAdEcpmInfo *ecpmInfo;
@property (nonatomic, strong, readonly) LMKYAdPlaceInfo *placementInfo;
@property (nonatomic, copy, readonly) NSDictionary *extraInfo;

@end

NS_ASSUME_NONNULL_END
