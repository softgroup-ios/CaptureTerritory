//
//  ViewController.m
//  CaptureTerritory
//
//  Created by sxsasha on 4/10/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "ViewController.h"

#import "UserModel.h"
#import "PointLoc.h"
#import "GeoPath.h"

#import "TerritoryManager.h"


@import GoogleMaps;
@import GoogleMapsBase;
@import GoogleMapsCore;


@interface ViewController () <CLLocationManagerDelegate, GMSMapViewDelegate, DrawDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (strong, nonatomic) CLLocationManager* locManager;
@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) CLLocation* previusLocation;

@property (strong, nonatomic) UserModel *testUser;
@property (strong, nonatomic) TerritoryManager *territoryManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _testUser = [UserModel new];
    [self initLocationManager];
    
    self.mapView.delegate = self;
    self.territoryManager = [TerritoryManager sharedManager];
    self.territoryManager.drawDelegate = self;
    
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
    
    PointLoc *point = [[PointLoc alloc] initWithLocation:location];
    [self.territoryManager newPoint:point];
}


@end
