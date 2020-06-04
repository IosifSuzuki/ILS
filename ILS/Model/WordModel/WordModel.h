//
//  WorldModel.h
//  ILS
//
//  Created by admin on 10.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class StatisticWordModel;
@interface WordModel : NSObject

@property (strong, nonatomic) NSString *idWord;
@property (strong, nonatomic) NSString *wordText;
@property (strong, nonatomic) NSString *translatedWordText;
@property (strong, nonatomic) NSString *soundName;
@property (strong, nonatomic) NSDate *delta;
@property (strong, nonatomic) NSDate *startLearn;
@property (assign, nonatomic) NSInteger xNegative;
@property (assign, nonatomic) NSInteger xPositive;
@property (copy, nonatomic) NSArray<StatisticWordModel *> *statisticWordModels;

@property (assign, nonatomic) NSString *addedDateShortFormatt;

+ (instancetype)modelWithIdWord:(NSString *)idWord wordText:(NSString *)wordText translatedWordText:(NSString * _Nullable)translatedWordText withSoundName:(NSString * _Nullable)soundName withDelta:(NSTimeInterval)delta withStartLearn:(NSTimeInterval)startLeart withXPositive:(NSTimeInterval)xPositive withXNegative:(NSTimeInterval)xNegative;
+ (instancetype)modelWithIdWord:(NSString *)idWord wordText:(NSString *)wordText translatedWordText:(NSString * _Nullable)translatedWordText withSoundName:(NSString * _Nullable)soundName withDelta:(NSTimeInterval)delta withStartLearn:(NSTimeInterval)startLeart withXPositive:(NSTimeInterval)xPositive withXNegative:(NSTimeInterval)xNegative withStatisticWordModels:(NSArray<StatisticWordModel *> *)statisticWordModels;

+ (instancetype)modelWithWordModelDictionary:(NSDictionary *)wordModelDictionary;

@end

NS_ASSUME_NONNULL_END
