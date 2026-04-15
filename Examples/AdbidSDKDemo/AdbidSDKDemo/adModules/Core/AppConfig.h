//
//  AppConfig.h
//  AdbidSDKDemo
//
//  Created by chaizhiyong on 2026/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


// 环境定义
typedef NS_ENUM(NSInteger, EnvironmentType) {
    EnvironmentType_Test,     // 测试环境
    EnvironmentType_Dev,      // 开发环境
    EnvironmentType_Release  // 正式环境
};

@interface AppConfig : NSObject

@property (nonatomic, assign)BOOL isOpenAppOpenAd;
@property (nonatomic, assign)BOOL isOpenHotAppOpenAd;

+ (instancetype)shared;
// 获取当前环境
+ (EnvironmentType)currentEnv;

+ (void)saveEnvironment:(EnvironmentType)env;

+ (NSString *)appID;
+ (NSString *)openID;
+ (NSString *)hotID;
+ (NSString *)rewardID; //激励
+ (NSString *)nativeID; //自渲染
+ (NSString *)interstitalID;
@end

NS_ASSUME_NONNULL_END
