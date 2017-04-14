//
//  AppDelegate.m
//  CaptureTerritory
//
//  Created by sxsasha on 4/10/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "AppDelegate.h"
#import <VKSdk.h>
#import "VKManager.h"
#import "GPManager.h"
#import <Google/SignIn.h>
@import Firebase;
@import GoogleMaps;

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //init GMS SDK with key
    NSString *path = [[NSBundle mainBundle] pathForResource: @"keys" ofType: @"plist"];
    NSString *googleKey = [[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"GoogleApiKey"];
    [GMSServices provideAPIKey:googleKey];
    
    NSString *VkKey = [[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"VkSdk"];
    VKManager *vkDelegate = [VKManager sharedManager];
    [[VKSdk initializeWithAppId:VkKey] registerDelegate:vkDelegate];
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];

    [GPManager sharedManager];
    [GIDSignIn sharedInstance].clientID = @"639082879652-4kjbn5nhm90akissavjsha866g1o4lk8.apps.googleusercontent.com";
   
    return YES;
}
 
//iOS 8 and lower
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([VKSdk processOpenURL:url fromApplication:sourceApplication]) {
        return YES;
    }
    else if([[GIDSignIn sharedInstance] handleURL:url
                                sourceApplication:sourceApplication
                                       annotation:annotation]){
        return YES;
    }
    
    return NO;
}

//iOS 9 and highter
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    
    if ([VKSdk processOpenURL:url fromApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]]) {
        return YES;
    }
    else if([[GIDSignIn sharedInstance] handleURL:url
                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]){
        return YES;
    }
    
    return NO;
}


@end
