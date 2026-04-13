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
    // 如果没有保存过，默认返回测试环境
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kEnvironmentKey] == nil) {
        return EnvironmentType_Test;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:kEnvironmentKey];
}

// MARK: - 配置
+ (NSString *)appID {
    switch ([self currentEnv]) {
        case EnvironmentType_Dev:     return @"10012";
        case EnvironmentType_Test:    return @"10004";
        case EnvironmentType_Release: return @"10012";
        default: return @"10004";
    }
}

+ (NSString *)openID {
    switch ([self currentEnv]) {
        case EnvironmentType_Dev:     return @"MTc2Nzk0ODYwMTczNw==";
        case EnvironmentType_Test:    return @"MTc1MzM0MzU1MzkzOQ==";
        case EnvironmentType_Release: return @"MTc2Nzk0ODYwMTczNw==";
        default: return @"MTc1MzM0MzU1MzkzOQ==";
    }
}

+ (NSString *)hotID {
    switch ([self currentEnv]) {
        case EnvironmentType_Dev:     return @"MTc3MzA1MDUwNjEzMg==";
        case EnvironmentType_Test:    return @"MTc3NTIwNDUzOTAwOA==";
        case EnvironmentType_Release: return @"MTc3MzA1MDUwNjEzMg==";
        default: return @"MTc3NTIwNDUzOTAwOA==";
    }
}

+ (NSString *)rewardID {
    switch ([self currentEnv]) {
        case EnvironmentType_Dev:     return @"MTc1MzM0NDk5OTk3Mw==";
        case EnvironmentType_Test:    return @"MTc1MzM0NDk5OTk3Mw==";
        case EnvironmentType_Release: return @"MTc1MzM0NDk5OTk3Mw==";
        default: return @"MTc1MzM0NDk5OTk3Mw==";
    }
}

+ (NSString *)nativeID {
    switch ([self currentEnv]) {
        case EnvironmentType_Dev:     return @"MTc1MzM0NTA2ODIxOA==";
        case EnvironmentType_Test:    return @"MTc1MzM0NTA2ODIxOA==";
        case EnvironmentType_Release: return @"MTc1MzM0NTA2ODIxOA==";
        default: return @"MTc1MzM0NTA2ODIxOA==";
    }
}

+ (NSString *)interstitalID {
    switch ([self currentEnv]) {
        case EnvironmentType_Dev:     return @"MTc3NTA0NjYzMzkxNg==";
        case EnvironmentType_Test:    return @"MTc1MzM0NDg4NDc3Mg==";
        case EnvironmentType_Release: return @"MTc3NTA0NjYzMzkxNg==";
        default: return @"MTc1MzM0NDg4NDc3Mg==";
    }
}
@end
