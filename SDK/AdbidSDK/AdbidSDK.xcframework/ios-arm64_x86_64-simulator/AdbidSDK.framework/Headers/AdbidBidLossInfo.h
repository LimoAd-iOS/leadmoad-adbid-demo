#import <Foundation/Foundation.h>
#import <AdbidSDK/AdbidPublicDefine.h>

@interface AdbidBidLossInfo : NSObject

@property (nonatomic, assign) AdbidPlatform winnerPlatform;
@property (nonatomic, assign) NSInteger winnerPrice;

@end
