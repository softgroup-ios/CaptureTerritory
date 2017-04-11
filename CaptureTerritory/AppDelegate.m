//
//  AppDelegate.m
//  CaptureTerritory
//
//  Created by sxsasha on 4/10/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //init GMS SDK with key
    NSString *path = [[NSBundle mainBundle] pathForResource: @"keys" ofType: @"plist"];
    NSString *googleKey =[[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"GoogleApiKey"];
    [GMSServices provideAPIKey:googleKey];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    [navigationController setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:@"ViewController"]]];
    MainViewController *mainViewController = [storyboard instantiateInitialViewController];
    mainViewController.rootViewController = navigationController;
    [mainViewController setup];
    
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = mainViewController;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
