//
//  ViewController.m
//  CaptureTerritory
//
//  Created by sxsasha on 4/10/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "ViewController.h"
#import "UserModel.h"
#import "ViewController.h"
#import "PointLoc.h"
#import "GeoPath.h"


@import GoogleMaps;
@import GoogleMapsBase;
@import GoogleMapsCore;


@interface ViewController () <CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (strong, nonatomic) GeoPath *currentPath;
@property (strong, nonatomic) NSMutableSet <GeoPath *>* allPaths;
@property (strong, nonatomic) CLLocationManager* locManager;
@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) CLLocation* previusLocation;

@property (strong, nonatomic) UserModel *testUser;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _testUser = [UserModel new];
    [self initLocationManager];
    self.mapView.delegate = self;

    //init allpath
    self.currentPath = [[GeoPath alloc] init];
    self.allPaths = [NSMutableSet set];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showChooseController:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Choose" bundle:NSBundle.mainBundle];
    
    UINavigationController *navigationController = [storyboard instantiateInitialViewController];
    
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = navigationController;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

#pragma mark - Drawing shapes

- (void)drawPolyline:(GMSMutablePath*)userPath{

    if(userPath.count > 1){
        CLLocationCoordinate2D lastCoord = [userPath coordinateAtIndex:userPath.count-1];
        CLLocationCoordinate2D firstCoord = [userPath coordinateAtIndex:userPath.count-2];
        GMSMutablePath *pathToDraw = [GMSMutablePath path];
        [pathToDraw addCoordinate:firstCoord];
        [pathToDraw addCoordinate:lastCoord];
        GMSPolyline *way = [GMSPolyline polylineWithPath:pathToDraw];
        way.map = _mapView;
    }
}

- (void)drawPolygonForPath:(GMSMutablePath*)path{
    
    GMSPolygon *polygon = [GMSPolygon polygonWithPath:path];
    polygon.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.5];
    polygon.strokeColor = [UIColor blackColor];
    polygon.strokeWidth = 2;
    polygon.map = _mapView;
}


#pragma mark - Work with CLLocationManager

-(void) initLocationManager {
    self.locManager = [[CLLocationManager alloc]init];
    self.locManager.distanceFilter = 10;
    self.locManager.activityType = CLActivityTypeFitness;
    self.locManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locManager.delegate = self;
    [self.locManager requestAlwaysAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if  ((status == kCLAuthorizationStatusAuthorizedWhenInUse) ||
         (status == kCLAuthorizationStatusAuthorizedAlways)) {
        [self.locManager startUpdatingLocation];
        self.mapView.myLocationEnabled = YES;
        self.mapView.settings.myLocationButton = YES;
    }
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *location = [locations lastObject];
    
    if (![self checkLocationIfValid:location]) {
        return;
    }
    
    [self changeLocationTo:location];
    self.previusLocation = location;
}

- (BOOL)checkLocationIfValid:(CLLocation*)location {
    NSTimeInterval locationAge = -[location.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return NO;
    if (location.horizontalAccuracy < 0) return NO;
    return YES;
}

- (void)changeLocationTo:(CLLocation*)location {
    
    self.location = location;
    NSLog(@"location: %f, %f", location.coordinate.latitude, location.coordinate.longitude);
    
    CGFloat widthPoint = [UIApplication sharedApplication].keyWindow.bounds.size.width;
    CGFloat zoom = [GMSCameraPosition zoomAtCoordinate:location.coordinate forMeters:2000 perPoints:widthPoint];
    self.mapView.camera = [[GMSCameraPosition alloc]initWithTarget:location.coordinate zoom:zoom bearing:0 viewingAngle:0];
    
    PointLoc *point = [[PointLoc alloc]init];
    point.location = location;
    
    if ([self.previusLocation distanceFromLocation:location] < 100) {
        
    }

    [self checkPoint:point];
    [self checkIfTerritory];
}

- (void)checkPoint:(PointLoc*)point {
    
    if (self.currentPath.points.count == 0) {
        [self.currentPath.points addObject:point];
        self.currentPath.lastTimeUpdate = point.location.timestamp;
        return;
    }
    
    PointLoc *previousPoint = self.currentPath.points.lastObject;

    CLLocationSpeed speed;
    if (point.location.speed != -1) {
        speed = point.location.speed;
    }
    else {
        CLLocationDistance distanceToPrevious = [point.location distanceFromLocation:previousPoint.location];
        NSTimeInterval time = [point.location.timestamp timeIntervalSinceDate:previousPoint.location.timestamp];
        speed = distanceToPrevious/time;
    }
    
    //check speed in m/s
    NSLog(@"speed: %f", speed);
    if (speed < 100) { //distanceToPrevious < 200
        NSLog(@"add point");
        
        [self.currentPath.points addObject:point];
        self.currentPath.lastTimeUpdate = point.location.timestamp;
    }
    else {
        //save old path, create new points collection
        NSLog(@"CREATE new points collection");
        
        [self.allPaths addObject:self.currentPath];
        self.currentPath = [[GeoPath alloc] init];
    }
}

- (void)checkIfTerritory {
    if (self.currentPath.points.count < 10) {
        return;
    }
    
    PointLoc *firstPoint = self.currentPath.points.firstObject;
    PointLoc *lastPoint = self.currentPath.points.lastObject;
    
    CLLocationDistance distanceToFirst = [firstPoint.location distanceFromLocation:lastPoint.location];
    
    //distance to first point in path in meters
    NSLog(@"distanceToFirst: %f", distanceToFirst);
    if (distanceToFirst < 300) {
        [self createTerritory:self.currentPath];
        self.currentPath = [[GeoPath alloc] init];
        NSLog(@"CREATE TERRITORY");
    }
}

- (void)createTerritory:(GeoPath*)geoPath {
    GMSMutablePath *path = [[GMSMutablePath alloc] init];
    for (PointLoc *point in geoPath.points) {
        [path addCoordinate:point.location.coordinate];
    }
}

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


@end
