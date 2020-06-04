//
//  ProfilePresenter.m
//  ILS
//
//  Created by admin on 15.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ProfilePresenter.h"

#import "CoreDataManager.h"
#import "FirebaseManager.h"

#import "UserModel.h"
#import "StatisticModel.h"

static NSString *const kProfilePresenterTitle = @"title";
static NSString *const kProfilePresenterNoSelectedText = @"noSelected";
static NSString *const kProfilePresenterEmail = @"email";
static NSString *const kProfilePresenterYourRegionText = @"yourRegion";
static NSString *const kProfilePresenterChooseOption = @"chooseOption";
static NSString *const kProfilePresenterCameraSource = @"cameraSource";
static NSString *const kProfilePresenterPhotoLibrarySource = @"photoLibrarySource";
static NSString *const kProfilePresenterSelectOptionPhotoSource = @"selectOptionPhotoSource";
static NSString *const kProfilePresenterBack = @"back";

@interface ProfilePresenter()

@property (weak, nonatomic) id<ProfileDelegate> delegate;
@property (strong, nonatomic) NSArray<NSString *> *dataSourceOfRegions;
@property (strong, nonatomic) UserModel *userModel;
@property (strong, nonatomic) StatisticModel *statisticModel;

@end

@implementation ProfilePresenter

- (instancetype)initWithDelegate:(id<ProfileDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        
        [self setupPresenter];
    }
    return self;
}

#pragma mark - Private

- (void)setupPresenter {
    [self fetchScreenData];
    [self fetchRegionData];
    [self fetchUserData];
}

- (void)fetchScreenData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Profile" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.cameraText = [data objectForKey:kProfilePresenterCameraSource];
    self.photoLibraryText = [data objectForKey:kProfilePresenterPhotoLibrarySource];
    self.titleText = [data objectForKey:kProfilePresenterTitle];
    self.noSelectedText = [data objectForKey:kProfilePresenterNoSelectedText];
    self.emailText = [data objectForKey:kProfilePresenterEmail];
    self.yourRegionText = [data objectForKey:kProfilePresenterYourRegionText];
    self.backText = [data objectForKey:kProfilePresenterBack];
    self.selectOptionForPhtotoSourceText = [data objectForKey:kProfilePresenterSelectOptionPhotoSource];
}

- (void)fetchRegionData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"regions" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableArray<NSString *> *regions = [[[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectForKey:@"regions"] mutableCopy];
    [regions insertObject:self.noSelectedText atIndex:0];
    self.dataSourceOfRegions = [regions copy];
}

- (void)fetchUserData {
    self.userModel = [[CoreDataManager sharedManager] userModel];
    self.selectedRegion = [self.dataSourceOfRegions indexOfObject:self.userModel.regionName];
}

#pragma mark - Public

- (NSInteger)numberOfRegion {
    return self.dataSourceOfRegions.count;
}

- (NSString *)regionWithIndex:(NSInteger)index {
    return [self.dataSourceOfRegions objectAtIndex:index];
}

- (NSString *)getRegion:(NSString *)region {
    if ([region isEqualToString:@"nil"]) {
        self.selectedRegion = 0;
        return self.noSelectedText;
    }
    return region;
}

- (NSURL *)getIconPhotoURL:(NSString *)photoURL {
    if ([photoURL isEqualToString:@"nil"]) {
        return nil;
    }
    return [NSURL URLWithString:photoURL];
}

- (void)updateChart {
    self.statisticModel = [[StatisticModel alloc] initWithUser:self.userModel];
    self.valuesForStatistic = @[
        @(self.statisticModel.day4AgoBalls),
        @(self.statisticModel.day3AgoBalls),
        @(self.statisticModel.day2AgoBalls),
        @(self.statisticModel.day1AgoBalls),
        @(self.statisticModel.todayBalls),
    ];
}

- (void)getUserIcon {
    [[FirebaseManager sharedManager] getIconUserWithUserId:self.userModel.userId withCompletionBlock:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate updateProfileIconWithData:data];
        });
    }];
}

- (void)updateIconPhotoWithURL:(NSString *)iconPhotoURL {
    NSURL *photoURL = [self getIconPhotoURL:iconPhotoURL];
    if (photoURL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:photoURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate updateProfileIconWithData:data];
            });
        });
    }
}

- (void)updateUserProfile {
    __block BOOL isError = NO;
    if (self.nIconProfile || self.nRegion || self.nNickName) {
        [self.delegate startAnimation];
    }
    dispatch_group_t group = dispatch_group_create();
    if (self.nIconProfile) {
        dispatch_group_enter(group);
        [[FirebaseManager sharedManager] updateIconUserForUserId:self.userModel.userId with:self.nIconProfile withCompletionBlock:^(BOOL successful) {
            isError = !successful;
            dispatch_group_leave(group);
        }];
    }
    if (self.nNickName) {
        dispatch_group_enter(group);
        [[FirebaseManager sharedManager] updateNickUserWithId:self.userModel.userId nickName:self.nNickName withCompletionBlock:^(BOOL successful) {
            isError = !successful;
            
            dispatch_group_leave(group);
        }];
    }
    if (self.nRegion) {
        dispatch_group_enter(group);
        [[FirebaseManager sharedManager] updateRegionUserWithId:self.userModel.userId region:self.nRegion withCompletionBlock:^(BOOL successful) {
            isError = !successful;
            
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.delegate stopAnimation];
        
        [[CoreDataManager sharedManager] updateUserDataWithNickName:self.nNickName region:self.nRegion];
        
        self.nIconProfile = nil;
        self.nRegion =
        self.nNickName = nil;
    });
}

#pragma mark - Accessors

- (NSString *)userNickName {
    return self.userModel.nickName;
}

- (NSString *)userEmail {
    return self.userModel.email;
}

- (NSString *)userRegion {
    return [self getRegion:self.userModel.regionName];
}

- (NSString *) userBalls {
    return [NSString stringWithFormat:@"%ld", self.userModel.balls];
}

#pragma mark - IChartAxisValueFormatter

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    return [self.statisticModel.xAxis objectAtIndex:(NSInteger)value];
}

@end
