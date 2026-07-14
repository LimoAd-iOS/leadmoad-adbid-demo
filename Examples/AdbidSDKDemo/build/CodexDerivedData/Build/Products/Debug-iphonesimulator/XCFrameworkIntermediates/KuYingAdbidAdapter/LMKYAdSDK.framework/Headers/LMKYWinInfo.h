//
//  LMKYWinInfo.h
//  LMKYAdSDK
//
//  Created by xuejingwei on 2025/8/26.
//

#import <Foundation/Foundation.h>
#import <LMKYAdSDK/LMKYAdEcpmInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMKYWinInfo : NSObject

@property (nonatomic, assign) double secondPrice;
@property (nonatomic, copy) NSString *networkName;
@property (nonatomic, copy) NSDictionary *extraInfo;
@property (nonatomic, assign) LMKYAdCurrencyType currencyType;

@end

NS_ASSUME_NONNULL_END
