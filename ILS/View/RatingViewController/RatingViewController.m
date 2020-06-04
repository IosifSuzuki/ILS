//
//  RatingViewController.m
//  ILS
//
//  Created by admin on 29.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//
#import <MapKit/MapKit.h>

#import "RatingViewController.h"

#import "AppSupportClass.h"

#import "RatingPresenter.h"

#import "LoaderView.h"

#import "UserTableViewCell.h"

typedef NS_ENUM(NSInteger, RatingTypeSegmentControl) {
    TotalRatingTypeSegmentControl,
    TodayRatingTypeSegmentControl,
};

@interface RatingViewController () <RatingDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentRatingTypeControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *viewOnMapButton;

@property (strong, nonatomic) RatingPresenter *presenter;

@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    [self setupViewController];
}


#pragma mark - Private

- (void)prepareUI {
    self.viewOnMapButton.layer.cornerRadius = ILS_CornerRadius;
    self.viewOnMapButton.clipsToBounds = YES;
}

- (void)setupViewController {
    self.presenter = [[RatingPresenter alloc] initWithDelegate:self];
    self.title = self.presenter.titleText;
    
    [self.segmentRatingTypeControl setTitle:self.presenter.totalRaitingText forSegmentAtIndex:TotalRatingTypeSegmentControl];
    [self.segmentRatingTypeControl setTitle:self.presenter.todayRaitingText forSegmentAtIndex:TodayRatingTypeSegmentControl];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self registerTableViewCell];
    [self fetchDataForRatingTypeSegmentControl:TotalRatingTypeSegmentControl];
}

- (void)registerTableViewCell {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserTableViewCell class]) bundle:nil] forCellReuseIdentifier:UserTableViewCell.identifierUserTableViewCell];
}

- (void)fetchDataForRatingTypeSegmentControl:(RatingTypeSegmentControl)segmentControllType {
    [self.presenter fetchUserWithType:(RatingType)segmentControllType];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.presenter numberOfUsers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserTableViewCell.identifierUserTableViewCell];
    [self.presenter prepareCell:cell withIndex:indexPath.row withRatingType:(RatingType)self.segmentRatingTypeControl.selectedSegmentIndex];
    
    return cell;
}

#pragma mark - Action

- (IBAction)changeStateOnSegmentControll:(UISegmentedControl *)segmentControll {
    [self fetchDataForRatingTypeSegmentControl:(RatingTypeSegmentControl)segmentControll.selectedSegmentIndex];
}

- (IBAction)tapToViewRatingOnMapButton:(UIButton *)button {
    
}

#pragma mark - Override

- (BOOL)showMenuBarButtonItem {
    return YES;
}

#pragma mark - RatingDelegate

- (void)startAnimation {
    [[LoaderView sharedInstance] startAnimationFromView:self.view];
}

- (void)stopAnimation {
    [[LoaderView sharedInstance] stopAnimation];
}

- (void)reloadData {
    [self.tableView reloadData];
}

@end
