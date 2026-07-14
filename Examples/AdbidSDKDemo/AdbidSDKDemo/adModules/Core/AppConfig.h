//
//  AppConfig.h
//  AdbidSDKDemo
//
//  Created by chaizhiyong on 2026/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName const AppConfigDidChangeNotification;

// 环境定义
typedef NS_ENUM(NSInteger, EnvironmentType) {
    EnvironmentType_Test_10011 = 1,     // 10011测试环境
};

@interface AppConfig : NSObject

@property (nonatomic, assign)BOOL isOpenAppOpenAd;
@property (nonatomic, assign)BOOL isOpenHotAppOpenAd;

+ (instancetype)shared;
// 获取当前环境
+ (EnvironmentType)currentEnv;
+ (NSString *)currentEnvironmentDisplayText;

+ (void)saveEnvironment:(EnvironmentType)env;

+ (NSArray<NSString *> *)availablePlatforms;
+ (NSArray<NSString *> *)selectedPlatforms;
+ (void)saveSelectedPlatforms:(NSArray<NSString *> *)platforms;
+ (NSString *)selectedPlatformsDisplayText;

+ (NSString *)appID;
+ (NSString *)openID;
+ (NSString *)hotID;
+ (NSString *)rewardID; //激励
+ (NSString *)nativeID; //自渲染
+ (NSString *)nativeDrawID;//2级draw
+ (NSString *)interstitalID;
@end

NS_ASSUME_NONNULL_END
