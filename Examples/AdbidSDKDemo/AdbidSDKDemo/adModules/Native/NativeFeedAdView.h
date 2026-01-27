//
//  NativeFeedAdView.h
//  LeadMoadAdSDKDemo
//
//  Created by mark zhang  on 2025/10/1.
//

#import <AdbidSDK/AdbidSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface NativeFeedAdView : AdbidNativeView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

NS_ASSUME_NONNULL_END
