//
//  FLinkSplashMaskView.h
//  FLinkAdSaas
//
//  Created by Lurich on 2024/1/3.
//

#import <UIKit/UIKit.h>
#import <FLinkAdSaas/FLinkAdSaas.h>

NS_ASSUME_NONNULL_BEGIN


@protocol FLinkSplashMaskDelegate <NSObject>

@optional
- (void)iphoneSlideBegan:(CGRect)frame;
- (void)iphoneMotionBegan:(CGRect)frame;

@end

@interface FLinkSplashMaskView : UIView

@property (nonatomic, weak) FLinkLaunchView *launchView;
@property (nonatomic, weak) FLinkSkipAdButton *skipButton;

@property (nonatomic, weak) id<FLinkSplashMaskDelegate> delegate;

/// 1 : 有bottomView   0 ：无bottomView
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger sensitivity;
/// 0: 正常 1: 大 2: 超大
@property (nonatomic, assign) NSInteger scale_type;
/// 6: 遮罩 7: 半圆
@property (nonatomic, assign) NSInteger style_type;

- (void)addClickAreaWithView:(UIView *)bottomView restrictedClick:(BOOL)isRes;

@end

NS_ASSUME_NONNULL_END
