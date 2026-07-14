//
//  LMKYSDKGlobalSetting.h
//  LMKYAdSDK
//
//  Created by LMKYAdSDK on 8/23/23.
//  Copyright © 2023 LMKYAdSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <LMKYAdSDK/LMKYAdFormatDefine.h>
#import <LMKYAdSDK/LMKYDebuggerConfig.h>

NS_ASSUME_NONNULL_BEGIN
@class LMKYAntiBrushConfig, LMKYRiskControlModel, LMKYAdCustomFilter;
extern NSString *const kLMKYDeviceDataInfoOSVersionNameKey; //System version name
extern NSString *const kLMKYDeviceDataInfoOSVersionCodeKey; //System version code
extern NSString *const kLMKYDeviceDataInfoPackageNameKey; //Application package name
extern NSString *const kLMKYDeviceDataInfoAppVersionNameKey; //Application version name
extern NSString *const kLMKYDeviceDataInfoAppVersionCodeKey; //Application version code
extern NSString *const kLMKYDeviceDataInfoBrandKey; //Phone brands
extern NSString *const kLMKYDeviceDataInfoCPUKey; //Phone cpu
extern NSString *const kLMKYDeviceDataInfoModelKey; //Phone model
extern NSString *const kLMKYDeviceDataInfoScreenKey; //Screen Resolution
extern NSString *const kLMKYDeviceDataInfoNetworkTypeKey; //Network Type
extern NSString *const kLMKYDeviceDataInfoMNCKey; //Mobile Network Code
extern NSString *const kLMKYDeviceDataInfoMCCKey; //Mobile Country Code
extern NSString *const kLMKYDeviceDataInfoLanguageKey; //Language
extern NSString *const kLMKYDeviceDataInfoTimeZoneKey; //Time zone
extern NSString *const kLMKYDeviceDataInfoUserAgentKey; //User Agent
extern NSString *const kLMKYDeviceDataInfoOrientKey; //Screen orientation
extern NSString *const kLMKYDeviceDataInfoIDFAKey; //idfa
extern NSString *const kLMKYDeviceDataInfoIDFVKey; //idfv
extern NSString *const kLMKYDeviceDataInfoSIMCardStateKey; //sim card status
extern NSString *const kLMKYDeviceDataInfoBatteryKey; //sim card status
extern NSString *const kLMKYDeviceDataInfoSensorDeny; // shake event
extern NSString *const kLMKYDeviceDataInfoGyroscopeDeny; // twist event


typedef NS_ENUM(NSUInteger, LMKYSplashAdClickResultType) {
    LMKYSplashAdClickResultTypeDidCloseAd         = 1,  // After clicking on the jump button, close the splash ad
    LMKYSplashAdClickResultTypePauseCountdown     = 2,  // Pause the countdown after clicking the jump button, and continue the countdown when the splash ad is visible
};

typedef NS_ENUM(NSInteger, LMKYSystemPlatformType) {
    LMKYSystemPlatformTypeUnknown = 0,
    LMKYSystemPlatformTypeIOS = 1,
    LMKYSystemPlatformTypeUnity = 2,
    LMKYSystemPlatformTypeCocos2dx = 3,
    LMKYSystemPlatformTypeCocosCreator = 4,
    LMKYSystemPlatformTypeReactNative = 5,
    LMKYSystemPlatformTypeFlutter = 6,
    LMKYSystemPlatformTypeAdobeAir = 7
};

typedef NS_ENUM(NSUInteger, LMKYDomainServiceType) {
    LMKYDomainServiceTypeDefault = 0,
    LMKYDomainServiceTypeKuying = 1,
    LMKYDomainServiceTypeOnPro = 2,
};

@interface LMKYSDKGlobalSetting : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) NSDictionary *customData;
/// Splash Shake Text String, Only for DirectlyAd
@property (nonatomic, strong) NSString *directlySplashAdShakeTextString;
/// Splash Video Mute Icon hidden, Not hidden by default,  Only for DirectlyAd
@property (nonatomic, assign) BOOL directlySplashAdVideoMuteIconHidden;
/// Whether to pause the countdown after clicking on the  Splash ad to jump, the default is NO, Only for lmkyadsdk ADX、DirectlyAd and Cross Promotion
@property (nonatomic, assign) LMKYSplashAdClickResultType splashAdClickResultType;

/// set header bidding test mode,only support incoming device idfa.
/// setLogEnabled must be turned on before use
@property (nonatomic, strong) NSString *headerBiddingTestModeDeviceID;
/// system platform Information
@property (nonatomic, assign) LMKYSystemPlatformType systemPlatformType;
/// Optional domain service; set before SDK init. Used by LMKYDomainSwitchAdapter when linked.
@property (nonatomic, assign) LMKYDomainServiceType domainServiceType;
/// set whether WX is installed
@property (nonatomic, assign) BOOL isInstallWX;
/// for setLocationLongitude:dimension:
@property (nonatomic, readonly) NSDictionary *locationDictionary;

/// set custom data for the ad placement
/// @param customData - custom data
/// @param placementID - placement id
- (void)setCustomData:(NSDictionary *)customData forPlacementID:(NSString *)placementID;

/// get custom data
- (nullable NSDictionary *)customDataForPlacementID:(NSString *)placementID;

/// set Wechat appID and universalLink, for register WechatOpenSDK
/// @param appID - Wechat appID
/// @param universalLink - Wechat universalLink
- (void)setWeChatAppID:(NSString *)appID universalLink:(NSString *)universalLink;

/// set exlude appleid list for sdk to filter offers
- (void)setExludeAppleIdArray:(NSArray *)appleIdArray;

/// get exlude appleid list
- (NSArray *)exludeAppleIdArray;

/// set denied Upload Info list for sdk to Control report
- (void)setDeniedUploadInfoArray:(NSArray *)uploadInfoArray;

/// get denied Upload Info list
- (NSArray *)deniedUploadInfoArray;

/// Determine whether the Denied key is included
/// @param key - key string
- (BOOL)isContainsForDeniedUploadInfoArray:(NSString *)key;

/// - Parameter isPermit: default YES
- (void)setAbnormalCollect:(BOOL)isPermit;

#pragma mark - Sensor
- (BOOL)isDenySensor;
- (BOOL)isDenySensorWithExtra:(NSDictionary *)extra;
- (void)setDenySensor:(BOOL)isShakeEnabled;
- (void)setDenySensor:(BOOL)isShakeEnabled extra:(NSDictionary *)extra;

#pragma mark - DeviceInfo
/// set location longitude
- (void)setLocationLongitude:(double)longitude dimension:(double)dimension;
- (void)setDebuggerConfig:(void(^_Nullable)(LMKYDebuggerConfig * _Nullable debuggerConfig))debuggerConfigBlock;

@end

NS_ASSUME_NONNULL_END
