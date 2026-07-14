//
//  FLinkMotionView.h
//  FLinkAdSaas
//
//  Created by lurich on 2022/1/11.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FLinkMotionType) {
    FLinkMotionTypeNormal = 0,
    FLinkMotionTypeSmallImageRight = 4,   //小图
    FLinkMotionTypeSmallImageLeft = 5,   //小图
    FLinkMotionTypeImageOnly = 9    //纯图片
};

@protocol FLinkMotionDelegate <NSObject>

- (void)iphoneMotionBegan:(CGRect)frame; //扭一扭
- (void)iphoneShakeBegan:(CGRect)frame;  //摇一摇

@end

@interface FLinkMotionView : UIView

- (instancetype)initWithFrame:(CGRect)frame isFeed:(BOOL)isFeed Type:(FLinkMotionType)type;

@property (nonatomic, weak) id<FLinkMotionDelegate> delegate;

/// 1 : 有bottomView   0 ：无bottomView
@property (nonatomic, assign) NSInteger type;
/// 1 : 有bottomView   0 ：无bottomView
@property (nonatomic, assign) NSInteger gyroType;

/// 点击图标的frame
@property (nonatomic) CGRect iconframe;
/// 0: 正常 1: 大 2: 超大
@property (nonatomic, assign) NSInteger scale_type;

/// 灵敏度
@property (nonatomic, assign) NSInteger sensitivity;

@property (nonatomic, assign) BOOL isSplash;

/// 开启加速度传感器
- (void)startAccelerometer;
/// 开启陀螺仪传感器
- (void)startAccelerometerGyro;
/// 停止传感器
- (void)stopMotion;

@end

NS_ASSUME_NONNULL_END
