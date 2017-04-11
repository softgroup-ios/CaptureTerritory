//
//  GeoPath.h
//  CaptureTerritory
//
//  Created by sxsasha on 4/11/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PointLoc.h"

@class CLLocation;

@interface GeoPath : NSObject
@property (strong, nonatomic) NSMutableArray <PointLoc *> *points;
@property (strong, nonatomic) NSDate *lastTimeUpdate;
@property (assign, nonatomic) CLLocationDistance allDistance;
@end
