//
//  TrainPresenter.h
//  ILS
//
//  Created by admin on 23.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TrainDelegate <NSObject>

- (void)showAnswerWithAnswersWord:(NSArray *)answerWords selectedAnswerIndex:(NSInteger)selectedIndex;
- (void)updateProgressViewWithValue:(double)value;
- (void)trainDidBeginEndWithTitle:(NSString *)title descriptionMessage:(NSString *)descriptionMessage;
- (void)updateTaskWithWord:(NSString *)word;
- (void)startAnimation;
- (void)stopAnimation;
- (void)makeCleanTextField;

@end

@interface TrainPresenter : NSObject

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *okText;

- (instancetype)initWithDelegate:(id<TrainDelegate>)delegate;

- (void)nextWord;
- (void)checkAnswerWithWord:(NSString *)word;
- (void)fetchData;


@end

NS_ASSUME_NONNULL_END
