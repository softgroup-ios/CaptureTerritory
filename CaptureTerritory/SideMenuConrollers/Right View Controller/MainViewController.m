//
//  MainViewController.m
//  LGSideMenuControllerDemo
//

#import "MainViewController.h"
#import "ViewController.h"
#import "LeftViewController.h"

@interface MainViewController ()

@property (assign, nonatomic) NSUInteger type;

@end

@implementation MainViewController

- (void)setup{

    if (self.storyboard) {
        // Left and Right view controllers is set in storyboard
        // Use custom segues with class "LGSideMenuSegue" and identifiers "left" and "right"

        // Sizes and styles is set in storybord
        // You can also find there all other properties

        // LGSideMenuController fully customizable from storyboard
    }
    else {
        self.leftViewController = [LeftViewController new];

        self.leftViewWidth = 250.0;
        self.leftViewBackgroundColor = [UIColor colorWithRed:0.5 green:0.65 blue:0.5 alpha:0.95];
        self.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.05];
    }

    UIBlurEffectStyle regularStyle;
    UIColor *greenCoverColor = [UIColor colorWithRed:0.0 green:0.1 blue:0.0 alpha:0.3];
    if (UIDevice.currentDevice.systemVersion.floatValue >= 10.0) {
        regularStyle = UIBlurEffectStyleRegular;
    }
    else {
        regularStyle = UIBlurEffectStyleLight;
    }
    
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    self.rootViewCoverColorForLeftView = greenCoverColor;
}

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super leftViewWillLayoutSubviewsWithSize:size];

    if (!self.isLeftViewStatusBarHidden) {
        self.leftView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
}

- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super rightViewWillLayoutSubviewsWithSize:size];

    if (!self.isRightViewStatusBarHidden ||
        (self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape &&
         UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
         UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation))) {
        self.rightView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
}

- (BOOL)isLeftViewStatusBarHidden {
    if (self.type == 8) {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    }

    return super.isLeftViewStatusBarHidden;
}

- (BOOL)isRightViewStatusBarHidden {
    if (self.type == 8) {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    }

    return super.isRightViewStatusBarHidden;
}

- (void)dealloc {
    NSLog(@"MainViewController deallocated");
}

@end
