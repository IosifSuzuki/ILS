//
//  StatisticModel.m
//  ILS
//
//  Created by admin on 16.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "StatisticModel.h"

@implementation StatisticModel

- (instancetype)initWithUser:(UserModel *)userModel {
    if (self = [super init]) {
        [self setupModelWithUser:userModel];
    }
    
    return self;
}

#pragma mark - Private
    
- (void)setupModelWithUser:(UserModel *)userModel {
    NSDate *date = [NSDate date];
    NSInteger curentDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:date];
    NSInteger lastWorkoutDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:userModel.lastWorkout];
    NSInteger leftDay = curentDay - lastWorkoutDay;
    
    
    NSInteger balls[5] = {
        userModel.day4agoBalls,
        userModel.day3agoBalls,
        userModel.day2agoBalls,
        userModel.day1agoBalls,
        userModel.todayBalls,
    };
    
    NSLog(@"%@", userModel.lastWorkout);
    if ([date timeIntervalSinceReferenceDate] - [userModel.lastWorkout timeIntervalSinceReferenceDate] > 5 * 24 * 60 * 60) {
        leftDay = 5;
    }
    for (NSInteger i = 0; i < leftDay; i++) {
        for (NSInteger j = 0; j < 4; j++) {
            balls[j] = balls[j + 1];
        }
        balls[4] = 0;
    }
    
    self.day4AgoBalls = balls[0];
    self.day3AgoBalls = balls[1];
    self.day2AgoBalls = balls[2];
    self.day1AgoBalls = balls[3];
    self.todayBalls = balls[4];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EE"];
    NSDateComponents *component = [[NSDateComponents alloc] init];
    [component setDay:-1];
    NSMutableArray *nameOfDays = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 5; i++) {
        [nameOfDays addObject:[dateFormatter stringFromDate:date]];
        date = [[NSCalendar currentCalendar] dateByAddingComponents:component toDate:date options:0];
    }
    
    self.xAxis = [[nameOfDays reverseObjectEnumerator] allObjects];
}
    
@end
