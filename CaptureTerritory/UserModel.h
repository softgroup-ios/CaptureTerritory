//
//  UserModel.h
//  CaptureTerritory
//
//  Created by Max Ostapchuk on 4/10/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PointLoc.h"
@import GoogleMaps;

@interface UserModel : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *pass;
@property (nonatomic, strong) NSString *uid;

@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *name;
@property (nonatomic, strong) NSString *photo;
@property (assign, nonatomic) NSInteger *score;

@property (strong, nonatomic) GMSMutablePath *userPath;

@end
