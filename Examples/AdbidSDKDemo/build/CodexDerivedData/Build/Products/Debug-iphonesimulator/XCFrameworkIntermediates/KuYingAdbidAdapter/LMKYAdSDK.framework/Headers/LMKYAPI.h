//
//  LMKYAPI.h
//  LMKYAdSDK
//
//  Created by Plutus on 09/04/2018.
//  Copyright © 2018 Plutus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <LMKYAdSDK/LMKYDebuggerConfig.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kLMKYADDelegateExtraNetworkFirmIdKey;
extern NSString *const kLMKYADDelegateExtraAdSourceIdKey;
extern NSString *const kLMKYADDelegateExtraIsHeaderBiddingKey;
extern NSString *const kLMKYADDelegateExtraBidModeKey;
extern NSString *const kLMKYADDelegateExtraAdSourcePriceKey;
extern NSString *const kLMKYADDelegateExtraPriorityKey;
extern NSString *const kLMKYADDelegateExtraBidFloorKey;
extern NSString *const kLMKYADDelegateExtraRequestIDKey;
extern NSString *const kLMKYADDelegateExtraCustomExtKey;
extern NSString *const kLMKYADDelegateExtraECPMLevelKey; // the eCPM level of the ad source
extern NSString *const kLMKYADDelegateExtraSegmentIDKey; //segment ID
extern NSString *const kLMKYADDelegateExtraCustomRuleKey; // Json string of the Placement + App dimension custom rule
extern NSString *const kLMKYADDelegateExtraIDKey; // a unique ID generated for each impression
extern NSString *const kLMKYADDelegateExtraAdunitIDKey; // lmkyadsdk placement ID
extern NSString *const kLMKYADDelegateExtraPublisherRevenueKey; // impression revenue
extern NSString *const kLMKYADDelegateExtraCurrencyKey; // currency unit, for example: "USD"
extern NSString *const kLMKYADDelegateExtraCountryKey; // country code, for example: "CN"
extern NSString *const kLMKYADDelegateExtraFormatKey; // ad source types
extern NSString *const kLMKYADDelegateExtraPrecisionKey; // eCPM precision
extern NSString *const kLMKYADDelegateExtraNetworkTypeKey; // Network Type
extern NSString *const kLMKYADDelegateExtraNetworkPlacementIDKey; // the ad placement ID of a third-party Ads Network
extern NSString *const kLMKYADDelegateExtraPlacementRewardNameKey;
extern NSString *const kLMKYADDelegateExtraPlacementRewardNumberKey;
extern NSString *const kLMKYADDelegateExtraExtInfoKey; // additional information of LMKYAdSDK Adx & OnlineAPI Offer,output as Json string
extern NSString *const kLMKYADDelegateExtraOfferIDKey;
extern NSString *const kLMKYADDelegateExtraCreativeIDKey;
extern NSString *const kLMKYADDelegateExtraIsDeeplinkKey;
extern NSString *const kLMKYADDelegateExtraUserCustomData;
extern NSString *const kLMKYADDelegateExtraPlacementTypeKey;
extern NSString *const kLMKYADDelegateExtraNetworkNameKey;
extern NSString *const kLMKYADDelegateExtraTpBidIDKey;
extern NSString *const kLMKYADDelegateExtraABTestIDKey;
extern NSString *const kLMKYADDelegateExtraDismissTypeKey;
extern NSString *const kLMKYADDebuggerKey;
extern NSString *const kLMKYADDelegateExtraServerKeyIdKey;
extern NSString *const kLMKYADDelegateExtraClientSideEcpmKey;
extern NSString *const kLMKYADDelegateExtraUsdExchangeRmbRateKey;
extern NSString *const kLMKYADDelegateExtraRmbExchangeUsdRateKey;
extern NSString *const kLMKYADDelegateExtraADSourceTypeKey;

