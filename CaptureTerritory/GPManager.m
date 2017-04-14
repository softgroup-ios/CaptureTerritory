//
//  GPManager.m
//  CaptureTerritory
//
//  Created by Max Ostapchuk on 4/13/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "GPManager.h"

@implementation GPManager

+(GPManager*)sharedManager{
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^
      {
          sharedInstance = [GPManager new];
      });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [GIDSignIn sharedInstance].delegate = self;
    }
    return self;
}

#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn
  didSignInForUser:(GIDGoogleUser *)user
         withError:(NSError *)error {
    NSLog(@"%@",user.profile.email);
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
}

@end
