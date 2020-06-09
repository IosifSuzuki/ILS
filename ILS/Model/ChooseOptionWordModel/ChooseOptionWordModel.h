//
//  ChooseOptionWordModel.h
//  ILS
//
//  Created by admin on 07.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StatisticWordModel.h"
#import "WordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseOptionWordModel : NSObject

@property (strong, nonatomic) WordModel *wordModel;
@property (assign, nonatomic) NSInteger answerIndex;
@property (strong, nonatomic) NSString *optionAnswer1Text;
@property (strong, nonatomic) NSString *optionAnswer2Text;
@property (strong, nonatomic) NSString *optionAnswer3Text;
@property (strong, nonatomic) NSString *optionAnswer4Text;

+ (instancetype)creteChooseOptionWordModelWithWordModel:(WordModel *)wordModel optionAnswers:(NSArray<NSString *> *)optionAnswers;

@end

NS_ASSUME_NONNULL_END
