//
//  LearningManager.m
//  ILS
//
//  Created by admin on 26.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LearningManager.h"

#import "StatisticWordModel.h"

@interface LearningManager()

@end

@implementation LearningManager

#pragma mark - Private

+ (NSTimeInterval)getSecondsFromHours:(NSTimeInterval)hours {
    return 60 * 60 * hours;
}

#pragma mark - Accessor

+ (NSInteger)levels {
    return 6;
}

#pragma mark - Public

+ (instancetype)sharedManager {
    static LearningManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LearningManager alloc] init];
    });
    
    return sharedInstance;
}

+ (NSTimeInterval)hFromIndex:(NSInteger)index {
    if (index > 5) {
        index = 5;
    }
    NSTimeInterval lvls[] = {
        [LearningManager getSecondsFromHours:1],
        [LearningManager getSecondsFromHours:8],
        [LearningManager getSecondsFromHours:24],
        [LearningManager getSecondsFromHours:48],
        [LearningManager getSecondsFromHours:96],
        [LearningManager getSecondsFromHours:7 * 24],
    };
    return lvls[index];
}

+ (double)pFromDelta:(NSTimeInterval)delta h:(NSTimeInterval)h {
    return pow(2, -(delta / h));
}

+ (NSInteger)getIndexFromTime:(NSTimeInterval)startLearnWordTime {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - startLearnWordTime;
    NSTimeInterval lvls[] = {
        [LearningManager getSecondsFromHours:1],
        [LearningManager getSecondsFromHours:8],
        [LearningManager getSecondsFromHours:24],
        [LearningManager getSecondsFromHours:48],
        [LearningManager getSecondsFromHours:96],
        [LearningManager getSecondsFromHours:7 * 24],
    };
    
    NSInteger currentLevel;
    for (currentLevel = 0; currentLevel < sizeof(lvls) / sizeof(lvls[0]); currentLevel++) {
        if (lvls[currentLevel] > timeInterval) {
            break;
        }
    }
    
    return currentLevel;
}

+ (double)pFormStartLearnTime:(NSDate *)startLearnTime delta:(NSDate *)delta {
    NSTimeInterval deltaTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - [delta timeIntervalSinceReferenceDate];
    NSInteger index = [LearningManager getIndexFromTime:[startLearnTime timeIntervalSinceReferenceDate]];
    NSTimeInterval hTimeInterval = [LearningManager hFromIndex:index];
    return [LearningManager pFromDelta:deltaTimeInterval h:hTimeInterval];
}

+ (double)pFormStartLearnTime:(NSDate *)startLearnTime delta:(NSDate *)delta withStatisticWordModel:(NSArray<StatisticWordModel *> *)statisticWordModels {
    NSTimeInterval deltaTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - [delta timeIntervalSinceReferenceDate];
    NSInteger index = [LearningManager getIndexFromTime:[startLearnTime timeIntervalSinceReferenceDate]];
    StatisticWordModel *statisticWordModel = [statisticWordModels objectAtIndex:index];
    NSTimeInterval hTimeInterval = [LearningManager hFromIndex:index];
    double positiveX = statisticWordModel.positiveX != 0 ? statisticWordModel.positiveX : 1;
    double negativeX = statisticWordModel.negativeX != 0 ? statisticWordModel.negativeX : 1;
    double p = [LearningManager pFromDelta:deltaTimeInterval h:hTimeInterval];
    return p * (positiveX / (positiveX + negativeX) + 0.5);
}

@end
