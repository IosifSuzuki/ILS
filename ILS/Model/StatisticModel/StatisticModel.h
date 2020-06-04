//
//  StatisticModel.h
//  ILS
//
//  Created by admin on 16.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatisticModel : NSObject

@property (assign, nonatomic) NSInteger todayBalls;
@property (assign, nonatomic) NSInteger day1AgoBalls;
@property (assign, nonatomic) NSInteger day2AgoBalls;
@property (assign, nonatomic) NSInteger day3AgoBalls;
@property (assign, nonatomic) NSInteger day4AgoBalls;

@property (strong, nonatomic) NSArray<NSString *> *xAxis;

- (instancetype)initWithUser:(UserModel *)userModel;

@end

NS_ASSUME_NONNULL_END
