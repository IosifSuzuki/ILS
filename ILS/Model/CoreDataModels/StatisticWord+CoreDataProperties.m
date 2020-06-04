//
//  StatisticWord+CoreDataProperties.m
//  ILS
//
//  Created by admin on 04.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//
//

#import "StatisticWord+CoreDataProperties.h"

@implementation StatisticWord (CoreDataProperties)

+ (NSFetchRequest<StatisticWord *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"StatisticWord"];
}

@dynamic level;
@dynamic xPositive;
@dynamic xNegative;
@dynamic word;

@end
