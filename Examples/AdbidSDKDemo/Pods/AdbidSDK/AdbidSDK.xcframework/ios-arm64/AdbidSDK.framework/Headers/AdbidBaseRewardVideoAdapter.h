//
//  AdbidBaseRewardVideoAdapter.h
//  AdbidSDK
//
//  Created by chaizhiyong on 2026/1/21.
//

#import <Foundation/Foundation.h>
#import <AdbidSDK/AdbidRewardVideoAdapterProtocol.h>

NS_ASSUME_NONNULL_BEGIN
@interface AdbidBaseRewardVideoAdapter : NSObject<AdbidRewardVideoAdapterProtocol>

@property (nonatomic, weak) id<AdbidRewardVideoAdapterDelegate> adapterDelegate;
@property (nonatomic, assign) NSInteger maxLoadTime;
@property (nonatomic, assign) NSInteger eCPM;
@property (nonatomic, assign) BOOL shouldMuted;///是否静音，默认是静音
@property (nonatomic, copy, readonly) NSString *slotId;

- (instancetype)initWithSlotId:(NSString *)slotId requestId:(NSString*)requestId NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
//是否可以显示
- (BOOL)isReady;

+(BOOL)isExistSDK;

@end

NS_ASSUME_NONNULL_END
