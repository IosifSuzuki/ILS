//
//  ComposingSentencePresenter.h
//  ILS
//
//  Created by admin on 26.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ComposingSentenceDelegate <NSObject>

- (void)updateProgressViewWithProgress:(float)value;
- (void)reloadData;
- (void)startAnimation;
- (void)stopAnimation;
- (void)showAnswerWithSentence:(NSString *)sentence rightAnswer:(BOOL)isRight withCompletionBlock:(nullable void (^)(void))completionBlock;
- (void)showResult;

@end

@interface ComposingSentencePresenter : NSObject

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *alertTitleText;
@property (strong, nonatomic) NSString *alertDesctiptionText;
@property (strong, nonatomic) NSString *okText;

- (instancetype)initWithDelegate:(id<ComposingSentenceDelegate>)delegate;

- (void)fetchData;
- (void)moveWordsFromSourceIndex:(NSInteger)sourceIndex toDestinationIndex:(NSInteger)destinationIndex;
- (NSString *)getWordByIndex:(NSInteger)index;
- (NSString *)getOriginSentence;
- (NSInteger)numberOfWords;
- (void)updateProgressView;
- (void)checkSentence;


@end

NS_ASSUME_NONNULL_END
