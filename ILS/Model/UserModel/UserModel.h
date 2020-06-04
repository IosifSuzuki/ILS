//
//  UserModel.h
//  ILS
//
//  Created by admin on 25.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *regionName;
@property (strong, nonatomic) NSDate *lastWorkout;
@property (assign, nonatomic) NSInteger balls;
@property (assign, nonatomic) NSInteger todayBalls;
@property (assign, nonatomic) NSInteger day1agoBalls;
@property (assign, nonatomic) NSInteger day2agoBalls;
@property (assign, nonatomic) NSInteger day3agoBalls;
@property (assign, nonatomic) NSInteger day4agoBalls;

@property (strong, nonatomic) User *userCoreData;

+ (instancetype)createUserModel:(User *)user;
+ (instancetype)createUserModelWithDictionary:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