extern NSString *const kLMKYCustomDataUserIDKey;//string
extern NSString *const kLMKYCustomDataAgeKey;//Integer
extern NSString *const kLMKYCustomDataGenderKey;//Integer
extern NSString *const kLMKYCustomDataNumberOfIAPKey;//Integer
extern NSString *const kLMKYCustomDataIAPAmountKey;//Double
extern NSString *const kLMKYCustomDataIAPCurrencyKey;//string
extern NSString *const kLMKYCustomDataChannelKey;//string
extern NSString *const kLMKYCustomDataSubchannelKey;//string
extern NSString *const kLMKYCustomDataSegmentIDKey;//int

typedef NS_ENUM(NSInteger, LMKYUserLocation) {
    LMKYUserLocationUnknown = 0,
    LMKYUserLocationInEU = 1,
    LMKYUserLocationOutOfEU = 2
};

typedef NS_ENUM(NSInteger, LMKYDataConsentSet) {
    //Let it default to forbidden if not set
    LMKYDataConsentSetUnknown = 0,
    LMKYDataConsentSetPersonalized = 1,
    LMKYDataConsentSetNonpersonalized = 2
};

typedef NS_ENUM(NSInteger, LMKYBUAdLoadType) {
    LMKYBUAdLoadTypeUnknown = -1, // Unknown
    LMKYBUAdLoadTypePreload = 1, // Preload resources
    LMKYBUAdLoadTypeLoad = 3, // Load resources in real time
};

typedef NS_ENUM(NSInteger, LMKYPersonalizedAdState) {
    LMKYPersonalizedAdStateType = 1,
    LMKYNonpersonalizedAdStateType = 2
};

typedef NS_OPTIONS(NSInteger, LMKYLogType) {
    LMKYLogTypeNone = 0,
    LMKYLogTypeInternal = 1 << 0,
    LMKYLogTypeExternal = 1 << 1,
    LMKYLogTypeTemporary = 1 << 2,
    LMKYLogTypeProcess = 1 << 3,
    LMKYLogTypeSave = 1 << 4
};

// Position of the logo icon in the containing ad.
typedef NS_ENUM(NSInteger, LMKYAdLogoPosition) {
    LMKYAdLogoPositionBottomRightCorner = 0,  ///< Bottom right corner.
    LMKYAdLogoPositionBottomLeftCorner,   ///< Bottom Left Corner.
    LMKYAdLogoPositionTopRightCorner,     ///< Top right corner.
    LMKYAdLogoPositionTopLeftCorner,      ///< Top left corner.
};

@interface LMKYAPI : NSObject

@property (nonatomic, readonly) LMKYDataConsentSet dataConsentSet;
@property (nonatomic, readonly) NSString *appID;
@property (nonatomic, readonly) NSString *appKey;

/// singleton object
+ (instancetype)sharedInstance;

/// Log enabled
/// @param logEnabled - log status
+ (void)setLogEnabled:(BOOL)logEnabled;

/// Log enabled
/// @param cacheEnabled log localCache status
+ (void)logLocalCacheEnabled:(BOOL)cacheEnabled;

/// print test info log
/// include idfa,idfv
+ (void)testModeInfo;

/// get SDK version
+ (NSString *)version;

+ (void)preStartWithExtra:(nullable NSDictionary *)extra;

/// Initialize SDK
/// @param appID - appid string
/// @param appKey appkey string
/// @param error - see what's the matter.
- (BOOL)startWithAppID:(NSString *)appID
                appKey:(NSString *)appKey
                 error:(NSError **)error;

/// get ps id
- (nullable NSString *)psID;

- (void)setAdDataConsentSet:(LMKYDataConsentSet)dataConsentSet;

/// set personalized recommendation state
/// @param state - 1 is to close personalized recommendation, other values or not set to open
- (void)setPersonalizedAdState:(LMKYPersonalizedAdState)state;

/// get personalized recommendation state
- (LMKYPersonalizedAdState)getPersonalizedAdState;

NS_ASSUME_NONNULL_END
@end


