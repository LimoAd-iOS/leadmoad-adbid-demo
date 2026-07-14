//
//  FLinkTemplateAdView.h
//  FLinkAdSaas
//
//  Created by Lurich on 2023/7/24.
//

#import <UIKit/UIKit.h>
#import <FLinkAdSaas/FLinkFeedAdData.h>
#import <FLinkAdSaas/FLinkNativeAdRenderProtocol.h>

@interface FLinkTemplateAdView : UIView <FLinkNativeAdRenderProtocol>

@property (nonatomic, strong) UIImageView *adImageView;

- (instancetype)initWithFrame:(CGRect)frame Model:(FLinkFeedAdData *)model Style:(FLinkTemplateStyleOptions)style LRMargin:(CGFloat)left_right_margin TBMargin:(CGFloat)top_bottom_margin;

@end
