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
@property (nonatomic, assign) BOOL shouldMuted;///是否静音，默认是静音
@property (nonatomic, copy, readonly) NSString *slotId;
@property (nonatomic, copy, readonly) NSString* currentRequestId;
@property (nonatomic, strong) UIViewController* viewController;
- (instancetype)initWithSlotId:(NSString *)slotId requestId:(NSString*)requestId NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

+(BOOL)isExistSDK;
@end

NS_ASSUME_NONNULL_END
