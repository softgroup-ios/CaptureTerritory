//
//  VKManager.m
//  CaptureTerritory
//
//  Created by Max Ostapchuk on 4/11/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "VKManager.h"


@interface VKManager ()

@end

@implementation VKManager

+(VKManager*) sharedManager{
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^
    {
        sharedInstance = [VKManager new];
    });
    return sharedInstance;
}

#pragma mark - VkSdkDelegate

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result{
    if(result.state != VKAuthorizationError && result.token){
        _authorized = YES;
    }
    else
    {
        _authorized = NO;
        NSLog(@"%@",result.error.localizedDescription);
    }
}

- (void)vkSdkUserAuthorizationFailed{
    
    _authorized = NO;
}

-(void)logIn{
    [VKSdk forceLogout];
    NSArray *SCOPE = @[@"email"];
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        switch (state) {
            case VKAuthorizationAuthorized:
                _authorized = YES;
                break;
                
            case VKAuthorizationInitialized:
                [VKSdk authorize:SCOPE];
                break;
                
            default:
                // Probably, network error occured, try call +
                [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
                    _authorized = NO;
                }];
                break;
        }
    }];    
}

#pragma mark - User Methods


@end
