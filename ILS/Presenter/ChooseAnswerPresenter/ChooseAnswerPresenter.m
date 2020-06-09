//
//  ChooseAnswerPresenter.m
//  ILS
//
//  Created by admin on 07.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ChooseAnswerPresenter.h"

#import "FirebaseManager.h"
#import "CoreDataManager.h"
#import "LearningManager.h"

#import "UserModel.h"
#import "WordModel.h"
#import "ChooseOptionWordModel.h"

#import "CoreDataManager.h"

static NSString *const kChooseAnswerPresenterTitle = @"title";
static NSString *const kChooseAnswerPresenterAlertMessage = @"alertMessage";
static NSString *const kChooseAnswerPresenterOk = @"ok";
static NSString *const kChooseAnswerPresenterAlertErrorTitle = @"alertErrorTitle";
static NSString *const kChooseAnswerPresenterAlertErrorMessage = @"alertErrorMessage";

@interface ChooseAnswerPresenter()

@property (weak, nonatomic) id<ChooseAnswerDelegate> delegate;

@property (strong, nonatomic) NSArray<ChooseOptionWordModel *> *dataSource;
@property (strong, nonatomic) UserModel *userModel;

@property (assign, nonatomic) NSInteger currentTask;
@property (assign, nonatomic) NSInteger balls;

@property (strong, nonatomic) NSString *messageTextTemplate;
@property (strong, nonatomic) NSString *alertErrorTitle;
@property (strong, nonatomic) NSString *alertErrorMessage;

@end

@implementation ChooseAnswerPresenter

- (instancetype)initWithDelegate:(id<ChooseAnswerDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        
        [self setupPresenter];
    }
    return self;
}

#pragma mark - Private

- (void)setupPresenter {
    [self fetchScreenData];
}

- (void)fetchScreenData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ChooseAnswer" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.titleText = [data objectForKey:kChooseAnswerPresenterTitle];
    self.messageTextTemplate = [data objectForKey:kChooseAnswerPresenterAlertMessage];
    self.okText = [data objectForKey:kChooseAnswerPresenterOk];
    self.alertErrorTitle = [data objectForKey:kChooseAnswerPresenterAlertErrorTitle];
    self.alertErrorMessage = [data objectForKey:kChooseAnswerPresenterAlertErrorMessage];
}

- (void)fetchData {
    self.userModel = [[CoreDataManager sharedManager] userModel];
    
    NSArray<WordModel *> *fetchedWordModels = [[[CoreDataManager sharedManager] getWordModels] sortedArrayUsingComparator:^NSComparisonResult(WordModel *obj1, WordModel *obj2) {
        double p1 = [LearningManager pFormStartLearnTime:obj1.startLearn delta:obj1.delta withStatisticWordModel:obj1.statisticWordModels];
        double p2 = [LearningManager pFormStartLearnTime:obj2.startLearn delta:obj2.delta withStatisticWordModel:obj2.statisticWordModels];
        return p1 < p2;
    }];
    
    if (fetchedWordModels.count < 4) {
        [self.delegate userCantStartTrainAlertWithTitle:self.alertErrorTitle message:self.alertErrorMessage];
        return;
    }
    
    NSMutableArray<WordModel *> *wordModels = [NSMutableArray arrayWithArray:[fetchedWordModels subarrayWithRange:NSMakeRange(0, 4)]];
    
    for (NSInteger index = 0; index < 4; index++) {
        [wordModels addObject: [wordModels objectAtIndex:index]];
    }
    
    NSMutableArray<NSString *> *mutableAllOptionsText = [NSMutableArray arrayWithCapacity:wordModels.count];
    
    for (NSInteger index = 0; index < wordModels.count; index++) {
        [mutableAllOptionsText addObject:[wordModels objectAtIndex:index].translatedWordText];
    }
    
    NSMutableArray<ChooseOptionWordModel *> *chooseOptionWordModels = [NSMutableArray array];
    
    for (WordModel *wordModel in wordModels) {
        NSString *rightAnswer = [[wordModel.translatedWordText componentsSeparatedByString:@"; "] firstObject];
        NSMutableArray<NSString *> *mutableOptionsText = [NSMutableArray arrayWithObject:rightAnswer];
        for (NSInteger i = 0; i < 3; i++) {
            NSInteger randomIndex = arc4random_uniform((int32_t)wordModels.count);
            NSString *proposeTranslatedWord = [[[mutableAllOptionsText objectAtIndex:randomIndex] componentsSeparatedByString:@"; "] firstObject];
            if ([mutableOptionsText containsObject:proposeTranslatedWord]) {
                i--;
                continue;
            }
            [mutableOptionsText addObject:proposeTranslatedWord];
        }
        [chooseOptionWordModels addObject:[ChooseOptionWordModel creteChooseOptionWordModelWithWordModel:wordModel optionAnswers:mutableOptionsText]];
    }
    
    self.dataSource = [chooseOptionWordModels copy];
}

