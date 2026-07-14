//
//  UIView+FLinkAdd.h
//  TestAdA
//
//  Created by lurich on 2021/4/12.
//  Copyright © 2021 . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct FLinkLayoutAnchor {
    NSLayoutYAxisAnchor *top;
    NSLayoutXAxisAnchor *left;
    NSLayoutYAxisAnchor *bottom;
    NSLayoutXAxisAnchor *right;
} FLinkLayoutAnchor;

@interface UIView (FLinkAdd)

@property (assign, nonatomic) CGFloat flink_x;
@property (assign, nonatomic) CGFloat flink_y;
@property (assign, nonatomic, readonly) CGFloat flink_midX;
@property (assign, nonatomic, readonly) CGFloat flink_midY;
@property (assign, nonatomic, readonly) CGFloat flink_maxX;
@property (assign, nonatomic, readonly) CGFloat flink_maxY;
@property (assign, nonatomic) CGFloat flink_width;
@property (assign, nonatomic) CGFloat flink_height;
@property (assign, nonatomic) CGFloat flink_centerX;
@property (assign, nonatomic) CGFloat flink_centerY;
@property (assign, nonatomic) CGSize  flink_size;
@property (assign, nonatomic) CGPoint flink_origin;

- (void)flink_fillSuperView;
- (void)flink_anchorWithView:(UIView *)supview Padding:(UIEdgeInsets)padding;
- (void)flink_anchorWithTop:(NSLayoutYAxisAnchor *)top Left:(NSLayoutXAxisAnchor *)left Bottom:(NSLayoutYAxisAnchor *)bottom Right:(NSLayoutXAxisAnchor *)right;
- (void)flink_anchorWithTop:(NSLayoutYAxisAnchor *)top Left:(NSLayoutXAxisAnchor *)left Bottom:(NSLayoutYAxisAnchor *)bottom Right:(NSLayoutXAxisAnchor *)right Padding:(UIEdgeInsets)padding;
- (void)flink_anchorWithTop:(NSLayoutYAxisAnchor *)top Left:(NSLayoutXAxisAnchor *)left Bottom:(NSLayoutYAxisAnchor *)bottom Right:(NSLayoutXAxisAnchor *)right Padding:(UIEdgeInsets)padding Size:(CGSize)size;
- (void)flink_anchorWithTop:(NSLayoutYAxisAnchor *)top Left:(NSLayoutXAxisAnchor *)left Bottom:(NSLayoutYAxisAnchor *)bottom Right:(NSLayoutXAxisAnchor *)right Padding:(UIEdgeInsets)padding Ratio:(CGFloat)ratio;
- (void)flink_anchorWithSize:(CGSize)size;
- (void)flink_anchorWithLessThanSize:(CGSize)size;
- (void)flink_anchorWithGreaterThanSize:(CGSize)size;
- (void)flink_anchorAnimateChangeWithX:(NSLayoutXAxisAnchor *)centerX Y:(NSLayoutYAxisAnchor *)centerY;
- (void)flink_anchorGreaterThanWithTop:(NSLayoutYAxisAnchor *)top Left:(NSLayoutXAxisAnchor *)left Bottom:(NSLayoutYAxisAnchor *)bottom Right:(NSLayoutXAxisAnchor *)right Padding:(UIEdgeInsets)padding;
- (void)flink_anchorLessThanWithTop:(NSLayoutYAxisAnchor *)top Left:(NSLayoutXAxisAnchor *)left Bottom:(NSLayoutYAxisAnchor *)bottom Right:(NSLayoutXAxisAnchor *)right Padding:(UIEdgeInsets)padding;
- (void)flink_anchorWithMultiplier:(CGFloat)multiplier;
- (void)flink_anchorWithCenterX:(NSLayoutXAxisAnchor *)centerX CenterY:(NSLayoutYAxisAnchor *)centerY Constant:(CGFloat)constant;
/** 获取当前View的控制器对象 */
- (UIViewController *)flink_getCurrentViewController;
// 判断View是否显示在屏幕上
- (BOOL)flink_isDisplayedInScreen;
- (BOOL)isViewCompletelyCoveredBySampling;

@end
