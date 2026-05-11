//
//  NativeFeedAdView.m
//  LeadMoadAdSDKDemo
//
//  Created by mark zhang  on 2025/10/1.
//

#import "NativeFeedAdView.h"

@implementation NativeFeedAdView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.descLabel];
        [self addSubview:self.logoImageView];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.accessibilityIdentifier = @"titleLabel_id";
    }
    return _titleLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.accessibilityIdentifier = @"imageView_id";
    }
    return _imageView;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.accessibilityIdentifier = @"descLabel_id";
    }
    return _descLabel;
}

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.accessibilityIdentifier = @"logoImageView_id";
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.clipsToBounds = YES;
        _logoImageView.hidden = YES; // 没拿到 logoUrl 前不占位
    }
    return _logoImageView;
}

@end
