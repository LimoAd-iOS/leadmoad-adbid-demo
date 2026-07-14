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
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    [self configureNavigationController:nav];
    [self addChildVC:nav title:@"首页" image:@"tab_home" selectedImage:@"tab_home_sel"];
    
    // 我的
    AdbidSettingViewController *mineVC = [[AdbidSettingViewController alloc] init];
    UINavigationController* nav2 = [[UINavigationController alloc]initWithRootViewController:mineVC];
    [self configureNavigationController:nav2];
    [self addChildVC:nav2 title:@"我的" image:@"tab_setting" selectedImage:@"tab_setting_sel"];
}

- (void)configureNavigationController:(UINavigationController *)navigationController {
    UIColor *titleColor = [UIColor colorWithRed:0.10 green:0.13 blue:0.18 alpha:1.0];
    UIColor *tintColor = [UIColor colorWithRed:0.18 green:0.48 blue:0.95 alpha:1.0];
    UIColor *separatorColor = [UIColor colorWithWhite:0.90 alpha:1.0];

    navigationController.navigationBar.tintColor = tintColor;
    navigationController.navigationBar.translucent = NO;
    navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage systemImageNamed:@"chevron.left"];

    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor whiteColor];
        appearance.shadowColor = separatorColor;
        appearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: titleColor,
            NSFontAttributeName: [UIFont boldSystemFontOfSize:17]
        };
        appearance.backButtonAppearance.normal.titleTextAttributes = @{
            NSForegroundColorAttributeName: tintColor,
            NSFontAttributeName: [UIFont systemFontOfSize:15 weight:UIFontWeightMedium]
        };
        appearance.backButtonAppearance.highlighted.titleTextAttributes = @{
            NSForegroundColorAttributeName: [tintColor colorWithAlphaComponent:0.55],
            NSFontAttributeName: [UIFont systemFontOfSize:15 weight:UIFontWeightMedium]
        };
        navigationController.navigationBar.standardAppearance = appearance;
        navigationController.navigationBar.scrollEdgeAppearance = appearance;
        navigationController.navigationBar.compactAppearance = appearance;
    } else {
        navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        navigationController.navigationBar.titleTextAttributes = @{
            NSForegroundColorAttributeName: titleColor,
            NSFontAttributeName: [UIFont boldSystemFontOfSize:17]
        };
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]] setTitleTextAttributes:@{
            NSForegroundColorAttributeName: tintColor,
            NSFontAttributeName: [UIFont systemFontOfSize:15 weight:UIFontWeightMedium]
        } forState:UIControlStateNormal];
    }
}

- (void)addChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selImage {
    
    // 设置标题
    vc.title = title;
    // 设置图片
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 添加到 tabBar
    [self addChildViewController:vc];
}


@end
