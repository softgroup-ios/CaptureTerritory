//
//  ViewController.m
//  CaptureTerritory
//
//  Created by sxsasha on 4/10/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "ViewController.h"
#import "UserModel.h"

@import GoogleMaps;
@import GoogleMapsBase;
@import GoogleMapsCore;

@interface ViewController () <CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (nonatomic,strong) CLLocationManager* locManager;
@property (strong, nonatomic) CLLocation* location;

@property (strong, nonatomic) UserModel *testUser;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _testUser = [UserModel new];
    [self initLocationManager];
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

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    [_testUser.userPath addCoordinate:coordinate];
    [self drawPolyline:_testUser.userPath];
}


@end
