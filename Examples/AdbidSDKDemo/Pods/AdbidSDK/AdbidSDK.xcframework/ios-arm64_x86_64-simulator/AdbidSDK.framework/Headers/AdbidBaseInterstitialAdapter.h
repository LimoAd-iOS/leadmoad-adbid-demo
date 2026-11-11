//
//  AdbidBaseInterstitialAdapter.h
//  AdbidSDK
//
//  Created by chaizhiyong on 2026/1/21.
//

#import <Foundation/Foundation.h>
#import <AdbidSDK/AdbidInterstitialAdapterProtocol.h>
NS_ASSUME_NONNULL_BEGIN

@interface AdbidBaseInterstitialAdapter : NSObject<AdbidInterstitialAdapterProtocol>

@property (nonatomic, weak) id<AdbidInterstitialAdapterDelegate> adapterDelegate;
@property (nonatomic, assign) NSInteger maxLoadTime;
@property (nonatomic, assign) NSInteger eCPM;
@property (nonatomic, assign) BOOL shouldMuted;///是否静音，默认 NO（非静音）
@property (nonatomic, copy, readonly) NSString *slotId;
@property (nonatomic, copy, readonly) NSString* currentRequestId;
@property (nonatomic, weak, nullable) UIViewController *viewController;
- (instancetype)initWithSlotId:(NSString *)slotId requestId:(NSString*)requestId NS_DESIGNATED_INITIALIZER;
- (void)updateCurrentRequestId:(NSString *)requestId;
- (instancetype)init NS_UNAVAILABLE;

+(BOOL)isExistSDK;

//是否可以显示
- (BOOL)isReady;

@end

NS_ASSUME_NONNULL_END
