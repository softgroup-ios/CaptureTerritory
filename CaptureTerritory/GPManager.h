//
//  GPManager.h
//  CaptureTerritory
//
//  Created by Max Ostapchuk on 4/13/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google/SignIn.h>

@interface GPManager : NSObject <GIDSignInDelegate>

+(GPManager*)sharedManager;

@end
