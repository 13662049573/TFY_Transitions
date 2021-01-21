//
//  AppDelegate.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "AppDelegate.h"
#import "TFY_PopoverMenuController.h"
#import "TFY_ModalMenuController.h"
#import "TFY_NavTransitionMenuController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    TFY_PopoverMenuController *popoverVC = [TFY_PopoverMenuController new];
    UINavigationController *popoverNav = [[UINavigationController alloc] initWithRootViewController:popoverVC];
    popoverNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"popover"
                                                image:[UIImage imageNamed:@"popover_normal"]
                                        selectedImage:[UIImage imageNamed:@"popover_selected"]];
    popoverVC.navigationItem.title = @"popover";
    
    TFY_ModalMenuController *modalVC = [TFY_ModalMenuController new];
    UINavigationController *modalNav = [[UINavigationController alloc] initWithRootViewController:modalVC];
    modalNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"modal-transition"
                                                          image:[UIImage imageNamed:@"modal_nomal"]
                                                  selectedImage:[UIImage imageNamed:@"modal_selected"]];
    modalVC.navigationItem.title = @"modal-transition";
    
    TFY_NavTransitionMenuController *navVC = [TFY_NavTransitionMenuController new];
    UINavigationController *navNav = [[UINavigationController alloc] initWithRootViewController:navVC];
    navNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"nav-transition"
                                                          image:[UIImage imageNamed:@"nav_t_normal"]
                                                  selectedImage:[UIImage imageNamed:@"nav_t_selected"]];
    navVC.navigationItem.title = @"nav-transition";
                                                                               
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    [tabbarController setViewControllers:@[popoverNav,modalNav,navNav]];
    
    
    self.window.rootViewController = tabbarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}


@end
