//
//  LeftViewController.m
//  LGSideMenuControllerDemo
//

#import "LeftViewController.h"
#import "LeftViewCell.h"
#import "MainViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "ViewController.h"

@interface LeftViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // -----

    self.titlesArray = @[@"Profile",
                         @"News",
                         @"Articles",
                         @"Video",
                         @"Music"];

    // -----

    self.tableView.contentInset = UIEdgeInsetsMake(44.0, 0.0, 44.0, 0.0);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.titleLabel.text = self.titlesArray[indexPath.row];
    cell.separatorView.hidden = (indexPath.row <= 3 || indexPath.row == self.titlesArray.count-1);
    cell.userInteractionEnabled = (indexPath.row != 1 && indexPath.row != 3);

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == 1 || indexPath.row == 3) ? 22.0 : 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;

}

@end