- (void)saveWordsState {
    [self.delegate startAnimation];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [[FirebaseManager sharedManager] updateBallsWithId:self.userModel.userId balls:self.balls withCompletionBlock:^(BOOL finished) {
        [[CoreDataManager sharedManager] addUserBalls:self.balls];
        dispatch_group_leave(group);
    }];
    
    for (ChooseOptionWordModel *chooseOptionWordModel in self.dataSource) {
        dispatch_group_enter(group);
        [[FirebaseManager sharedManager] updateWord:chooseOptionWordModel.wordModel toUserId:self.userModel.userId withCompletionBlock:^{
            [[CoreDataManager sharedManager] updateWordModels:@[chooseOptionWordModel.wordModel]];
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *messageText = [NSString stringWithFormat:self.messageTextTemplate, self.balls];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate stopAnimation];
            [self.delegate trainDidBeginEndWithTitle:self.titleText descriptionMessage:messageText];
        });
    });
}

#pragma mark - Public

- (NSString *)getWordText {
    return [[[self.dataSource objectAtIndex:self.currentTask] wordModel] wordText];
}

- (NSString *)getOptionTextForType:(OptionType)optionType {
    NSString *returnString;
    ChooseOptionWordModel *chooseOptionWordModel = [self.dataSource objectAtIndex:self.currentTask];
    
    switch (optionType) {
        case OptionText1: {
            returnString = chooseOptionWordModel.optionAnswer1Text;
        }
            break;
        case OptionText2: {
            returnString = chooseOptionWordModel.optionAnswer2Text;
        }
            break;
        case OptionText3: {
            returnString = chooseOptionWordModel.optionAnswer3Text;
        }
            break;
        case OptionText4: {
            returnString = chooseOptionWordModel.optionAnswer4Text;
        }
            break;
    }
    
    return returnString;
}

- (void)selectAnswer:(NSInteger)answerIndex {
    ChooseOptionWordModel *chooseOptionWordModel = [self.dataSource objectAtIndex:self.currentTask];
    BOOL isCorrect = NO;
    WordModel *wordModel = chooseOptionWordModel.wordModel;
    StatisticWordModel *statisticWordModel = [wordModel.statisticWordModels objectAtIndex:[LearningManager getIndexFromTime:wordModel.startLearn.timeIntervalSinceReferenceDate]];
    statisticWordModel.negativeX += 1;
    wordModel.xNegative += 1;
    wordModel.delta = [NSDate dateWithTimeIntervalSinceReferenceDate:[NSDate timeIntervalSinceReferenceDate]];
    
    if (answerIndex == chooseOptionWordModel.answerIndex) {
        isCorrect = YES;
        
        statisticWordModel.negativeX -= 1;
        statisticWordModel.positiveX += 1;
        
        chooseOptionWordModel.wordModel.xNegative -= 1;
        chooseOptionWordModel.wordModel.xPositive += 1;
        
        self.balls++;
    }
    
    [self.delegate showAnswerWithAnswersWord:@[
        chooseOptionWordModel.optionAnswer1Text,
        chooseOptionWordModel.optionAnswer2Text,
        chooseOptionWordModel.optionAnswer3Text,
        chooseOptionWordModel.optionAnswer4Text,
    ] selectedAnswerIndex:chooseOptionWordModel.answerIndex correct:isCorrect];
    
    self.currentTask++;
    
    if (self.currentTask == self.dataSource.count) {
        self.currentTask--;
        [self saveWordsState];
    }
}

@end
