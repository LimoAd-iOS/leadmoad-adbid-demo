//
//  AdbidTabBarViewController.m
//  AdbidSDKDemo
//
//  Created by chaizhiyong on 2026/4/9.
//

#import "AdbidTabBarViewController.h"
#import "AdbidHomeViewController.h"
#import "AdbidSettingViewController.h"

@interface AdbidTabBarViewController ()

@end

@implementation AdbidTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBarStyle];
    [self setupChildViewControllers];
}

- (void)setupTabBarStyle {
    self.tabBar.translucent = NO; // 关闭半透明
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor colorWithRed:66/255.0 green:133/255.0 blue:244/255.0 alpha:1.0]; // 选中颜色
    self.tabBar.unselectedItemTintColor = [UIColor grayColor]; // 未选中颜色
}

- (void)setupChildViewControllers {
    // 首页
    AdbidHomeViewController *homeVC = [[AdbidHomeViewController alloc] init];
    [self addChildVC:homeVC title:@"首页" image:@"tab_home" selectedImage:@"tab_home_sel"];
    
    // 我的
    AdbidSettingViewController *mineVC = [[AdbidSettingViewController alloc] init];
    [self addChildVC:mineVC title:@"我的" image:@"tab_setting" selectedImage:@"tab_setting_sel"];
}

- (void)addChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selImage {
    // 设置标题
    vc.title = title;
    // 设置图片
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 包装导航栏
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  //  nav.navigationBar.tintColor = [UIColor whiteColor]; // 按钮白色
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = [UIColor colorWithRed:66/255.0 green:133/255.0 blue:244/255.0 alpha:1.0]; // 导航背景色（可自己改）
        appearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor whiteColor] // 标题白色
        };
//        nav.navigationBar.standardAppearance = appearance;
//        nav.navigationBar.scrollEdgeAppearance = appearance;
    }
    // 添加到 tabBar
    [self addChildViewController:vc];
}


@end
