//
//  LoginViewController.m
//  CaptureTerritory
//
//  Created by Max Ostapchuk on 4/11/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "LoginViewController.h"
#import "VkSdk.h"
#import "ViewController.h"
#import "VKManager.h"
#import "GPManager.h"
#import <Google/SignIn.h>

@interface LoginViewController ()  <VKSdkUIDelegate,GIDSignInUIDelegate>


@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    VKSdk *sdkInstance = [VKSdk initializeWithAppId:@"5978037"];
    [sdkInstance setUiDelegate:self];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = [GPManager sharedManager];
}

#pragma mark - LogIn Buttons

- (IBAction)gpLogIn:(id)sender {
    
    [[GIDSignIn sharedInstance] signIn];
}

- (IBAction)vkButtonPress:(id)sender {
    [self performSegueWithIdentifier:@"showMain" sender:nil]; 
    //[[VKManager sharedManager]logIn];
}


#pragma mark - VKSdkUIDelegate

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self];
}

- (void)vkSdkWillDismissViewController:(UIViewController *)controller {
    
}

- (void)vkSdkDidDismissViewController:(UIViewController *)controller {
//    if([VKManager sharedManager].authorized)
//        [self performSegueWithIdentifier:@"showMain" sender:nil];
}

#pragma mark - GIDSignInUIDelegate

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //[_myIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation



@end
