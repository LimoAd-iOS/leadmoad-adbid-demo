//
//  LMNativeMediaView.h
//  LeadmoadAdSDK
//
//  Created by youzhadoubao on 2025/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LMNativeMediaView;
@protocol LMNativeMediaViewDelegate <NSObject>

@optional

/**
 用户点击 MediaView 回调

 @param mediaView 播放器实例
 */
- (void)nativeMediaViewDidClick:(LMNativeMediaView *)mediaView;
/**
 准备播放
 */
- (void)nativeMediaViewReadyToPlay:(LMNativeMediaView *)mediaView;

/**
 播放完成回调

 @param mediaView 播放器实例
 */
- (void)nativeMediaViewDidPlayFinished:(LMNativeMediaView *)mediaView;
/**
 播放失败回调
 */
- (void)nativeMediaView:(LMNativeMediaView *)mediaView didPlayFailWithError:(NSError *_Nullable)error;

@end

@interface LMNativeMediaView : UIView

/**
 MoskenNativeMediaView 回调对象
 */
@property (nonatomic, weak) id<LMNativeMediaViewDelegate> delegate;

/**
 播放视频
 */
- (void)play;

/**
 暂停视频，调用 pause 后，需要被暂停的视频广告对象，不会再自动播放，需要调用 play 才能恢复播放。
 */
- (void)pause;

/**
 停止播放，并展示第一帧
 */
- (void)stop;

/**
 播放静音开关
 @param muted 是否静音
 */
- (void)setMuted:(BOOL)muted;

@end

NS_ASSUME_NONNULL_END
