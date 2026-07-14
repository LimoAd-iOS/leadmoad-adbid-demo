//
//  LMKYShowConfig.h
//  LMKYAdSDK
//
//  Created by xuejingwei on 2025/8/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LMKYShowConfig : NSObject

@property (nonatomic, readonly) NSString *scene;
@property (nonatomic, readonly) NSString *showCustomExt;
@property (nonatomic, weak) UIViewController *showViewController;
@property (nonatomic, strong) NSDictionary *atAdInfo;

- (instancetype)initWithScene:(nullable NSString *)scene showCustomExt:(nullable NSString *)showCustomExt;

@end

NS_ASSUME_NONNULL_END
