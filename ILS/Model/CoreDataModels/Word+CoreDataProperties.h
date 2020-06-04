//
//  Word+CoreDataProperties.h
//  ILS
//
//  Created by admin on 04.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//
//

#import "Word+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Word (CoreDataProperties)

+ (NSFetchRequest<Word *> *)fetchRequest;

@property (nonatomic) double delta;
@property (nullable, nonatomic, copy) NSString *translatedWordText;
@property (nullable, nonatomic, copy) NSString *wordId;
@property (nullable, nonatomic, copy) NSString *wordText;
@property (nonatomic) int32_t xNegative;
@property (nonatomic) int32_t xPositive;
@property (nonatomic) double startLearn;
@property (nullable, nonatomic, copy) NSString *soundName;
@property (nullable, nonatomic, retain) User *user;
@property (nullable, nonatomic, retain) NSSet<StatisticWord *> *statisticWords;

@end

@interface Word (CoreDataGeneratedAccessors)

- (void)addStatisticWordsObject:(StatisticWord *)value;
- (void)removeStatisticWordsObject:(StatisticWord *)value;
- (void)addStatisticWords:(NSSet<StatisticWord *> *)values;
- (void)removeStatisticWords:(NSSet<StatisticWord *> *)values;

@end

NS_ASSUME_NONNULL_END
