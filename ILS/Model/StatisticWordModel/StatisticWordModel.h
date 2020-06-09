//
//  StatisticWordModel.h
//  ILS
//
//  Created by admin on 01.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatisticWordModel : NSObject

@property (strong, nonatomic) NSString *word;
@property (assign, nonatomic) NSInteger level;
@property (assign, nonatomic) NSInteger positiveX;
@property (assign, nonatomic) NSInteger negativeX;

+ (instancetype)createStatisticWordModelWithWord:(NSString *)word level:(NSInteger)level positiveX:(NSInteger)positiveX negativeX:(NSInteger)negativeX;
+ (instancetype)createStatisticWordModelWithDictionary:(NSDictionary *)statisticWordModelDictionary;

+ (NSArray<StatisticWordModel *> *)getArrayOfNewtatisticWordModelWithWord:(NSString *)word;

@end

NS_ASSUME_NONNULL_END
