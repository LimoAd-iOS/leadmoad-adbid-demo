//
//  FLinkVideoConfig.h
//  FLinkAdSaas
//
//  Created by lurich on 2021/10/27.
//

#import <Foundation/Foundation.h>
#import "FLinkFeedAdData.h"

/// 视频声音控制宏
#define FLinkAdSaasVideoMuteEnable      @"FLinkAdSaasVideoMuteEnable"
/// 视频播放控制宏
#define FLinkAdSaasVideoPlayEnable      @"FLinkAdSaasVideoPlayEnable"
/// 获取 BOOL 值的Key
#define FLinkAdSaasVideoEnableSwitchKey @"FLinkAdSaasVideoEnableSwitchKey"


/// 释放指定播放器的Key（广告类请求ID）
#define FLinkAdSaasVideoFreePlayerKey   @"FLinkAdSaasVideoFreePlayerKey"
/// 释放视频播放器
#define FLinkAdSaasVideoFreePlayerName  @"FLinkAdSaasVideoFreePlayerName"

typedef NS_ENUM(NSInteger, FLinkVideoAutoPlayPolicy) {
    FLinkVideoAutoPlayPolicyWIFI   = 0, // WIFI 下自动播放
    FLinkVideoAutoPlayPolicyAlways = 1, // 总是自动播放，无论网络条件
    FLinkVideoAutoPlayPolicyNever  = 2, // 从不自动播放，无论网络条件
};

typedef enum : NSUInteger {
    FLinkVideoStatusNull,      //url无效
    FLinkVideoStatusLocation,  //本地已缓存
    FLinkVideoStatusPreload,   //待缓存
} FLinkVideoCacheStatus;

NS_ASSUME_NONNULL_BEGIN

@interface FLinkVideoConfig : NSObject

/**
 *  视频自动播放策略，默认 FLinkVideoAutoPlayPolicyAlways,
 *  选择 FLinkVideoAutoPlayPolicyNever 策略时，需要开发者手动控制视频播放/暂停
 *
 *  播放控制 FLinkAdSaasVideoPlayEnable  YES：播放； NO：暂停
 *  [[NSNotificationCenter defaultCenter] postNotificationName:FLinkAdSaasVideoPlayEnable object:nil userInfo:@{FLinkAdSaasVideoEnableSwitchKey:@(status)}];
 */
@property (nonatomic, assign) FLinkVideoAutoPlayPolicy autoPlayPolicy;

/**
 *  自动播放时，是否静音。默认 YES。loadAd 前设置。
 *
 *  声音实时控制 FLinkAdSaasVideoMuteEnable  YES：静音； NO：有声
 *  [[NSNotificationCenter defaultCenter] postNotificationName:FLinkAdSaasVideoMuteEnable object:nil userInfo:@{FLinkAdSaasVideoEnableSwitchKey:@(status)}];
 */
@property (nonatomic, assign) BOOL videoMuted;

/**
 *  由SDK控制视频是否静音。 默认NO
 * */
@property (nonatomic, assign) BOOL isVideoMutedConfig;

/**
 *  是否循环播放视频广告，默认YES
 * */
@property (nonatomic, assign) BOOL replay;

/**
 *  sdk渲染全屏视频
 * */
-(void) renderFullScreenVideoWithUrl: (FLinkFeedAdData *) adData completeBlock: (void(^)(BOOL result)) completeBlock;

@end

NS_ASSUME_NONNULL_END
