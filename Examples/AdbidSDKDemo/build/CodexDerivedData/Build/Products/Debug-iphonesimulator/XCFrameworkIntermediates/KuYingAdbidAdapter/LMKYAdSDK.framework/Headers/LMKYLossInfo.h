//
//  LMKYLossInfo.h
//  LMKYAdSDK
//
//  Created by xuejingwei on 2025/8/26.
//

#import <Foundation/Foundation.h>
#import <LMKYAdSDK/LMKYAdEcpmInfo.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LMKYLossReason) {
    LMKYLossToHigherBid = 0,
    LMKYLossToNormal,
    LMKYLossToAuctionFloor,
    LMKYLossToExpire,
};

@interface LMKYLossInfo : NSObject

@property (nonatomic, assign) LMKYLossReason reason;
@property (nonatomic, assign) double winPrice;
@property (nonatomic, copy) NSString *networkName;
@property (nonatomic, copy) NSDictionary *extraInfo;
@property (nonatomic, assign) LMKYAdCurrencyType currencyType;

@end

NS_ASSUME_NONNULL_END
