//
//  CoreDataManager.h
//  ILS
//
//  Created by admin on 25.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@class ArticleModel;
@class WordModel;
@class StatisticWordModel;
NS_ASSUME_NONNULL_BEGIN

@interface CoreDataManager : NSObject

@property (strong, nonatomic) UserModel *userModel;

+ (instancetype)sharedManager;

- (void)updateUserDataWithNickName:(NSString *)nickName region:(NSString *)region;
- (NSString *)addUserBalls:(NSInteger)balls;
- (void)saveArticleModels:(NSArray<ArticleModel *> *)articleModels;
- (NSArray<ArticleModel *> *)getAllArticleModels;
- (void)saveWordModels:(NSArray<WordModel *> *)wordModels;
- (void)updateWordModels:(NSArray<WordModel *> *)wordModels;
- (NSArray<WordModel *> *)getWordModels;
- (void)saveStatisticWordModels:(NSArray<StatisticWordModel *> *)statisticWordModels;
- (NSArray<StatisticWordModel *> *)getForWordText:(NSString *)wordText;

@end

NS_ASSUME_NONNULL_END
