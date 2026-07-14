//
//  AppConfig.m
//  AdbidSDKDemo
//
//  Created by chaizhiyong on 2026/4/9.
//

#import "AppConfig.h"

NSNotificationName const AppConfigDidChangeNotification = @"AppConfigDidChangeNotification";

@implementation AppConfig
 
static NSString *const kEnvironmentKey = @"kAppEnvironmentKey";

static NSString *const kAppOpenAdSwitchKey = @"kAppOpenAdSwitchKey";

static NSString *const kHotAppOpenAdSwitchKey = @"kHotAppOpenAdSwitchKey";

static NSString *const kSelectedPlatformsKeyPrefix = @"kSelectedPlatformsKey";

static NSString *const kLegacySelectedPlatformsKey = @"flatform";

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
    [[NSNotificationCenter defaultCenter] postNotificationName:AppConfigDidChangeNotification object:nil];
}

#pragma mark - 获取当前环境（从本地读取）
+ (EnvironmentType)currentEnv {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kEnvironmentKey] == nil) {
        return EnvironmentType_Test_10011;
    }
    EnvironmentType env = [[NSUserDefaults standardUserDefaults] integerForKey:kEnvironmentKey];
    switch (env) {
        case EnvironmentType_Test_10011:
            return env;
        default:
            return EnvironmentType_Test_10011;
    }
}

+ (NSString *)currentEnvironmentDisplayText {
    switch ([self currentEnv]) {
        case EnvironmentType_Test_10011:     return @"10011";
        default:                             return @"10011";
    }
}

#pragma mark - 广告平台
+ (NSArray<NSString *> *)availablePlatforms {
    return @[@"LM", @"Ezviz"];
}

+ (NSString *)selectedPlatformsKeyForCurrentEnvironment {
    return [NSString stringWithFormat:@"%@_%ld", kSelectedPlatformsKeyPrefix, (long)[self currentEnv]];
}

+ (NSArray<NSString *> *)defaultPlatformsForCurrentEnvironment {
    switch ([self currentEnv]) {
        case EnvironmentType_Test_10011:
        default:
            return @[];
    }
}

+ (NSArray<NSString *> *)normalizedPlatforms:(NSArray *)platforms {
    NSMutableArray *normalizedPlatforms = [NSMutableArray array];
    NSArray<NSString *> *availablePlatforms = [self availablePlatforms];
    for (id platform in platforms) {
        if (![platform isKindOfClass:[NSString class]]) {
            continue;
        }
        if (![availablePlatforms containsObject:platform]) {
            continue;
        }
        if (![normalizedPlatforms containsObject:platform]) {
            [normalizedPlatforms addObject:platform];
        }
    }
    return [normalizedPlatforms copy];
}

+ (NSArray<NSString *> *)selectedPlatforms {
    NSUserDefaults *ua = [NSUserDefaults standardUserDefaults];
    NSString *selectedPlatformsKey = [self selectedPlatformsKeyForCurrentEnvironment];
    NSArray *savedPlatforms = [ua objectForKey:selectedPlatformsKey];
    if ([savedPlatforms isKindOfClass:[NSArray class]]) {
        return [self normalizedPlatforms:savedPlatforms];
    }

    NSArray *legacyPlatforms = [ua objectForKey:kLegacySelectedPlatformsKey];
    if ([legacyPlatforms isKindOfClass:[NSArray class]]) {
        NSArray<NSString *> *normalizedPlatforms = [self normalizedPlatforms:legacyPlatforms];
        [ua setObject:normalizedPlatforms forKey:selectedPlatformsKey];
        [ua removeObjectForKey:kLegacySelectedPlatformsKey];
        [ua synchronize];
        return normalizedPlatforms;
    }

    return [self defaultPlatformsForCurrentEnvironment];
}

+ (void)saveSelectedPlatforms:(NSArray<NSString *> *)platforms {
    NSArray<NSString *> *normalizedPlatforms = [self normalizedPlatforms:platforms];
    NSUserDefaults *ua = [NSUserDefaults standardUserDefaults];
    [ua setObject:normalizedPlatforms forKey:[self selectedPlatformsKeyForCurrentEnvironment]];
    [ua synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:AppConfigDidChangeNotification object:nil];
}

+ (NSString *)selectedPlatformsDisplayText {
    NSArray<NSString *> *platforms = [self selectedPlatforms];
    if (platforms.count == 0) {
        return @"other";
    }
    return [platforms componentsJoinedByString:@","];
}

+ (NSString *)selectedPlatform {
    NSString *platform = [self selectedPlatforms].firstObject;
    if ([platform isKindOfClass:[NSString class]] && [[self availablePlatforms] containsObject:platform]) {
        return platform;
    }
    return @"other";
}

// MARK: - 配置
+ (NSString *)appID {
    switch ([self currentEnv]) {
        case EnvironmentType_Test_10011:     return @"10011";
        default: return @"10011";
    }
}

+ (NSString *)openID {
    NSString *platform = [self selectedPlatform];
    switch ([self currentEnv]) {
            case EnvironmentType_Test_10011:
                if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3OTI0ODQxNzcxNg=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc3OTcwNjU3MTk2OA=="; // Ezviz
                }
                return @"MTc1MzM0MzU1MzkzOQ==";
             default: return @"MTc1MzM0MzU1MzkzOQ==";
    }
}

+ (NSString *)hotID {
    NSString *platform = [self selectedPlatform];
    switch ([self currentEnv]) {
            case EnvironmentType_Test_10011:
                if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3OTI0ODQxNzcxNg=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc3OTcwNjU3MTk2OA=="; // Ezviz
                }
                return @"MTc1MzM0MzU1MzkzOQ==";
            default: return @"MTc1MzM0MzU1MzkzOQ==";
    }
}

+ (NSString *)rewardID {
    NSString *platform = [self selectedPlatform];
    switch ([self currentEnv]) {
            case EnvironmentType_Test_10011:
                if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3OTI0ODQ3MDQ2OA=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc3OTcwNjU4NDE3NQ=="; // Ezviz
                }
                return @"MTc1MzM0MzU1MzkzOQ==";
            default: return @"MTc1MzM0NDk5OTk3Mw==";
    }
}

+ (NSString *)nativeID {
    NSString *platform = [self selectedPlatform];
    switch ([self currentEnv]) {
            case EnvironmentType_Test_10011:
                if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3OTI0ODQ5MDk5Mw=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc3OTcwNjY1NzEwNw=="; // Ezviz
                }
                return @"MTc1MzM0MzU1MzkzOQ==";
        default: return @"MTc1MzM0NTA2ODIxOA==";
    }
}

+ (NSString *)nativeDrawID {
    NSString *platform = [self selectedPlatform];
    switch ([self currentEnv]) {
            case EnvironmentType_Test_10011:
                if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3OTI0ODUwMzQ2OA=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc3OTcwNjY2OTU5NA=="; // Ezviz
                }
                return @"MTc1MzM0MzU1MzkzOQ==";
            default: return @"MTc1MzM0NTA2ODIxOA==";
    }
}

+ (NSString *)interstitalID {
    NSString *platform = [self selectedPlatform];
    switch ([self currentEnv]) {
            case EnvironmentType_Test_10011:
                if ([platform isEqualToString:@"LM"]) {
                    return @"MTc3OTI0ODQxNzcxNg=="; // LM
                } else if ([platform isEqualToString:@"Ezviz"]) {
                    return @"MTc3OTcwNjU3MTk2OA=="; // Ezviz
                }
                return @"MTc1MzM0MzU1MzkzOQ==";
        default: return @"MTc1MzM0MzU1MzkzOQ==";
    }
}

@end
