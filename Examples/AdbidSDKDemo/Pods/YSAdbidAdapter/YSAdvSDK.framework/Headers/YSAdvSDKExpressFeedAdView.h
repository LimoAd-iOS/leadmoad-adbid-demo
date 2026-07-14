//
//  YSAdvSDKExpressFeedAdView.h
//  YSAdvSDK
//
//  模版信息流广告展示视图
//  由 YSAdvSDKExpressFeedAdManager 加载成功后返回
//  接入方拿到后设置 delegate/rootViewController，调用 render，然后 addSubview 到 Cell
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YSAdvSDKExpressFeedAdView;

@protocol YSAdvSDKExpressFeedAdViewDelegate <NSObject>

@optional

/// 广告曝光
- (void)expressFeedAdViewDidBecomeVisible:(YSAdvSDKExpressFeedAdView *)adView;

/// 广告被点击
- (void)expressFeedAdViewDidClick:(YSAdvSDKExpressFeedAdView *)adView;

/// 广告关闭（从页面移除）
- (void)expressFeedAdViewDidRemove:(YSAdvSDKExpressFeedAdView *)adView;

/// 广告关闭了其他控制器
- (void)expressFeedAdViewDidCloseOtherController:(YSAdvSDKExpressFeedAdView *)adView
                                 interactionType:(NSInteger)interactionType;

/// 广告不喜欢（需要从列表中移除该 view）
- (void)expressFeedAdView:(YSAdvSDKExpressFeedAdView *)adView
              dislike:(NSArray *)filterWords;

@end


@interface YSAdvSDKExpressFeedAdView : UIView

/// 委托对象
@property (nonatomic, weak) id<YSAdvSDKExpressFeedAdViewDelegate> delegate;

/// 广告展示所在的控制器（用于落地页跳转）
@property (nonatomic, weak) UIViewController *rootViewController;

/// 触发渲染（部分 SDK 需要手动 render，部分 load 成功即已渲染）
- (void)render;

/// 返回的竞价价格
- (double)salePrice;

@end

NS_ASSUME_NONNULL_END
