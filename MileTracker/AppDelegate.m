//
//  AppDelegate.m
//  MileTracker
//
//  Created by Emanuel on 9/17/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "AppDelegate.h"

#import "TripsViewController.h"

#import "SummaryViewController.h"

#import "SettingsViewController.h"

#import "ReportsViewController.h"

@interface AppDelegate ()

- (UIViewController *)setUpTripsTab;

- (UIViewController *)setUpSummaryTab;

- (UIViewController *)setUpSettingsTab;

- (UIViewController *)setUpReportsTab;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabBarController = [[UITabBarController alloc] init];           //init tab bar 
    self.tabBarController.viewControllers = @[[self setUpTripsTab], [self setUpSummaryTab], [self setUpSettingsTab], [self setUpReportsTab]];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"units"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@" mi" forKey:@"units"];
    }
    
    return YES;
}
  
- (UIViewController *)setUpTripsTab {  //set up each tab with navigation controllers
    UIViewController *viewController = [[TripsViewController alloc] initWithNibName:@"TripsViewController" bundle:nil];
    viewController.tabBarItem.image = [UIImage imageNamed:@"113-navigation"];
    return viewController;
}

- (UIViewController *)setUpSummaryTab {
    UIViewController *viewController = [[SummaryViewController alloc] initWithNibName:@"SummaryViewController" bundle:nil];
    viewController.tabBarItem.image = [UIImage imageNamed:@"81-dashboard"];
    return viewController;
}

- (UIViewController *)setUpSettingsTab {
    UIViewController *viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    viewController.tabBarItem.image = [UIImage imageNamed:@"157-wrench"];
    return viewController;
}

- (UIViewController *)setUpReportsTab {
    UIViewController *viewController = [[ReportsViewController alloc] initWithNibName:@"ReportsViewController" bundle:nil];
    viewController.tabBarItem.image = [UIImage imageNamed:@"179-notepad"];
    return viewController;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
