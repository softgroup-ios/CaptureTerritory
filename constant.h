//
//  constants.h
//  Social Bike
//
//  Created by sxsasha on 30.01.17.
//  Copyright © 2017 sasha. All rights reserved.
//

#ifndef constants_h
#define constants_h


// COLOR DATA
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define BLUE_COLOR UIColorFromRGB(0x1DA1F2)

#endif /* constants_h */
