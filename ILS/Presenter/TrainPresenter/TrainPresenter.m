//
//  TrainPresenter.m
//  ILS
//
//  Created by admin on 23.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "TrainPresenter.h"

#import "UserModel.h"
#import "WordModel.h"
#import "StatisticWordModel.h"

#import "LearningManager.h"
#import "CoreDataManager.h"
#import "FirebaseManager.h"

static NSString *const kTrainPresenterTitle = @"title";
static NSString *const kTrainPresenterOk = @"ok";
static NSString *const kTrainPresenterAlertTitle = @"alertTitle";
static NSString *const kTrainPresenterDescription = @"alertDescription";

@interface TrainPresenter()

@property (weak, nonatomic) id<TrainDelegate> delegate;
@property (strong, nonatomic) NSArray<WordModel *> *dataSource;
@property (strong, nonatomic) UserModel *userModel;

@property (assign, nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) NSString *alertTitleText;
@property (strong, nonatomic) NSString *descriptionTemplateText;
@property (assign, nonatomic) NSInteger balls;

@end

@implementation TrainPresenter

- (instancetype)initWithDelegate:(id<TrainDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        
        [self setupPresenter];
    }
    return self;
}

#pragma mark - Private

- (void)setupPresenter {
    [self fetchScreenData];
    
    self.userModel = [[CoreDataManager sharedManager] userModel];
}

- (void)fetchScreenData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Train" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.titleText = [data objectForKey:kTrainPresenterTitle];
    self.okText = [data objectForKey:kTrainPresenterOk];
    self.alertTitleText = [data objectForKey:kTrainPresenterTitle];
    self.descriptionTemplateText = [data objectForKey:kTrainPresenterDescription];
}

- (NSArray<NSString *> *)getAnswerWords {
    NSString *translatedText = [self.dataSource objectAtIndex:self.currentIndex].translatedWordText;
    __block NSMutableArray<NSString *> *answers = [NSMutableArray arrayWithArray:[translatedText componentsSeparatedByString:@";"]];
    [answers enumerateObjectsUsingBlock:^(NSString * _Nonnull translatedWord, NSUInteger index, BOOL * _Nonnull stop) {
        [answers replaceObjectAtIndex:index withObject:[translatedWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }];
    return [answers copy];
}

- (double)getValueForProgressView {
    double value = (double)self.currentIndex / self.dataSource.count;
    return value;
}

- (void)saveWordsState {
    [self.delegate startAnimation];
    
    dispatch_group_t group = dispatch_group_create();
    for (WordModel *wordModel in self.dataSource) {
        dispatch_group_enter(group);
        [[FirebaseManager sharedManager] updateWord:wordModel toUserId:self.userModel.userId withCompletionBlock:^{
            [[CoreDataManager sharedManager] updateWordModels:@[wordModel]];
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *messageText = [NSString stringWithFormat:self.descriptionTemplateText, self.balls];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate stopAnimation];
            [self.delegate trainDidBeginEndWithTitle:self.titleText descriptionMessage:messageText];
        });
    });
}

#pragma mark - Public

- (void)fetchData {
    NSArray<WordModel *> *words = [[[CoreDataManager sharedManager] getWordModels] sortedArrayUsingComparator:^NSComparisonResult(WordModel *obj1, WordModel *obj2) {
        double p1 = [LearningManager pFormStartLearnTime:obj1.startLearn delta:obj1.delta withStatisticWordModel:obj1.statisticWordModels];
        double p2 = [LearningManager pFormStartLearnTime:obj2.startLearn delta:obj2.delta withStatisticWordModel:obj2.statisticWordModels];
        return p1 < p2;
    }];
    
    self.dataSource = [words subarrayWithRange:NSMakeRange(0, MIN(words.count, 5))];
    self.currentIndex = 0;
    [self.delegate updateTaskWithWord:[self getWord]];
}

- (void)nextWord {
    [self.delegate makeCleanTextField];
    self.currentIndex++;
    if (self.currentIndex == self.dataSource.count) {
        [self saveWordsState];
        return;
    }
    [self.delegate updateTaskWithWord:[self getWord]];
    [self.delegate updateProgressViewWithValue:[self getValueForProgressView]];
}

- (NSString *)getWord {
    return [self.dataSource objectAtIndex:self.currentIndex].wordText;
}

- (void)checkAnswerWithWord:(NSString *)word {
    NSArray *answerWords = [self getAnswerWords];
    WordModel *wordModel = [self.dataSource objectAtIndex: self.currentIndex];
    StatisticWordModel *statisticWordModel = [wordModel.statisticWordModels objectAtIndex:[LearningManager getIndexFromTime:wordModel.startLearn.timeIntervalSinceReferenceDate]];
    NSInteger index = -1;
    statisticWordModel.negativeX += 1;
    wordModel.xNegative += 1;
    for (NSString *answerWord in answerWords) {
        if ([answerWords containsObject:[word lowercaseString]]) {
            index = [answerWords indexOfObject:answerWord];
            self.balls++;
            
            statisticWordModel.negativeX -= 1;
            statisticWordModel.positiveX += 1;
            
            wordModel.xNegative -= 1;
            wordModel.xPositive += 1;
            break;
        }
    }
    [self.delegate showAnswerWithAnswersWord:answerWords selectedAnswerIndex:index];
}

@end
