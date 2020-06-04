//
//  CoreDataManager.m
//  ILS
//
//  Created by admin on 25.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "CoreDataManager.h"
#import "LearningManager.h"

#import "AppDelegate.h"

#import "WordModel.h"
#import "UserModel.h"
#import "ArticleModel.h"
#import "StatisticWordModel.h"

#import "User+CoreDataClass.h"
#import "Article+CoreDataClass.h"
#import "Word+CoreDataClass.h"
#import "StatisticWord+CoreDataClass.h"

@interface CoreDataManager()

@property (strong, nonatomic) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) User *user;

@end

@implementation CoreDataManager

#pragma mark - Private

- (User *)fetchUser {
    return [[self.persistentContainer.viewContext executeFetchRequest:[User fetchRequest] error:nil] firstObject];
}

#pragma mark - Public

+ (instancetype)sharedManager {
    static CoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreDataManager alloc] init];
        sharedInstance.persistentContainer = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer;
    });
    
    return sharedInstance;
}

- (UserModel *)userModel {
    self.user = [[self.persistentContainer.viewContext executeFetchRequest:[User fetchRequest] error:nil] firstObject];
    return [UserModel createUserModel:self.user];
}

- (void)updateUserDataWithNickName:(NSString *)nickName region:(NSString *)region {
    if (nickName) {
        self.user.nickname = nickName;
    }
    if (region) {
        self.user.region = region;
    }
    
    [self.persistentContainer.viewContext save:nil];
}

- (NSString *)addUserBalls:(NSInteger)balls {
    self.user.balls += (int32_t)balls;
    
    NSDate *date = self.user.lastWorkout;
    NSDate *todayDate = [NSDate date];
    NSInteger curentDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:todayDate];
    NSInteger lastWorkoutDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:date];
    NSInteger leftDay = curentDay - lastWorkoutDay;
    
    NSInteger day4agoBalls = self.user.day4agoBalls;
    NSInteger day3agoBalls = self.user.day3agoBalls;
    NSInteger day2agoBalls = self.user.day2agoBalls;
    NSInteger day1agoBalls = self.user.day1agoBalls;
    NSInteger todayBalls = self.user.todayBalls + balls;
    NSInteger arrBalls[5] = {
        day4agoBalls,
        day3agoBalls,
        day2agoBalls,
        day1agoBalls,
        todayBalls,
    };
    
    for (NSInteger i = 0; i < leftDay; i++) {
        for (NSInteger j = 4; j > 0; j--) {
            arrBalls[j] = arrBalls[j - 1];
        }
        arrBalls[0] = 0;
    }
    
    self.user.day4agoBalls = (int32_t)arrBalls[0];
    self.user.day3agoBalls = (int32_t)arrBalls[1];
    self.user.day2agoBalls = (int32_t)arrBalls[2];
    self.user.day1agoBalls = (int32_t)arrBalls[3];
    self.user.todayBalls = (int32_t)arrBalls[4];
    self.user.lastWorkout = todayDate;
    
    [self.persistentContainer.viewContext save:nil];
    
    return self.user.id;
}

- (void)saveArticleModels:(NSArray<ArticleModel *> *)articleModels {
    NSFetchRequest<Article *> *request = Article.fetchRequest;
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    [self.persistentContainer.viewContext executeRequest:deleteRequest error:nil];
    [self.persistentContainer.viewContext save:nil];
    
    for (Article *articleModel in articleModels) {
        Article *article = [[Article alloc] initWithContext:self.persistentContainer.viewContext];
        article.title = articleModel.title;
        article.content = articleModel.content;
    }
    
    [self.persistentContainer.viewContext save:nil];
}

- (NSArray<ArticleModel *> *)getAllArticleModels {
    NSArray<Article *> *articles = [self.persistentContainer.viewContext executeFetchRequest:[Article fetchRequest] error:nil];
    NSMutableArray *mutableArticleModels = [NSMutableArray arrayWithCapacity:articles.count];
    for (Article *article in articles) {
        ArticleModel *articleModel = [ArticleModel createArticleModelWithTitle:article.title content:article.content];
        [mutableArticleModels addObject:articleModel];
    }
    
    return [mutableArticleModels copy];
}

- (void)updateWordModels:(NSArray<WordModel *> *)wordModels {
    for (WordModel *wordModel in wordModels) {
        
        Word *word = [[self.user.words.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"wordId == %@", wordModel.idWord]] firstObject];
        word.wordId = wordModel.idWord;
        word.wordText = wordModel.wordText;
        word.translatedWordText = wordModel.translatedWordText;
        word.soundName = wordModel.soundName;
        word.delta = wordModel.delta.timeIntervalSinceReferenceDate;
        word.startLearn = wordModel.startLearn.timeIntervalSinceReferenceDate;
        word.xPositive = (int32_t)wordModel.xPositive;
        word.xNegative = (int32_t)wordModel.xNegative;
//        for (StatisticWordModel *statisticWordModel in wordModel.statisticWordModels) {
//            StatisticWord *statisticWord = [[word.statisticWords.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"level == %d", statisticWordModel.level]] firstObject];
//            statisticWord.level = (int32_t)statisticWordModel.level;
//            statisticWord.xNegative = (int32_t)statisticWordModel.negativeX;
//            statisticWord.xPositive = (int32_t)statisticWordModel.positiveX;
//        }
    }
    
    [self.persistentContainer.viewContext save:nil];
}

