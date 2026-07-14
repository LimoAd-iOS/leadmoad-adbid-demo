//
//  LMKYBaseAd.h
//  LMKYAdSDK
//
//  Created by xuejingwei on 2025/8/5.
//

#import <Foundation/Foundation.h>
#import <LMKYAdSDK/LMKYPublicLoadingDelegate.h>
#import <LMKYAdSDK/LMKYAdFormatDefine.h>
#import <LMKYAdSDK/LMKYAdRequest.h>
#import <LMKYAdSDK/LMKYAd.h>
#import <LMKYAdSDK/LMKYWinInfo.h>
#import <LMKYAdSDK/LMKYLossInfo.h>

NS_ASSUME_NONNULL_BEGIN

@class UIViewController;

FOUNDATION_EXPORT NSString * const kLMKYS2SAdmPayloadKey;

@interface LMKYBaseAd : NSObject

@property (nonatomic, copy, nullable) NSString *placementId;
@property (nonatomic, strong, nullable) NSDictionary *extra;
@property (nonatomic, weak, nullable) id<LMKYPublicLoadingDelegate> loadDelegate;
@property (nonatomic, weak, nullable) UIViewController *showViewController;
@property (nonatomic, strong, nullable) NSDictionary *adSourceExtra;

@property (nonatomic, strong, nullable) LMKYAdRequest *adRequest;

/// generate params for adx
+ (void)generateHBParamWithExtraDic:(nullable NSDictionary *)extraDic
                             format:(LMKYAdFormat)format
                           complete:(nonnull void(^)(NSDictionary *headerBiddingParams))complete;

+ (void)requestS2SBuyerUidWithPlacementId:(nonnull NSString *)placementId
                                     extra:(nullable NSDictionary *)extra
                                completion:(nonnull void (^)(NSString *_Nullable buyerUid, NSError *_Nullable error))completion;

+ (void)forceCloseAdIfNeeded;

- (instancetype)initAdWithPlacementId:(nonnull NSString *)placementId;

- (instancetype)initAdWithPlacementId:(nonnull NSString *)placementId extra:(nullable NSDictionary *)extra;

- (void)load;

- (void)loadAdWithExtraDic:(nonnull NSDictionary *)ExtraDic;

/// check ads is ready
- (BOOL)isReady;
/// send win
- (void)notifyWin:(LMKYWinInfo *)winInfo;
/// send loss
- (void)notifyLoss:(LMKYLossInfo *)lossInfo;
/// destroy show info
- (void)destroy;
/// ads expired time
- (nullable NSDate *)getExpirationTimestamp;

- (nullable LMKYAd *)getLMKYAd;

@end

NS_ASSUME_NONNULL_END
