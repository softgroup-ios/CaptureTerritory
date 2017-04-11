//
//  GeoPath.m
//  CaptureTerritory
//
//  Created by sxsasha on 4/11/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "GeoPath.h"

@implementation GeoPath

- (instancetype)init
{
    self = [super init];
    if (self) {
        _points = [NSMutableArray array];
    }
    return self;
}
@end
