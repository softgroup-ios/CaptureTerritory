//
//  Point.m
//  CaptureTerritory
//
//  Created by sxsasha on 4/10/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "PointLoc.h"


@implementation PointLoc

- (instancetype)initWithLocation:(CLLocation *)location
{
    self = [super init];
    if (self) {
        _location = location;
        _timeToPrevious = 0;
        _distanceToPrevious = 0;
    }
    return self;
}

@end
