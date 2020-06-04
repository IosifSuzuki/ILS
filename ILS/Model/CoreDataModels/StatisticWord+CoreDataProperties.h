//
//  StatisticWord+CoreDataProperties.h
//  ILS
//
//  Created by admin on 04.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//
//

#import "StatisticWord+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface StatisticWord (CoreDataProperties)

+ (NSFetchRequest<StatisticWord *> *)fetchRequest;

@property (nonatomic) int32_t level;
@property (nonatomic) int32_t xPositive;
@property (nonatomic) int32_t xNegative;
@property (nullable, nonatomic, retain) Word *word;

@end

NS_ASSUME_NONNULL_END
