//
//  AnswerView.h
//  ILS
//
//  Created by admin on 23.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AnswerViewMode) {
    AnswerViewModeClassic,
    AnswerViewModeWithMultipleOptions,
};

@interface AnswerView : UIView

@property (assign, nonatomic) AnswerViewMode answerViewMode;

- (void)showAnswerViewFromView:(UIView *)view withAnswers:(NSArray<NSString *> *)answers indexRight:(NSInteger)index completionBlock:(nullable void (^)(void))completionBlock;

@end

NS_ASSUME_NONNULL_END
