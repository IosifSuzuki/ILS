//
//  RatingPresenter.h
//  ILS
//
//  Created by admin on 29.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserTableViewCell.h"

typedef NS_ENUM(NSInteger, RatingType) {
    RaitingTypeTotal,
    RaitingTypeToday,
};

@protocol RatingDelegate <NSObject>

- (void)startAnimation;
- (void)stopAnimation;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RatingPresenter : NSObject

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *totalRaitingText;
@property (strong, nonatomic) NSString *todayRaitingText;

- (instancetype)initWithDelegate:(id<RatingDelegate>)delegate;
- (void)fetchUserWithType:(RatingType)type;
- (void)prepareCell:(id<UserTableViewCellDelegate>)cellDelegate withIndex:(NSInteger)index withRatingType:(RatingType)ratingType;
- (NSInteger)numberOfUsers;

@end

NS_ASSUME_NONNULL_END
