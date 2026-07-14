//
//  LMKYAdPlaceInfo.h
//  LMKYAdSDK
//
//  Created by xuejingwei on 2025/8/21.
//

#import <Foundation/Foundation.h>
#import <LMKYAdSDK/LMKYAdFormatDefine.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMKYAdPlaceInfo : NSObject

@property (nonatomic, copy, readonly) NSString *placementId;
@property (nonatomic, copy, readonly) NSString *requestId;
@property (nonatomic, assign, readonly) LMKYAdFormat format;

@end

NS_ASSUME_NONNULL_END
