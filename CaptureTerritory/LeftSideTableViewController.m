//
//  LeftSideTableViewController.m
//  CaptureTerritory
//
//  Created by Max Ostapchuk on 4/12/17.
//  Copyright © 2017 sxsasha. All rights reserved.
//

#import "LeftSideTableViewController.h"
#import "LeftViewCell.h"

@interface LeftSideTableViewController ()

@property(strong, nonatomic) NSArray *titles;
@property(strong, nonatomic) NSArray *segues;

@end

@implementation LeftSideTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"Max",@"Map",@"Dash Board",@"Settings",@"LogOut"];
    self.segues = @[@"profile"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.cellTitleLabel.text = self.titles[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:self.segues[indexPath.row] sender:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
