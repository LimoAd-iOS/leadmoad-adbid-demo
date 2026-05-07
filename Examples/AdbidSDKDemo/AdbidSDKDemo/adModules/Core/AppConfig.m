//
//  AppConfig.m
//  AdbidSDKDemo
//
//  Created by chaizhiyong on 2026/4/9.
//

#import "AppConfig.h"

@implementation AppConfig
 
static NSString *const kEnvironmentKey = @"kAppEnvironmentKey";

static NSString *const kAppOpenAdSwitchKey = @"kAppOpenAdSwitchKey";

static NSString *const kHotAppOpenAdSwitchKey = @"kHotAppOpenAdSwitchKey";

#pragma mark - 单例
+ (instancetype)shared {
    static AppConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUserDefaults* ua = [NSUserDefaults standardUserDefaults];
        _isOpenAppOpenAd = [ua boolForKey:kAppOpenAdSwitchKey];
        _isOpenHotAppOpenAd =  [ua boolForKey:kHotAppOpenAdSwitchKey];
    }
    return self;
}

- (void)setIsOpenAppOpenAd:(BOOL)isOpenAppOpenAd{
    _isOpenAppOpenAd = isOpenAppOpenAd;
    NSUserDefaults* ua = [NSUserDefaults standardUserDefaults];
    [ua setBool:isOpenAppOpenAd forKey:kAppOpenAdSwitchKey];
    [ua synchronize];
}

- (void)setIsOpenHotAppOpenAd:(BOOL)isOpenHotAppOpenAd{
    _isOpenHotAppOpenAd = isOpenHotAppOpenAd;
    NSUserDefaults* ua = [NSUserDefaults standardUserDefaults];
    [ua setBool:isOpenHotAppOpenAd forKey:kHotAppOpenAdSwitchKey];
    [ua synchronize];
}

#pragma mark - 保存环境
+ (void)saveEnvironment:(EnvironmentType)env {
    [[NSUserDefaults standardUserDefaults] setInteger:env forKey:kEnvironmentKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取当前环境（从本地读取）
+ (EnvironmentType)currentEnv {
    return EnvironmentType_Test;
    // 如果没有保存过，默认返回测试环境
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kEnvironmentKey] == nil) {
        return EnvironmentType_Test;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:kEnvironmentKey];
}

// MARK: - 配置
+ (NSString *)appID {
    switch ([self currentEnv]) {
        case EnvironmentType_Test:    return @"10004";
        case EnvironmentType_Dev:     return @"";
        case EnvironmentType_Release: return @"";
        default: return @"10011";
    }
}

+ (NSString *)openID {
    switch ([self currentEnv]) {
        case EnvironmentType_Test:    return @"MTc3NTIwNDUzOTAwOA==";
        case EnvironmentType_Dev:     return @"";
        case EnvironmentType_Release: return @"==";
        default: return @"MTc3NjA2NzE4NjM2OA==";
    }
}

+ (NSString *)hotID {
    switch ([self currentEnv]) {
        case EnvironmentType_Test:    return @"MTc3NTIwNDUzOTAwOA==";
        //case EnvironmentType_Test:    return @"MTc3NjA2NzE4NjM2OA==";
        case EnvironmentType_Dev:     return @"";
        case EnvironmentType_Release: return @"";
        default: return @"MTc3NjA2NzE4NjM2OA==";
    }
}

+ (NSString *)rewardID {
    switch ([self currentEnv]) {
        case EnvironmentType_Test:    return @"MTc1MzM0NDk5OTk3Mw==";
        //case EnvironmentType_Test:    return @"MTc3MzM5MDI3NDU2OA==";
        case EnvironmentType_Dev:     return @"";
        case EnvironmentType_Release: return @"";
        default: return @"MTc3MzM5MDI3NDU2OA==";
    }
}

+ (NSString *)nativeID {
    switch ([self currentEnv]) {
        case EnvironmentType_Test:    return @"MTc1MzM0NTA2ODIxOA==";
        case EnvironmentType_Dev:     return @"";
        case EnvironmentType_Release: return @"";
        default: return @"MTc3NjA2NzI1NzIzNQ==";
    }
}

+ (NSString *)interstitalID {
    switch ([self currentEnv]) {
        case EnvironmentType_Test:    return @"MTc1MzM0NDg4NDc3Mg==";
        case EnvironmentType_Dev:     return @"";
        case EnvironmentType_Release: return @"";
        default: return @"";
    }
}

@end
