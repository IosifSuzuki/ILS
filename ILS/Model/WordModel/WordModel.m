//
//  WorldModel.m
//  ILS
//
//  Created by admin on 10.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "WordModel.h"

@implementation WordModel

+ (instancetype)modelWithIdWord:(NSString *)idWord wordText:(NSString *)wordText translatedWordText:(NSString * _Nullable)translatedWordText withSoundName:(NSString * _Nullable)soundName withDelta:(NSTimeInterval)delta withStartLearn:(NSTimeInterval)startLearn withXPositive:(NSTimeInterval)xPositive withXNegative:(NSTimeInterval)xNegative {
    WordModel *wordModel = [[WordModel alloc] init];
    
    wordModel.idWord = idWord;
    wordModel.wordText = wordText;
    wordModel.translatedWordText = [translatedWordText lowercaseString];
    wordModel.soundName = soundName ? soundName : @"nil";
    wordModel.delta = [NSDate dateWithTimeIntervalSinceReferenceDate:delta];
    wordModel.startLearn = [NSDate dateWithTimeIntervalSinceReferenceDate:startLearn];
    wordModel.xPositive = xPositive;
    wordModel.xNegative = xNegative;
    
    return wordModel;
}

+ (instancetype)modelWithIdWord:(NSString *)idWord wordText:(NSString *)wordText translatedWordText:(NSString * _Nullable)translatedWordText withSoundName:(NSString * _Nullable)soundName withDelta:(NSTimeInterval)delta withStartLearn:(NSTimeInterval)startLeart withXPositive:(NSTimeInterval)xPositive withXNegative:(NSTimeInterval)xNegative withStatisticWordModels:(NSArray<StatisticWordModel *> *)statisticWordModels {
    WordModel *wordModel = [WordModel modelWithIdWord:idWord wordText:wordText translatedWordText:translatedWordText withSoundName:soundName withDelta:delta withStartLearn:startLeart withXPositive:xPositive withXNegative:xNegative];
    
    wordModel.statisticWordModels = statisticWordModels;
    
    return wordModel;
}

+ (instancetype)modelWithWordModelDictionary:(NSDictionary *)wordModelDictionary {
    WordModel *wordModel = [[WordModel alloc] init];
    
    wordModel.idWord = [wordModelDictionary objectForKey:@"id"];
    wordModel.wordText = [wordModelDictionary objectForKey:@"word"];
    wordModel.translatedWordText = [[wordModelDictionary objectForKey:@"translatedWord"] lowercaseString];
    wordModel.soundName = [wordModelDictionary objectForKey:@"soundName"] ? [wordModelDictionary objectForKey:@"soundName"] : @"nil";
    wordModel.delta = [NSDate dateWithTimeIntervalSinceReferenceDate:[[wordModelDictionary objectForKey:@"delta"] doubleValue]];
    wordModel.startLearn = [NSDate dateWithTimeIntervalSinceReferenceDate:[[wordModelDictionary objectForKey:@"startLearn"] doubleValue]];
    wordModel.xPositive = [[wordModelDictionary objectForKey:@"xPositive"] integerValue];
    wordModel.xNegative = [[wordModelDictionary objectForKey:@"xNegative"] integerValue];
    
    return wordModel;
}

#pragma mark - Accessor

- (NSString *)addedDateShortFormatt {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd.MM.yyyy";
    return [dateFormatter stringFromDate:self.startLearn];
}

@end
