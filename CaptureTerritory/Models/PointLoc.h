//
//  Point.h
//  CaptureTerritory
//
//  Created by sxsasha on 4/10/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface PointLoc : NSObject

@property (assign, nonatomic) NSTimeInterval time;
@property (strong, nonatomic) CLLocation *location;

@end
