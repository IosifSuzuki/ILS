//
//  ComposingSentencePresenter.m
//  ILS
//
//  Created by admin on 26.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ComposingSentencePresenter.h"

#import "FirebaseManager.h"
#import "CoreDataManager.h"

#import "SentenceModel.h"

static NSString *const kComposingSentencePresenterTitle = @"title";
static NSString *const kComposingSentencePresenterAlertTitle = @"alertTitle";
static NSString *const kComposingSentencePresenterAlertDescription = @"alertDescription";
static NSString *const kComposingSentencePresenterOk = @"ok";

@interface ComposingSentencePresenter()

@property (weak, nonatomic) id<ComposingSentenceDelegate> delegate;
@property (strong, nonatomic) NSArray<SentenceModel *> *dataSource;
@property (strong, nonatomic) NSArray<NSString *> *currentSentence;
@property (assign, nonatomic) NSInteger selectedDataSourceIndex;

@property (assign, nonatomic) NSInteger balls;

@property (strong, nonatomic) NSString *templateAlertDescription;

@end

@implementation ComposingSentencePresenter

- (instancetype)initWithDelegate:(id<ComposingSentenceDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        
        [self setupPresenter];
    }
    return self;
}

#pragma mark - Private

- (void)setupPresenter {
    [self fetchScreenData];
    
    self.balls = 0;
}

- (void)fetchScreenData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ComposingSentence" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.titleText = [data objectForKey:kComposingSentencePresenterTitle];
    self.alertTitleText = [data objectForKey:kComposingSentencePresenterAlertTitle];
    self.templateAlertDescription = [data objectForKey:kComposingSentencePresenterAlertDescription];
    self.okText = [data objectForKey:kComposingSentencePresenterOk];
}

- (void)fetchData {
    [self.delegate startAnimation];
    
    [[FirebaseManager sharedManager] getSentencesWithCompletionBlock:^(NSArray<NSString *> *sentencesText) {
        NSMutableArray<SentenceModel *> *mutableSentenceModels = [[NSMutableArray alloc] initWithCapacity:FirebaseManager.maxSentences * 2];
        for (NSString *sentence in sentencesText) {
            [mutableSentenceModels addObject:[SentenceModel createSentenceModel:sentence]];
            [mutableSentenceModels addObject:[SentenceModel createSentenceModel:sentence]];
        }
        NSMutableArray *mixingSentences = [[NSMutableArray alloc] init];
        
        for (NSInteger index = 0; index < FirebaseManager.maxSentences * 2; index++) {
            NSInteger randomIndex = arc4random_uniform((uint32_t)mutableSentenceModels.count);
            [mixingSentences addObject:[mutableSentenceModels objectAtIndex:randomIndex]];
            [mutableSentenceModels removeObjectAtIndex:randomIndex];
        }
        
        self.dataSource = [mixingSentences copy];
        self.currentSentence = [[self.dataSource objectAtIndex:self.selectedDataSourceIndex] randomWordsInSentence];
        [self updateProgressView];
        [self.delegate stopAnimation];
        [self.delegate reloadData];
    }];
    
    self.dataSource = [NSArray array];
    
    self.selectedDataSourceIndex = 0;
}

- (BOOL)checkAnswer {
    [self updateProgressView];
    NSArray<NSString *> *rightSentenceWithWords = [[self.dataSource objectAtIndex:self.selectedDataSourceIndex] orderedWordsInSentence];
    for (NSInteger index = 0; index < rightSentenceWithWords.count; index++) {
        if (![[rightSentenceWithWords objectAtIndex:index] isEqualToString:[self.currentSentence objectAtIndex:index]]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Public

- (void)moveWordsFromSourceIndex:(NSInteger)sourceIndex toDestinationIndex:(NSInteger)destinationIndex {
    NSLog(@"%@", self.currentSentence);
    NSString *srcWord = [self.currentSentence objectAtIndex:sourceIndex];
    NSMutableArray *mutableCurrentSentence = [NSMutableArray arrayWithArray:self.currentSentence];
    [mutableCurrentSentence removeObjectAtIndex:sourceIndex];
    [mutableCurrentSentence insertObject:srcWord atIndex:destinationIndex];
    self.currentSentence = [mutableCurrentSentence copy];
    NSLog(@"%@", self.currentSentence);
}

- (NSString *)getWordByIndex:(NSInteger)index {
    return [self.currentSentence objectAtIndex:index];
}

- (NSString *)getOriginSentence {
    return [[self.dataSource objectAtIndex:self.selectedDataSourceIndex] sentence];
}

- (NSInteger)numberOfWords {
    if (self.dataSource.count) {
        return [[self.dataSource objectAtIndex:self.selectedDataSourceIndex] length];
    }
    return 0;
}

- (void)updateProgressView {
    float progress = (float)(self.selectedDataSourceIndex + 1) / self.dataSource.count;
    [self.delegate updateProgressViewWithProgress:progress];
}

- (void)checkSentence {
    [self updateProgressView];
    BOOL rightAnswer = NO;
    if ([self checkAnswer]) {
        rightAnswer = YES;
        self.balls++;
    }
    
    if (self.selectedDataSourceIndex == self.dataSource.count - 1) {
        [self.delegate startAnimation];
        NSString *userId = [[CoreDataManager sharedManager] addUserBalls:self.balls];
        [[FirebaseManager sharedManager] updateBallsWithId:userId balls:self.balls withCompletionBlock:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate stopAnimation];
                
                [self.delegate showAnswerWithSentence:[[self.dataSource objectAtIndex:self.selectedDataSourceIndex] sentence] rightAnswer:rightAnswer withCompletionBlock:^{
                    self.alertDesctiptionText = [NSString stringWithFormat:self.templateAlertDescription, self.balls];
                    [self.delegate showResult];
                }];
            });
        }];
    } else {
        [self.delegate showAnswerWithSentence:[[self.dataSource objectAtIndex:self.selectedDataSourceIndex] sentence] rightAnswer:rightAnswer withCompletionBlock:nil];
        self.currentSentence = [[self.dataSource objectAtIndex:++self.selectedDataSourceIndex] randomWordsInSentence];
        [self.delegate reloadData];
    }
}

@end
