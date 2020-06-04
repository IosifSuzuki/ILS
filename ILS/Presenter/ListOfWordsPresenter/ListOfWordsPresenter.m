//
//  ListOfWordsPresenter.m
//  ILS
//
//  Created by admin on 11.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ListOfWordsPresenter.h"
#import "WordModel.h"

#import "CoreDataManager.h"
#import "LearningManager.h"

@interface ListOfWordsPresenter()

@property (weak, nonatomic) id<ListOfWordsPresenterDelegate> delegate;

@property (strong, nonatomic) NSArray <WordModel *> *dataSource;

@end

@implementation ListOfWordsPresenter

- (instancetype)initWithDelegate:(id<ListOfWordsPresenterDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        [self setupPresenter];
    }
    
    return self;
}

#pragma mark - Private

- (void)setupPresenter {
    
    [self fetchData];
    [self.delegate reloadData];
}

- (void)fetchData {
    self.dataSource = [[CoreDataManager sharedManager] getWordModels];
}

#pragma mark - Public

- (NSInteger)countDataSource {
    return self.dataSource.count;
}

- (NSString *)getWordAtIndex:(NSInteger)index {
    return [self.dataSource objectAtIndex:index].wordText;
}

- (NSString *)getTranslateWordsAtIndex:(NSInteger)index {
    return [self.dataSource objectAtIndex:index].translatedWordText;
}

- (BOOL)wordAtIndexNeededTrainAtIndex:(NSInteger)index {
    WordModel *wordsModel = [self.dataSource objectAtIndex:index];
    
    NSTimeInterval p = [LearningManager pFormStartLearnTime:[[self.dataSource objectAtIndex:index] startLearn] delta:[[self.dataSource objectAtIndex:index] delta] withStatisticWordModel:wordsModel.statisticWordModels];
    
    return p < .5;
}

- (NSString *)getStartLearnAtIndex:(NSInteger)index {
    return [[self.dataSource objectAtIndex:index] addedDateShortFormatt];
}

@end
