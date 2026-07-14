//
//  FLinkNativeAdRenderProtocol.h
//  FLinkAdSaas
//
//  Created by Lurich on 2024/4/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    FLinkTemplateExpressNativeNormalTheme = 0,     // 默认 普通主题 （一般为背景色透明，按照联盟后台配置）
    FLinkTemplateExpressNativeDarkTheme = 1,       // 黑模式
    FLinkTemplateExpressNativeLightTheme = 2       // 白模式
} FLinkTemplateExpressNativeTheme;

/**
 *  视频播放器状态
 *
 *  播放器只可能处于以下状态中的一种
 */
typedef NS_ENUM(NSUInteger, FLinkMediaPlayerStatus) {
    FLinkMediaPlayerStatusInitial      = 0,    // 初始状态
    FLinkMediaPlayerStatusLoading      = 1,    // 加载中
    FLinkMediaPlayerStatusStarted      = 2,    // 开始播放
    FLinkMediaPlayerStatusPaused       = 3,    // 用户行为导致暂停
    FLinkMediaPlayerStatusError        = 4,    // 播放出错
    FLinkMediaPlayerStatusStoped       = 5,    // 播放停止
    FLinkMediaPlayerStatusPlaying      = 6,    // 播放中
    FLinkMediaPlayerStatusWillStart    = 10,   // 即将播放
};

@protocol FLinkNativeAdRenderProtocol <NSObject>

// 广告主视图
- (UIView *)mainAdView;
// 广告图
- (UIImageView *)mainImageView;
// 可点击view的数组
- (NSArray *)clickViewArray;

@optional

// 广告主名称
- (UILabel *)advertiserLabel;
// 广告标题
- (UILabel *)titleLabel;
// 广告内容
- (UILabel *)contentLabel;
// 广告按钮
- (UILabel *)actionTextLabel;
// 广告评分
- (UILabel *)ratingLabel;
// 广告icon
- (UIImageView *)iconImageView;
// 广告logo
- (UIImageView *)logoImageView;
// 广告视频view
- (UIView *)mediaView;

@end
