//
//  UserModel.m
//  ILS
//
//  Created by admin on 25.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (instancetype)createUserModel:(User *)user {
    UserModel *userModel = [[UserModel alloc] init];
    userModel.userId = user.id;
    userModel.nickName = user.nickname;
    userModel.regionName = user.region;
    userModel.email = user.email;
    userModel.balls = user.balls;
    userModel.day4agoBalls = user.day4agoBalls;
    userModel.day3agoBalls = user.day3agoBalls;
    userModel.day2agoBalls = user.day2agoBalls;
    userModel.day1agoBalls = user.day1agoBalls;
    userModel.todayBalls = user.todayBalls;
    userModel.lastWorkout = user.lastWorkout;
    userModel.userCoreData = user;
    
    return userModel;
}

+ (instancetype)createUserModelWithDictionary:(NSDictionary *)userInfo {
    UserModel *userModel = [[UserModel alloc] init];
    userModel.email = [userInfo objectForKey:@"email"];
    userModel.nickName = [userInfo objectForKey:@"nickname"];
    userModel.balls = [[userInfo objectForKey:@"balls"] integerValue];
    userModel.userId = [userInfo objectForKey:@"id"];
    userModel.regionName = [userInfo objectForKey:@"region"];
    userModel.todayBalls = [[userInfo objectForKey:@"todayBalls"] integerValue];
    userModel.day1agoBalls = [[userInfo objectForKey:@"day1agoBalls"] integerValue];
    userModel.day2agoBalls = [[userInfo objectForKey:@"day2agoBalls"] integerValue];
    userModel.day3agoBalls = [[userInfo objectForKey:@"day3agoBalls"] integerValue];
    userModel.day4agoBalls = [[userInfo objectForKey:@"day4agoBalls"] integerValue];
    userModel.lastWorkout = [NSDate dateWithTimeIntervalSinceReferenceDate:[[userInfo objectForKey:@"lastWorkout"] doubleValue]];
    
    return userModel;
}

@end
