//
//  ViewController.h
//  CaptureTerritory
//
//  Created by sxsasha on 4/10/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMSMutablePath;

@interface ViewController : UIViewController

- (void)drawPolyline:(GMSMutablePath*)userPath;
- (void)drawPolygonForPath:(GMSMutablePath*)path;
@end

