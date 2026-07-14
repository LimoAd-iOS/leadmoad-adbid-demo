//
//  YSAdvSDKNativeAdRelatedView.h
//  YSAdvSDK
//
//  Created by yanchao on 2026/6/12.
//
//  信息流广告关联视图：封装 videoView / logoView，外部直接使用，
//  避免接入方自建 mediaView 触发 AVVisualAnalysisView 系统识别问题。
//
//  使用方式：
//    1. 广告加载成功后，通过 nativeAd.relatedView 获取本对象
//    2. 调用 refreshWithNativeAd: 绑定数据（内部自动根据来源创建 videoView）
//    3. 将 videoView / logoView 添加到自定义 Cell 布局中
//    4. 通过 playVideo / pauseVideo 控制播放

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YSAdvSDKNativeAd;

#pragma mark - 视频播放回调协议

@protocol YSAdvSDKNativeAdVideoDelegate <NSObject>
@optional

/// 视频开始播放
- (void)ysAdvNativeAdVideoDidStartPlay:(UIView *)videoView;

/// 视频暂停播放
- (void)ysAdvNativeAdVideoDidPause:(UIView *)videoView;

/// 视频继续播放
- (void)ysAdvNativeAdVideoDidResume:(UIView *)videoView;

/// 视频播放进度（秒）
- (void)ysAdvNativeAdVideo:(UIView *)videoView playedTime:(NSInteger)time;

/// 视频播放结束
/// @param error 播放错误信息，正常结束时为 nil
- (void)ysAdvNativeAdVideoDidFinish:(UIView *)videoView withError:(nullable NSError *)error;

@end

#pragma mark - YSAdvSDKNativeAdRelatedView

@interface YSAdvSDKNativeAdRelatedView : NSObject

/**
 * 视频播放器 View（只读）
 * 调用 refreshWithNativeAd: 后生效
 * 遮挡面积不得超过 50%，否则可能影响播放；其子视图不计入遮挡
 */
@property (nonatomic, strong, readonly, nullable) UIView *videoView;

/**
 * 广告主 Logo 视图（只读）
 * 调用 refreshWithNativeAd: 后生效
 */
@property (nonatomic, strong, readonly, nullable) UIImageView *logoView;

/// 视频播放事件回调
@property (nonatomic, weak, nullable) id<YSAdvSDKNativeAdVideoDelegate> videoDelegate;

/**
 * 绑定广告数据，内部根据广告来源创建对应的 videoView
 * @param nativeAd 已加载成功的广告对象
 */
- (void)refreshWithNativeAd:(YSAdvSDKNativeAd *)nativeAd;

/// 播放视频广告（外部控制播放时机）
- (void)playVideo;

/// 暂停视频广告（外部控制暂停时机）
- (void)pauseVideo;

/// 设置视频是否静音（默认静音）
@property (nonatomic, assign) BOOL muted;

/// 停止并释放视频播放器资源（Cell 复用或广告销毁时调用）
- (void)stopAndCleanUp;

@end

NS_ASSUME_NONNULL_END
