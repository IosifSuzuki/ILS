//
//  StatisticWordModel.m
//  ILS
//
//  Created by admin on 01.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "StatisticWordModel.h"

@implementation StatisticWordModel

+ (instancetype)createStatisticWordModelWithWord:(NSString *)word level:(NSInteger)level positiveX:(NSInteger)positiveX negativeX:(NSInteger)negativeX {
    StatisticWordModel *statisticWordModel = [[StatisticWordModel alloc] init];
    
    statisticWordModel.word = word;
    statisticWordModel.level = level;
    statisticWordModel.positiveX = positiveX;
    statisticWordModel.negativeX = negativeX;
    
    return statisticWordModel;
}

+ (instancetype)createStatisticWordModelWithDictionary:(NSDictionary *)statisticWordModelDictionary {
    StatisticWordModel *statisticWordModel = [[StatisticWordModel alloc] init];
    
    statisticWordModel.word = [statisticWordModelDictionary objectForKey:@"word"];
    statisticWordModel.level = [[statisticWordModelDictionary objectForKey:@"level"] integerValue];
    statisticWordModel.positiveX = [[statisticWordModelDictionary objectForKey:@"positiveX"] integerValue];
    statisticWordModel.negativeX = [[statisticWordModelDictionary objectForKey:@"negativeX"] integerValue];
    
    return statisticWordModel;
}

@end
