//
//  User+CoreDataProperties.m
//  ILS
//
//  Created by admin on 04.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"User"];
}

@dynamic balls;
@dynamic day1agoBalls;
@dynamic day2agoBalls;
@dynamic day3agoBalls;
@dynamic day4agoBalls;
@dynamic email;
@dynamic id;
@dynamic lastWorkout;
@dynamic nickname;
@dynamic region;
@dynamic todayBalls;
@dynamic words;

@end
