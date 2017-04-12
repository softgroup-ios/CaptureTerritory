//
//  AppDelegate.m
//  CaptureTerritory
//
//  Created by sxsasha on 4/10/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
@import GoogleMaps;


#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

#import <string.h>

@interface AppDelegate ()

@property (strong, nonatomic) dispatch_source_t timer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    CLLocationCoordinate2D *coordinates = malloc(sizeof(CLLocationCoordinate2D) * 20);
//    CLLocationCoordinate2D coordinates[20];
//    NSLog(@"sizeOf: %ld", strlen(coordinates));
//    
//    *(coordinates+10) = CLLocationCoordinate2DMake(13, 14);
//    NSLog(@"coordinate: %f, %f", ((CLLocationCoordinate2D)*(coordinates+10)).latitude, ((CLLocationCoordinate2D)*(coordinates+10)).longitude);
//    
//    MKMapView *map;
//    MKPolyline *polyLine;
//    [map addOverlay:polyLine];
//    [map addAnnotation:polyLine];
//    MKAnnotationView *annotation;
//    [map setDelegate:self];
//    
//    
//    NSLog(@"size char:%d, short:%d, int:%d, long:%lu, long long:%d", sizeof(char), sizeof(short), sizeof(int), sizeof(long), sizeof(int64_t));

//    char *string = "Sasha";
//
////    u_long length = strlen(string);
////    char* revertString = malloc(sizeof(char) * length);
////    u_long number = 0;
////    for (u_long i = length; i > 0; --i) {
////        *(revertString+number) = *(string+i);
////        number++;
////    }
//    
//    reversed_string(string);
//    NSLog(@"revertString: %s", string);
    
    
    
//    // revert in Objective-C
//    NSString *string = @"Sasha";
//    
//    NSMutableString *reverted = [NSMutableString string];
//    for (NSInteger i = string.length-1; i >= 0; --i) {
//        [reverted appendString:[string substringWithRange:NSMakeRange(i, 1)]];
//    }
//    NSLog(@"revertString: %@", reverted);
    
    
//    //revert
//    char *string = "Sasha";
//    
//    u_long length = strlen(string);
//    char *reverted = malloc(sizeof(char)*length);
//    
//    u_long i = length - 1;
//    for(int j = 0; j < length; ++j) {
//        reverted[j] = string[i];
//        --i;
//    }
//    NSLog(@"string: %s", string);
//    NSLog(@"reverted: %s", reverted);
//    
//    
//    
//    //postfix prefix
//    int a = 100;
//    
//    int b = a++;
//    int c = ++a;
    
    

//    //semaphore
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    dispatch_async(dispatch_queue_create("ua.com.Selecto.AppDelegate.test", DISPATCH_QUEUE_SERIAL), ^{
//        [NSThread sleepForTimeInterval:10];
//        dispatch_semaphore_signal(semaphore);
//    });
//    
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    //sync
//    dispatch_sync(dispatch_queue_create("ua.com.Selecto.AppDelegate.test", DISPATCH_QUEUE_SERIAL), ^{
//        [NSThread sleepForTimeInterval:10];
//    });
//    NSLog(@"priority: %@", [NSThread currentThread].threadDictionary);
    
    
    //source
//    dispatch_queue_t queue = dispatch_queue_create("com.blah",0);
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC, 2 * NSEC_PER_SEC);
//    dispatch_source_set_event_handler(_timer, ^{
//        NSLog(@"priority: %d", [NSThread isMainThread]);
//    });
//    dispatch_resume(_timer);
    
    
    
    //nsperation
    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    queue.maxConcurrentOperationCount = 3;
    
    NSBlockOperation *blockOpA = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOpA isMainThread: %d", [NSThread isMainThread]);
    }];
    
    NSBlockOperation *blockOpB = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOpB isMainThread: %d", [NSThread isMainThread]);
        [NSThread sleepForTimeInterval:10];
    }];
    //[queue addOperation:blockOp];
    
    [blockOpB start];
    [blockOpA addDependency:blockOpB];
    [blockOpA start];
    
    
    
    
    
    
    
    //init GMS SDK with key
    NSString *path = [[NSBundle mainBundle] pathForResource: @"keys" ofType: @"plist"];
    NSString *googleKey =[[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"GoogleApiKey"];
    [GMSServices provideAPIKey:googleKey];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    [navigationController setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:@"ViewController"]]];
    MainViewController *mainViewController = [storyboard instantiateInitialViewController];
    mainViewController.rootViewController = navigationController;
    [mainViewController setup];
    
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = mainViewController;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