- (void)saveWordModels:(NSArray<WordModel *> *)wordModels {
    for (WordModel *wordModel in wordModels) {
        Word *word = [[Word alloc] initWithContext:self.persistentContainer.viewContext];
        word.wordId = wordModel.idWord;
        word.wordText = wordModel.wordText;
        word.translatedWordText = wordModel.translatedWordText;
        word.soundName = wordModel.soundName;
        word.delta = wordModel.delta.timeIntervalSinceReferenceDate;
        word.startLearn = wordModel.startLearn.timeIntervalSinceReferenceDate;
        word.xPositive = (int32_t)wordModel.xPositive;
        word.xNegative = (int32_t)wordModel.xNegative;
        for (StatisticWordModel *statisticWordModel in wordModel.statisticWordModels) {
            StatisticWord *statisticWord = [[StatisticWord alloc] initWithContext:self.persistentContainer.viewContext];
            statisticWord.level = (int32_t)statisticWordModel.level;
            statisticWord.xNegative = (int32_t)statisticWordModel.negativeX;
            statisticWord.xPositive = (int32_t)statisticWordModel.positiveX;
            [word addStatisticWordsObject:statisticWord];
        }
        [self.user addWordsObject:word];
    }
    
    [self.persistentContainer.viewContext save:nil];
}

- (NSArray<WordModel *> *)getWordModels {
    NSMutableArray<WordModel *> *mutableWords = [NSMutableArray arrayWithCapacity:self.user.words.count];
    for (Word *word in self.user.words) {
        NSMutableArray<StatisticWordModel *> *statisticWordModels = [NSMutableArray arrayWithCapacity:LearningManager.levels];
        for (StatisticWord *statisticWord in word.statisticWords) {
            [statisticWordModels addObject:[StatisticWordModel createStatisticWordModelWithWord:word.wordText level:statisticWord.level positiveX:statisticWord.xPositive negativeX:statisticWord.xNegative]];
        }
        
        [mutableWords addObject:[WordModel modelWithIdWord:word.wordId wordText:word.wordText translatedWordText:word.translatedWordText withSoundName:word.soundName withDelta:word.delta withStartLearn:word.startLearn withXPositive:word.xPositive withXNegative:word.xNegative withStatisticWordModels:[statisticWordModels copy]]];
    }
    
    return [mutableWords copy];
}

- (void)saveStatisticWordModels:(NSArray<StatisticWordModel *> *)statisticWordModels {
    NSFetchRequest *fetchRequestWord = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    fetchRequestWord.predicate = [NSPredicate predicateWithFormat:@"wordText == %@", statisticWordModels.firstObject.word];
    Word *word = (Word *)[[self.persistentContainer.viewContext executeFetchRequest:fetchRequestWord error:nil] firstObject];
    
    for (StatisticWordModel *statisticWordModel in statisticWordModels) {
        StatisticWord *statisticWord = [[StatisticWord alloc] initWithContext:self.persistentContainer.viewContext];
        statisticWord.level = (int32_t)statisticWordModel.level;
        statisticWord.xNegative = (int32_t)statisticWordModel.negativeX;
        statisticWord.xPositive = (int32_t)statisticWordModel.positiveX;
        
        [word addStatisticWordsObject:statisticWord];
    }
    
    [self.persistentContainer.viewContext save:nil];
}

- (NSArray<StatisticWordModel *> *)getForWordText:(NSString *)wordText {
    NSFetchRequest *fetchRequestWord = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    fetchRequestWord.predicate = [NSPredicate predicateWithFormat:@"wordText == %@", wordText];
    Word *word = (Word *)[[self.persistentContainer.viewContext executeFetchRequest:fetchRequestWord error:nil] firstObject];
    
    NSMutableArray<StatisticWordModel *> *statisticWordModels = [NSMutableArray arrayWithCapacity:word.statisticWords.count];
    for(StatisticWord *statisticWord in word.statisticWords) {
        StatisticWordModel *statisticWordModel = [StatisticWordModel createStatisticWordModelWithWord:wordText level:statisticWord.level positiveX:statisticWord.xPositive negativeX:statisticWord.xNegative];
        [statisticWordModels addObject:statisticWordModel];
    }
    
    return [statisticWordModels copy];
}

@end
