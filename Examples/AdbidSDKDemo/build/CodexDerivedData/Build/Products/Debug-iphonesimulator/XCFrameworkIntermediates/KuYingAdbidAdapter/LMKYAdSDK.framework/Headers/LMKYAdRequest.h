//
//  LMKYAdRequest.h
//  LMKYAdSDK
//
//  Created by xuejingwei on 2025/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMKYAdRequest : NSObject

@property (nonatomic, assign) NSInteger adWidth;
@property (nonatomic, assign) NSInteger adHeight;
@property (nonatomic, assign) BOOL bannerRefresh; // Accept banner auto-refresh function, default YES (Server Control)
@property (nonatomic, assign) NSInteger nativeVideoAutoPlay;
@property (nonatomic, assign) BOOL hideSplashCountDownView;
 
@end

NS_ASSUME_NONNULL_END
