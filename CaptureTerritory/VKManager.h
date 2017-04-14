//
//  VKManager.h
//  CaptureTerritory
//
//  Created by Max Ostapchuk on 4/11/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKSdk.h"


@interface VKManager : NSObject <VKSdkDelegate>

+(VKManager*) sharedManager;
-(void)logIn;

@property(assign, nonatomic) BOOL authorized;

@end
