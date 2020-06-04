//
//  LearningManager.h
//  ILS
//
//  Created by admin on 26.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class StatisticWordModel;
@interface LearningManager : NSObject

+ (instancetype)sharedManager;
+ (NSInteger)levels;

+ (NSInteger)getIndexFromTime:(NSTimeInterval)startLearnWordTime;
+ (NSTimeInterval)hFromIndex:(NSInteger)index;
+ (double)pFromDelta:(NSTimeInterval)delta h:(NSTimeInterval)h;
+ (double)pFormStartLearnTime:(NSDate *)startLearnTime delta:(NSDate *)delta;
+ (double)pFormStartLearnTime:(NSDate *)startLearnTime delta:(NSDate *)delta withStatisticWordModel:(NSArray<StatisticWordModel *> *)statisticWordModels;

@end

NS_ASSUME_NONNULL_END
