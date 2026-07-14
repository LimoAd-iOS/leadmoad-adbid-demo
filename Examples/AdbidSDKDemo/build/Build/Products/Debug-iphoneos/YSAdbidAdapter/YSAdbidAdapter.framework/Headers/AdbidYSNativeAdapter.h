//
//  AdbidYSSplashAdapter.h
//  AdbidSDK
//
//  Created by chaizhiyong on 2026/1/21.
//

#import "AdbidBaseNativeAdapter.h"

NS_ASSUME_NONNULL_BEGIN
@interface _YSAdProxy : UIView
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIImageView *mainImageView;
@property (nonatomic, weak) NSArray *clickViews;
@end

@interface AdbidYSNativeAdapter : AdbidBaseNativeAdapter

@end

NS_ASSUME_NONNULL_END
