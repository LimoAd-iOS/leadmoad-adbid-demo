//
//  FLinkSplashHitTestView.h
//  FLinkAdSaas
//
//  Created by Lurich on 2023/5/30.
//

#import <UIKit/UIKit.h>
#import <FLinkAdSaas/FLinkAdSaas.h>

//NS_ASSUME_NONNULL_BEGIN

@interface FLinkSplashHitTestView : UIView

@property (nonatomic, weak) FLinkLaunchView *launchView;
@property (nonatomic, weak) FLinkSkipAdButton *skipButton;

@property (nonatomic) CGRect tipFrame;
@property (nonatomic, assign) BOOL frameSet;

- (void)addClickAreaWithView:(UIView *)bottomView restrictedClick:(BOOL)isRes;
- (void)startAnimation;

@end

//NS_ASSUME_NONNULL_END
