//
//  FLinkInterstitialView.h
//  FLinkAdSaas
//
//  Created by lurich on 2021/10/12.
//

#import <UIKit/UIKit.h>
#import <FLinkAdSaas/FLinkSkipAdButton.h>

@class FLinkFeedAdData,FLinkAdSourcesModel;

NS_ASSUME_NONNULL_BEGIN

@interface FLinkInterstitialView : UIView

@property (nonatomic, copy) NSString *html;

@property (nonatomic, copy) void(^clickBlock)(NSString *url);

@property (nonatomic) CGRect adFrame;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, weak, nullable) FLinkAdSourcesModel *adModel;

@property (nonatomic, assign) double currentTime;

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIView *buttonView;

@property (nonatomic, strong, nullable) FLinkFeedAdData *model;

@property (nonatomic, assign) CGFloat topY;

@property (nonatomic, assign) NSInteger hotspot_type;

-(void)startGCDTimer;

@property (nonatomic, copy) void(^cloaseBlock)(void);

@property (nonatomic, strong) FLinkSkipAdButton *timeBtn;

@property (nonatomic, strong) UIImageView *topImgView;

@property (nonatomic, assign) NSInteger agreement;

-(void) destoryYaoYiYaoView;

@end

NS_ASSUME_NONNULL_END
