//
//  ProposeWordsPresenter.m
//  ILS
//
//  Created by admin on 28.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ProposeWordsPresenter.h"

#import "FirebaseManager.h"
#import "CoreDataManager.h"
#import "LearningManager.h"
#import "LocalNotificationManager.h"

#import "WordModel.h"
#import "UserModel.h"
#import "StatisticWordModel.h"

static NSString *const kProposeWordsPresnterTitle = @"title";
static NSString *const kProposeWordsPresnterTitleAlert = @"titleAlert";
static NSString *const kProposeWordsPresnterTitleMessage = @"messageAlert";
static NSString *const kProposeWordsPresnterOk = @"ok";

@interface ProposeWordsPresenter()

@property (weak, nonatomic) id<ProposeWordsDelegate> delegate;

@property (strong, nonatomic) UserModel *userModel;

@property (strong, nonatomic) NSArray<WordModel *> *selectedWords;

@end

@implementation ProposeWordsPresenter

- (instancetype)initWithDelegate:(id<ProposeWordsDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        
        [self setupPresenter];
    }
    return self;
}
#pragma mark - Accessor

+ (NSString *)reuseIdentifier {
    return @"WordCell";
}

- (void)setSelectedWords:(NSArray<WordModel *> *)selectedWords {
    _selectedWords = selectedWords;
    
    BOOL enabled = NO;
    if (self.selectedWords.count) {
        enabled = YES;
    }
    
    [self.delegate enableSaveButton:enabled];
}

#pragma mark - Private

- (void)setupPresenter {
    [self fetchScreenData];
    [self fetchData];
}

- (void)fetchScreenData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ProposeWords" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.titleText = [data objectForKey:kProposeWordsPresnterTitle];
    self.alertTitle = [data objectForKey:kProposeWordsPresnterTitleAlert];
    self.alertMessage = [data objectForKey:kProposeWordsPresnterTitleMessage];
    self.okText = [data objectForKey:kProposeWordsPresnterOk];
}

- (void)fetchData {
    self.userModel = [[CoreDataManager sharedManager] userModel];
}

- (void)addWord:(WordModel *)word {
    NSMutableArray<WordModel *> *mutableSelectedWords = [NSMutableArray arrayWithArray:self.selectedWords];
    [mutableSelectedWords addObject:word];
    self.selectedWords = [mutableSelectedWords copy];
}

- (void)removeWords:(WordModel *)word {
    NSMutableArray<WordModel *> *mutableSelectedWords = [NSMutableArray arrayWithArray:self.selectedWords];
    [mutableSelectedWords removeObject:word];
    self.selectedWords = [mutableSelectedWords copy];
}

#pragma mark - Public

- (NSString *)getWordAtIndex:(NSInteger)index {
    return [[self.proposeWords objectAtIndex:index] wordText];
}

- (NSString *)getTranslatedWord:(NSInteger)index {
    return [[self.proposeWords objectAtIndex:index] translatedWordText];
}

- (void)selectObjectAtIndex:(NSInteger)index {
    WordModel *selectedWord = [self.proposeWords objectAtIndex:index];
    [self addWord:selectedWord];
}

- (void)deselectObjectAtIndex:(NSInteger)index {
    WordModel *deselectedWord = [self.proposeWords objectAtIndex:index];
    [self removeWords:deselectedWord];
}

- (void)saveWordsWithCompletionBlock:(void (^)(void))completionBlock {
    [self.delegate startAnimation];
    dispatch_group_t group = dispatch_group_create();
    for (WordModel *selectedWord in self.selectedWords) {
        dispatch_group_enter(group);
        [[FirebaseManager sharedManager] addWord:selectedWord toUserId:self.userModel.userId withCompletionBlock:^(NSArray<StatisticWordModel *> *statisticWordModels) {
            if (selectedWord.translatedWordText) {
//                NSTimeInterval h = [LearningManager hFromIndex:[LearningManager getIndexFromTime:selectedWord.startLearn.timeIntervalSinceReferenceDate]];
//               [[LocalNotificationManager sharedManager] sheduleNotificationThrough:h withMessage:@"Треба пройти треніровку"];
                [[CoreDataManager sharedManager] saveWordModels:@[selectedWord]];
            }
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate stopAnimation];
            completionBlock();
        });
    });
}

- (BOOL)isSelectedWord:(NSString *)word {
    for (WordModel *wordModel in self.selectedWords) {
        if ([wordModel.wordText isEqualToString:word]) {
            return YES;
        }
    }
    return NO;
}

@end
