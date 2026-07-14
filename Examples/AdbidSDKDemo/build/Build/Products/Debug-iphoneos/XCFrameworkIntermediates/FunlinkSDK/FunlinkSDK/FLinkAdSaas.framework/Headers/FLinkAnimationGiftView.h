//
//  FLinkAnimationGiftView.h
//  FLinkAdSaas
//
//  Created by Lurich on 2023/5/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FLinkAnimationGiftDelegate <NSObject>

- (void)adImageClick:(UITapGestureRecognizer *)tap;

@end

@interface FLinkAnimationGiftView : UIView

+ (instancetype)createWithDegate:(nullable id<FLinkAnimationGiftDelegate>)delegate;
@property (nonatomic, strong) NSMutableArray *animationViewArray;

- (void)startAnimationWithGesView:(nullable UIView *)gesView;

@end

NS_ASSUME_NONNULL_END
