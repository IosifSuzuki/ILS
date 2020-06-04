//
//  WordsPresenter.m
//  ILS
//
//  Created by admin on 17.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "WordsPresenter.h"

#import "FirebaseManager.h"
#import "RandomWordApiManager.h"
#import "LingvoAPIManager.h"
#import "LocalNotificationManager.h"
#import "LearningManager.h"

#import "CoreDataManager.h"

#import "UserModel.h"
#import "WordModel.h"

static NSString *const kWordsPresenterTitle = @"title";
static NSString *const kWordsPresenterDescription = @"description";

@interface WordsPresenter()

@property (weak, nonatomic) id<WordsDelegate> delegate;
@property (strong, nonatomic) UserModel *userModel;

@property (strong, nonatomic) NSArray<NSString *> *words;
@property (strong, nonatomic) NSArray<NSString *> *selectedWords;

@end

@implementation WordsPresenter

- (instancetype)initWithDelegate:(id<WordsDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        
        [self setupPresenter];
    }
    return self;
}

#pragma mark - Private

- (void)setupPresenter {
    self.selectedWords = [NSArray array];
    
    self.userModel = [[CoreDataManager sharedManager] userModel];
    [self fetchScreenData];
}

- (void)fetchScreenData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Words" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.titleText = [data objectForKey:kWordsPresenterTitle];;
    self.descriptionText = [data objectForKey:kWordsPresenterDescription];
}

#pragma mark - Public

- (void)fetchData {
    RandomWordApiManager *manager = [RandomWordApiManager sharedManager];
   
    [self.delegate startAnimation];
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:manager.getURLStandartPacketRandomWords
      cachePolicy:NSURLRequestUseProtocolCachePolicy
      timeoutInterval:10.0];
   [request setHTTPMethod:@"GET"];

   NSURLSession *session = [NSURLSession sharedSession];
   [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
     if (error) {
         NSLog(@"%@", error);
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.delegate stopAnimation];
         });
     } else {
         self.words = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSLog(@"%@", self.words);
         dispatch_async(dispatch_get_main_queue(), ^{
             self.selectedIndexOfWord = 0;
             [self.delegate allowSetupViewController];
             [self.delegate stopAnimation];
         });
     }
   }] resume];
}

- (void)saveWords {
    [self.delegate startAnimation];
    
    dispatch_group_t group = dispatch_group_create();
    for (NSString *word in self.selectedWords) {
        dispatch_group_enter(group);
        [[LingvoAPIManager sharedManager] translateWord:word withCompletionBlock:^(WordModel *wordModel) {
            [[FirebaseManager sharedManager] addWord:wordModel toUserId:self.userModel.userId withCompletionBlock:^(NSArray<StatisticWordModel *> *statisticWordModels) {
                if (wordModel.translatedWordText) {
                    //NSTimeInterval h = [LearningManager hFromIndex:[LearningManager getIndexFromTime:wordModel.startLearn.timeIntervalSinceReferenceDate]];
                    [[LocalNotificationManager sharedManager] sheduleNotificationThrough:5 withMessage:@"Треба пройти треніровку"];
                    [[CoreDataManager sharedManager] saveWordModels:@[wordModel]];
                }
                dispatch_group_leave(group);
            }];
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.delegate stopAnimation];
        self.selectedWords = [[NSArray alloc] init];
        [self.delegate dissableSaveButton];
    });
}

- (NSString *)getWordAtIndex:(NSInteger)index {
    return [self.words objectAtIndex:index];
}

- (void)addToSelectedWords {
    [self.delegate enableSaveButton];
    
    NSMutableArray<NSString *> *mutableSelectedWords = [NSMutableArray arrayWithArray:self.selectedWords];
    [mutableSelectedWords addObject:[self.words objectAtIndex:self.selectedIndexOfWord]];
    self.selectedWords = [mutableSelectedWords copy];
}


@end
