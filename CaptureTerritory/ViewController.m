//
//  ViewController.m
//  CaptureTerritory
//
//  Created by sxsasha on 4/10/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

@import GoogleMaps;
@import GoogleMapsBase;
@import GoogleMapsCore;

#import "ViewController.h"
#import "PointLoc.h"





@interface ViewController () <CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (strong, nonatomic) NSMutableArray <PointLoc *>* points;
@property (strong, nonatomic) CLLocationManager* locManager;
@property (strong, nonatomic) CLLocation* location;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLocationManager];
    self.points = [NSMutableArray array];
    self.mapView.delegate = self;
   // self.mapView.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Work with CLLocationManager

-(void) initLocationManager {
    self.locManager = [[CLLocationManager alloc]init];
    self.locManager.distanceFilter = 3;
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
    self.location = location;
    
    NSTimeInterval locationAge = -[location.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    if (location.horizontalAccuracy < 0) return;
    
    [self changeLocation:location];
}

- (void)changeLocation:(CLLocation*)location {
    
    CGFloat widthPoint = [UIApplication sharedApplication].keyWindow.bounds.size.width;
    CGFloat zoom = [GMSCameraPosition zoomAtCoordinate:location.coordinate forMeters:2000 perPoints:widthPoint];
    self.mapView.camera = [[GMSCameraPosition alloc]initWithTarget:location.coordinate zoom:zoom bearing:0 viewingAngle:0];
    
    NSLog(@"changeLocation: %f, %f", location.coordinate.latitude, location.coordinate.longitude);
    
    PointLoc *point = [[PointLoc alloc]init];
    point.location = location;
    point.time = [[NSDate date] timeIntervalSince1970];
    [self addPoint:point];
    [self checkIfPath];
}

- (void)addPoint:(PointLoc*)point {
    if (self.points.count > 1) {
        PointLoc *previousPoint = self.points.lastObject;
        CLLocationDistance distanceToPrevious = [point.location distanceFromLocation:previousPoint.location];
        CLLocationSpeed speed = point.location.speed != -1 ? point.location.speed : distanceToPrevious/(point.time - previousPoint.time);
        if (distanceToPrevious < 200 && speed < 40) {
            NSLog(@"add point");
            [self.points addObject:point];
        }
    }
    else {
        NSLog(@"add init point");
        [self.points addObject:point];
    }
}

- (void)checkIfPath {
    if (self.points.count > 10) {
        PointLoc *lastPoint = self.points.lastObject;
        for (int i = 0; i < self.points.count - 5; i++) {
            PointLoc *point = self.points[i];
            if ([point.location distanceFromLocation:lastPoint.location] < 100) {
                NSLog(@"create path");
                //create path from self.points[i] to lastPoint
            }
        }
    }
}

@end
