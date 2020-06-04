//
//  User+CoreDataProperties.h
//  ILS
//
//  Created by admin on 04.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nonatomic) int32_t balls;
@property (nonatomic) int32_t day1agoBalls;
@property (nonatomic) int32_t day2agoBalls;
@property (nonatomic) int32_t day3agoBalls;
@property (nonatomic) int32_t day4agoBalls;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSDate *lastWorkout;
@property (nullable, nonatomic, copy) NSString *nickname;
@property (nullable, nonatomic, copy) NSString *region;
@property (nonatomic) int32_t todayBalls;
@property (nullable, nonatomic, retain) NSSet<Word *> *words;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addWordsObject:(Word *)value;
- (void)removeWordsObject:(Word *)value;
- (void)addWords:(NSSet<Word *> *)values;
- (void)removeWords:(NSSet<Word *> *)values;

@end

NS_ASSUME_NONNULL_END
