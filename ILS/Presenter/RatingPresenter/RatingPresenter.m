//
//  RatingPresenter.m
//  ILS
//
//  Created by admin on 29.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "RatingPresenter.h"

#import "FirebaseManager.h"

#import "UserModel.h"

static NSString *const kRaitingPresenterTitle = @"title";
static NSString *const kRaitingPresenterTotal = @"totalRaiting";
static NSString *const kRaitingPresenterToday = @"todayRaiting";

@interface RatingPresenter()

@property (weak, nonatomic) id<RatingDelegate> delegate;

@property (strong, nonatomic) NSArray<UserModel *> *bestUsers;

@end

@implementation RatingPresenter

- (instancetype)initWithDelegate:(id<RatingDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        
        [self setupPresenter];
    }
    return self;
}

#pragma mark - Private

- (void)setupPresenter {
    [self fetchScreenData];
}

- (void)fetchScreenData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Rating" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.titleText = [data objectForKey:kRaitingPresenterTitle];
    self.todayRaitingText = [data objectForKey:kRaitingPresenterToday];
    self.totalRaitingText = [data objectForKey:kRaitingPresenterTotal];
}

#pragma mark - Public

- (void)fetchUserWithType:(RatingType)type {
    BOOL flag = YES;
    switch(type) {
        case RaitingTypeTotal: {
            
        }
            break;
        case RaitingTypeToday: {
            flag = NO;
        }
            break;
    }
    
    [self.delegate startAnimation];
    [[FirebaseManager sharedManager] getBestUsersWithTotalsBalls:flag withCompletionBlock:^(NSArray<UserModel *> *bestUsers) {
        self.bestUsers = bestUsers;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate reloadData];
            [self.delegate stopAnimation];
        });
    }];
}

- (void)prepareCell:(id<UserTableViewCellDelegate>)cellDelegate withIndex:(NSInteger)index withRatingType:(RatingType)ratingType {
    UserModel *userModel = [self.bestUsers objectAtIndex:index];
    
    switch (ratingType) {
        case RaitingTypeTotal: {
            cellDelegate.ballsUser = userModel.balls;
        }
            break;
        case RaitingTypeToday: {
            cellDelegate.ballsUser = userModel.todayBalls;
        }
            break;
    }
    cellDelegate.regionUser = userModel.regionName;
    cellDelegate.nicknameUser = userModel.nickName;
    cellDelegate.numberInRating = index + 1;
    cellDelegate.userIdForIcon = userModel.userId;
}

- (NSInteger)numberOfUsers {
    return self.bestUsers.count;
}

@end
