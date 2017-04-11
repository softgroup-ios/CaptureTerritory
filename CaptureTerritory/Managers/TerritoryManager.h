//
//  TerritoryManager.h
//  CaptureTerritory
//
//  Created by sxsasha on 4/11/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PointLoc, GMSMutablePath;


@protocol DrawDelegate <NSObject>
- (void)drawPolyline:(GMSMutablePath*)userPath;
- (void)drawPolygonForPath:(GMSMutablePath*)path;
@end

@interface TerritoryManager : NSObject

@property (weak, nonatomic) id <DrawDelegate> drawDelegate;

+ (instancetype)sharedManager;
- (void)newPoint:(PointLoc *)point;

@end
