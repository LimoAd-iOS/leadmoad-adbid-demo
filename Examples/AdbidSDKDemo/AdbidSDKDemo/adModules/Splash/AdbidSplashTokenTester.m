//
//  AdbidSplashTokenTester.m
//  AdbidSDKDemo
//
//  Created by Codex on 2026/7/2.
//

#import "AdbidSplashTokenTester.h"

static NSString * const AdbidSplashTokenTesterErrorDomain = @"com.leadmoad.ad.sdk.error";
static NSString * const AdbidSplashTokenTesterRequestManagerClassName = @"LMAdRequestManager";
static NSString * const AdbidSplashTokenTesterRequestSelectorName = @"requestAdTestToken:adType:timeout:sdkInfo:success:failure:";
static NSInteger const AdbidSplashTokenTesterAdType = 1;
static NSInteger const AdbidSplashTokenTesterTimeout = 10000;

@interface AdbidSplashTokenTester ()

@property (nonatomic, strong, nullable) id requestManager;

@end

@implementation AdbidSplashTokenTester

- (instancetype)init {
    self = [super init];
    if (self) {
        Class requestManagerClass = NSClassFromString(AdbidSplashTokenTesterRequestManagerClassName);
        if (requestManagerClass) {
            _requestManager = [[requestManagerClass alloc] init];
        }
    }
    return self;
}

- (void)getTokenWithAdId:(NSString *)adId sdkInfo:(NSString *_Nullable)sdkInfo completion:(AdbidSplashTokenTestCompletion _Nullable)completion {
    if (adId.length == 0) {
        [self finishWithCompletion:completion
                           success:NO
                            config:nil
                             error:[self errorWithCode:-1 message:@"广告ID为空"]];
        return;
    }
    
    if (!self.requestManager) {
        [self finishWithCompletion:completion
                           success:NO
                            config:nil
                             error:[self errorWithCode:-1 message:@"LMAdRequestManager不可用"]];
        return;
    }
    
    SEL selector = NSSelectorFromString(AdbidSplashTokenTesterRequestSelectorName);
    if (![self.requestManager respondsToSelector:selector]) {
        [self finishWithCompletion:completion
                           success:NO
                            config:nil
                             error:[self errorWithCode:-1 message:@"requestAdTestToken接口不可用"]];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    void (^successBlock)(id responseObject) = [^(id responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        if (![dict isKindOfClass:[NSDictionary class]] || dict.count == 0) {
            [strongSelf finishWithCompletion:completion
                                     success:NO
                                      config:nil
                                       error:[strongSelf errorWithCode:-2 message:@"配置为空"]];
            return;
        }
        
        [strongSelf finishWithCompletion:completion success:YES config:dict error:nil];
    } copy];
    
    void (^failureBlock)(NSError *error) = [^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        [strongSelf finishWithCompletion:completion success:NO config:nil error:error];
    } copy];
    
    typedef NSString *_Nullable (*AdbidSplashTokenRequestIMP)(id target,
                                                              SEL selector,
                                                              NSString *adId,
                                                              NSInteger adType,
                                                              NSInteger timeout,
                                                              NSString *_Nullable sdkInfo,
                                                              id success,
                                                              id failure);
    AdbidSplashTokenRequestIMP requestImp = (AdbidSplashTokenRequestIMP)[self.requestManager methodForSelector:selector];
    requestImp(self.requestManager,
               selector,
               adId,
               AdbidSplashTokenTesterAdType,
               AdbidSplashTokenTesterTimeout,
               sdkInfo,
               successBlock,
               failureBlock);
}

- (void)finishWithCompletion:(AdbidSplashTokenTestCompletion _Nullable)completion
                     success:(BOOL)success
                      config:(NSDictionary *_Nullable)config
                       error:(NSError *_Nullable)error {
    if (completion) {
        completion(success, config, error);
    }
}

- (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:AdbidSplashTokenTesterErrorDomain
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey : message ?: @""}];
}

@end
