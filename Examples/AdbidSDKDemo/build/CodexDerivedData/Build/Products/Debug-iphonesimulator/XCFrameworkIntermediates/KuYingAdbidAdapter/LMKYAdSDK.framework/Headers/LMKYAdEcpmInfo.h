//
//  LMKYAdEcpmInfo.h
//  LMKYAdSDK
//
//  Created by xuejingwei on 2025/8/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LMKYAdCurrencyType) {
    LMKYAdCurrencyTypeUSD,
    LMKYAdCurrencyTypeCNY,
    LMKYAdCurrencyTypeCNYCents,
};

NS_ASSUME_NONNULL_BEGIN

@interface LMKYAdEcpmInfo : NSObject
/// get ecpm with currency type
- (double)currentEcpm:(LMKYAdCurrencyType)type;
- (NSDecimalNumber *)currentDecimalEcpm:(LMKYAdCurrencyType)type;
/// get revenue with currency type
- (double)currentRevenueEcpm:(LMKYAdCurrencyType)type;
- (NSDecimalNumber *)currentDecimalRevenueEcpm:(LMKYAdCurrencyType)type;

@end

NS_ASSUME_NONNULL_END
