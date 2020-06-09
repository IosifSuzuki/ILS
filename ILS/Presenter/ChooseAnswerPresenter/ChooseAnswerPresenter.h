//
//  ChooseAnswerPresenter.h
//  ILS
//
//  Created by admin on 07.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OptionType) {
    OptionText1,
    OptionText2,
    OptionText3,
    OptionText4,
};

@protocol ChooseAnswerDelegate <NSObject>

- (void)startAnimation;
- (void)stopAnimation;
- (void)selectAnswer:(NSInteger)answerIndex;
- (void)userCantStartTrainAlertWithTitle:(NSString *)titleAnswer message:(NSString *)message;
- (void)showAnswerWithAnswersWord:(NSArray *)answerWords selectedAnswerIndex:(NSInteger)selectedIndex correct:(BOOL)isCorrect;
- (void)trainDidBeginEndWithTitle:(NSString *)title descriptionMessage:(NSString *)descriptionMessage;

@end

@interface ChooseAnswerPresenter : NSObject

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *okText;

- (instancetype)initWithDelegate:(id<ChooseAnswerDelegate>)delegate;

- (void)fetchData;
- (NSString *)getWordText;
- (NSString *)getOptionTextForType:(OptionType)optionType;
- (void)selectAnswer:(NSInteger)answerType;

@end

NS_ASSUME_NONNULL_END
