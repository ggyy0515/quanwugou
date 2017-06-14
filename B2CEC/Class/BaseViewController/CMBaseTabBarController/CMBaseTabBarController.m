//
//  CMBaseTabBarController.m
//  TrCommerce
//
//  Created by Tristan on 15/11/3.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import "CMBaseTabBarController.h"
#import "ECHomeViewController.h"
#import "ECMallViewController.h"
#import "ECDesignViewController.h"
#import "ECDecorateViewController.h"
#import "ECMineViewController.h"

@implementation CMBaseTabBarController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadTabbarViewController];
    
}

-(void)loadTabbarViewController{
    self.tabBar.tintColor = TabbarTintColor;
    
    ECHomeViewController *homeVC = [[ECHomeViewController alloc] init];
    homeVC.title = @"资讯";
    homeVC.tabBarItem.image = [UIImage imageNamed:@"TabBar_home_normal"];
    homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"TabBar_home_selected"];
    CMBaseNavigationController *homeNav = [[CMBaseNavigationController alloc] initWithRootViewController:homeVC];
    
    ECMallViewController *mallVC = [[ECMallViewController alloc] init];
    mallVC.title = @"商城";
    mallVC.tabBarItem.image = [UIImage imageNamed:@"TabBar_shop_normal"];
    mallVC.tabBarItem.selectedImage = [UIImage imageNamed:@"TabBar_shop_selected"];
    CMBaseNavigationController *mallNav = [[CMBaseNavigationController alloc] initWithRootViewController:mallVC];
    
    ECDesignViewController *designVC = [[ECDesignViewController alloc] init];
    designVC.title = @"设计";
    designVC.tabBarItem.image = [UIImage imageNamed:@"TabBar_design_normal"];
    designVC.tabBarItem.selectedImage = [UIImage imageNamed:@"TabBar_design_selected"];
    CMBaseNavigationController *designNav = [[CMBaseNavigationController alloc] initWithRootViewController:designVC];
    
    /* 装修模块暂时不开发！！！
    ECDecorateViewController *decorateVC = [[ECDecorateViewController alloc] init];
    decorateVC.title = @"装修";
    decorateVC.tabBarItem.image = [UIImage imageNamed:@"TabBar_decorate_normal"];
    decorateVC.tabBarItem.selectedImage = [UIImage imageNamed:@"TabBar_decorate_selected"];
    CMBaseNavigationController *decorateNav = [[CMBaseNavigationController alloc] initWithRootViewController:decorateVC];
     */
    
    ECMineViewController *mineVC = [[ECMineViewController alloc] init];
    mineVC.title = @"我的";
    mineVC.tabBarItem.image = [UIImage imageNamed:@"TabBar_my_normal"];
    mineVC.tabBarItem.selectedImage = [UIImage imageNamed:@"TabBar_my_selected"];
    CMBaseNavigationController *mineNav = [[CMBaseNavigationController alloc] initWithRootViewController:mineVC];
    
    self.viewControllers = [NSArray arrayWithObjects:homeNav, mallNav, designNav, mineNav, nil];

}


@end
