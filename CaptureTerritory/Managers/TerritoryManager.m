//
//  TerritoryManager.m
//  CaptureTerritory
//
//  Created by sxsasha on 4/11/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "TerritoryManager.h"
#import "GeoPath.h"
#import "PointLoc.h"
@import GoogleMaps;

@interface TerritoryManager ()
@property (strong, nonatomic) GeoPath *currentPath;
@property (strong, nonatomic) NSMutableSet <GeoPath *>* allPaths;
@property (strong, nonatomic) GMSMutablePath *path;
@end


@implementation TerritoryManager

#pragma mark - Init methods
+ (instancetype)sharedManager {
    static TerritoryManager *shared;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[TerritoryManager alloc] init];
    });
    return shared;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _currentPath = [[GeoPath alloc] init];
        _allPaths = [NSMutableSet set];
        _path = [GMSMutablePath path];
    }
    return self;
}

#pragma mark - API methods

- (void)newPoint:(PointLoc *)point {
    if ([self isPointValid:point forPath:self.currentPath]) {
        [self addPoint:point toPath:self.currentPath];
        self.currentPath.allDistance = self.currentPath.allDistance + point.distanceToPrevious;
    }
    else {
        [self createNewPath];
    }
    
    [self checkIfTerritory:self.currentPath];
}


#pragma mark - Help methods

- (BOOL)isPointValid:(PointLoc *)point forPath:(GeoPath *)path {
    if (path.points.count == 0) {
        return YES;
    }
    
    PointLoc *previousPoint = path.points.lastObject;
    CLLocationDistance distanceToPrevious = [point.location distanceFromLocation:previousPoint.location]; //in meters
    NSTimeInterval time = [point.location.timestamp timeIntervalSinceDate:previousPoint.location.timestamp]; //in sec
    CLLocationSpeed speed = point.location.speed != -1 ? point.location.speed : distanceToPrevious/time; //in m/s
    
    //check
    //if (speed < 100 && distanceToPrevious < 100 && time < 300) {
        point.timeToPrevious = time;
        point.distanceToPrevious = distanceToPrevious;
        return YES;
    //}
   // else {
   //     return NO;
    //}
}

- (void)addPoint:(PointLoc *)point toPath:(GeoPath *)path {
    NSLog(@"add point");
    [path.points addObject:point];
    path.lastTimeUpdate = point.location.timestamp;
    
    //draw line
    [self.path addCoordinate:point.location.coordinate];
    [self.drawDelegate drawPolyline:self.path];
}

- (void)checkIfTerritory:(GeoPath *)path {
    if (path.points.count < 10) {
        return;
    }
    PointLoc *lastPoint = path.points.lastObject;
    
    CLLocationDistance distanceToEnd = path.allDistance;
    for (PointLoc *point in path.points) {
        //PointLoc *point = path.points[i];
        distanceToEnd -= point.distanceToPrevious;
        if (distanceToEnd < 150) {
            break;
        }
        
        CLLocationDistance distanceToPoint = [point.location distanceFromLocation:lastPoint.location];
        NSLog(@"distanceToFirst: %f", distanceToPoint);
        if (distanceToPoint < 100) {
            NSLog(@"CREATE TERRITORY");
            [self createTerritory: [path.points indexOfObject:point]];
            break;
        }
    }
}

- (void)createTerritory:(NSInteger)offset {
    //GMSMutablePath *path = [[GMSMutablePath alloc] init];
    
    NSArray *location = [self.currentPath.points valueForKeyPath:@"@unionOfObjects.location"];
    
    NSInteger count = self.currentPath.points.count;
    location = [location subarrayWithRange:NSMakeRange(offset, count-offset)];
    GMSPath *path = [self fromCLLocationArray:location];

    [self.drawDelegate drawPolygonForPath:path];
    GMSGeometryContainsLocation(<#CLLocationCoordinate2D point#>, <#GMSPath * _Nonnull path#>, NO)
    //GMSGeometryIsLocationOnPathTolerance
    //[self.currentPath.points removeObjectsInRange:NSMakeRange(offset, count - offset)];
}

- (GMSPath *)fromCLLocationArray:(NSArray <CLLocation*> *)locations {
    GMSMutablePath *path = [[GMSMutablePath alloc] init];
    for (CLLocation *loc in locations) {
        [path addCoordinate:loc.coordinate];
    }
    return path;
}

//NOT USING
- (void)checkIfConnectedToAnotherPath {
    PointLoc *lastPoint = self.currentPath.points.lastObject;
    
    NSMutableArray <GeoPath *> *pathsToRemove = [NSMutableArray arrayWithCapacity:self.allPaths.count];
    for (GeoPath *path in self.allPaths) {
        NSTimeInterval old = [path.lastTimeUpdate timeIntervalSinceNow];
        
        //time between now and last point added to path in sec
        if (old > 600) {
            [pathsToRemove addObject:path];
        }
        else {
            if([self checkIfPoint:lastPoint closelyTo:path]) {
                self.currentPath = path;
                break;
            }
        }
    }
    
    for (GeoPath *path in pathsToRemove) {
        [self.allPaths removeObject:path];
    }
}

- (BOOL)checkIfPoint:(PointLoc *)point closelyTo:(GeoPath *)path {
    for (NSInteger i = path.points.count - 1; i > 0; i--) {
        PointLoc *pathPoint = path.points[i];
        
        //time between now and point.location added to path in sec
        if ([pathPoint.location.timestamp timeIntervalSinceNow] > 600) {
            break;
        }
        if ([point.location distanceFromLocation:pathPoint.location] < 100) {
            path.points = [NSMutableArray arrayWithArray:[path.points subarrayWithRange:NSMakeRange(0, i+1)]];
            return YES;
        }
    }
    return NO;
}

- (void)createNewPath {
    //save old path, create new points collection
    NSLog(@"CREATE new points collection");
    
    [self.allPaths addObject:self.currentPath];
    self.currentPath = [[GeoPath alloc] init];
}

@end
