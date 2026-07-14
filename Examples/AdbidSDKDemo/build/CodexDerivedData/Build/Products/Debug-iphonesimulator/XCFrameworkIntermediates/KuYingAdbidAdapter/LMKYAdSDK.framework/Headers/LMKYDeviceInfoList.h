//
//  LMKYDeviceInfoList.h
//  LMKYAdSDK
//
//  Created by TopOn-0041 on 2025/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMKYDeviceInfoList : NSObject

+ (LMKYDeviceInfoList *)sharedInstance;

@property (nonatomic, copy) NSString *ua;
@property (nonatomic, copy) NSString *os_vn;
@property (nonatomic, copy) NSString *os_vc;
@property (nonatomic, copy) NSString *network_type;
@property (nonatomic, copy) NSString *mnc;
@property (nonatomic, copy) NSString *mcc;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *timezone;
@property (nonatomic, copy) NSString *scale;
@property (nonatomic, copy) NSString *cpu;
@property (nonatomic, copy) NSString *screen;
@property (nonatomic, copy) NSString *bundleID;
@property (nonatomic, copy) NSString *bundleVersion;
@property (nonatomic, copy) NSString *bundleVersionCode;
@property (nonatomic, copy) NSString *LMKYID;//upid
@property (nonatomic, copy) NSString *SYSID;//sy_id
@property (nonatomic, copy) NSString *BKUPID;
@property (nonatomic, strong) NSNumber *screenOrientation;
@property (nonatomic, copy) NSString *bootMark;
@property (nonatomic, copy) NSString *updateMark;
@property (nonatomic, copy) NSString *pddSysU;
@property (nonatomic, copy) NSString *supportHttpValue;
@property (nonatomic, assign) NSInteger systemPlatformType;
@property (nonatomic, assign) NSInteger ATTStatus;
@property (nonatomic, assign) NSInteger sysU;
@property (nonatomic, assign) NSInteger bootTimeInSec;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, assign) NSInteger pil_offset;
@property (nonatomic, strong) NSArray *al_it_apil;
@property (nonatomic, strong) NSDictionary *cached;
@property (nonatomic, copy) NSString *lsaq_scs;
@property (nonatomic, copy) NSString *tc_string;
@property (nonatomic, copy) NSString *addtl_consent;
@property (nonatomic, strong) NSArray *ecpoffer;
@property (nonatomic, copy) NSString *riskTag;
@property (nonatomic, copy) NSString *birth_time;
@property (nonatomic, strong) NSDictionary *wx_data;
@property (nonatomic, copy) NSString *platformVersion;
@property (nonatomic, copy) NSString *tunStatus;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *machine;
@property (nonatomic, copy) NSString *machine_new;
@property (nonatomic, assign) NSInteger mem_total;
@property (nonatomic, assign) NSInteger disk_total;
@property (nonatomic, assign) NSInteger isSimulator;
@property (nonatomic, copy) NSString *simCardStatus;//s_c
@property (nonatomic, copy) NSString *batteryLevelPercentage;//b_p
@property (nonatomic, copy) NSString *idfa;
@property (nonatomic, copy) NSString *idfv;
@property (nonatomic, strong) NSDictionary *fullSKADInfo;

@property (nonatomic, copy) NSString *at_sdk_ver;
@property (nonatomic, strong) NSNumber *platform;

@end


NS_ASSUME_NONNULL_END
