//
//  UserModel.m
//  CaptureTerritory
//
//  Created by Max Ostapchuk on 4/10/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(instancetype)init{
    self = [super init];
    self.userPath = [GMSMutablePath path];
    return self;
}

@end
