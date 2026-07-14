//
//  FLinkBannerView.h
//  FLinkAdSaasAdapter
//
//  Created by Lurich on 2023/3/28.
//

#import <UIKit/UIKit.h>

@class FLinkFeedAdData,FLinkAdSourcesModel;

NS_ASSUME_NONNULL_BEGIN

@interface FLinkBannerView : UIView

@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong, nullable) FLinkFeedAdData *model;

@end

NS_ASSUME_NONNULL_END
