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

@property (strong, nonatomic) CLLocation *location;
@property (assign, nonatomic) NSTimeInterval timeToPrevious;
@property (assign, nonatomic) CLLocationDistance distanceToPrevious;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLocation:(CLLocation *)location;
@end
