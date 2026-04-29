//
//  HMLaunchController.m
//  AdbidSDKDemo
//
//  Created by chaizhiyong on 2026/4/23.
//

#import "HMLaunchController.h"
#import "AdbidSplashHotAD.h"

@interface HMLaunchController ()

@end

@implementation HMLaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    self.title = @"热启动中";
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = @"热启动中...";
    label.textColor = UIColor.whiteColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
   // 4 秒后自动消失（pop）
    [self performSelector:@selector(popSelf) withObject:nil afterDelay:2.0];
}
- (void)popSelf {
    [self.navigationController popViewControllerAnimated:YES];
    [[AdbidSplashHotAD shared]loadOrShowSplashHotAD];
}

@end
