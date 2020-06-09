//
//  ChooseOptionWordModel.m
//  ILS
//
//  Created by admin on 07.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ChooseOptionWordModel.h"

@implementation ChooseOptionWordModel

+ (instancetype)creteChooseOptionWordModelWithWordModel:(WordModel *)wordModel optionAnswers:(NSArray<NSString *> *)optionAnswers {
    ChooseOptionWordModel *chooseOptionWordModel = [[ChooseOptionWordModel alloc] init];
    chooseOptionWordModel.wordModel = wordModel;
    
    NSMutableArray<NSString *> *mutableOptionAnswers = [NSMutableArray arrayWithArray:optionAnswers];
    
    NSInteger destIndex = arc4random_uniform(4);
    [mutableOptionAnswers exchangeObjectAtIndex:0 withObjectAtIndex:destIndex];
    chooseOptionWordModel.answerIndex = destIndex;
    chooseOptionWordModel.optionAnswer1Text = [mutableOptionAnswers objectAtIndex:0];
    chooseOptionWordModel.optionAnswer2Text = [mutableOptionAnswers objectAtIndex:1];
    chooseOptionWordModel.optionAnswer3Text = [mutableOptionAnswers objectAtIndex:2];
    chooseOptionWordModel.optionAnswer4Text = [mutableOptionAnswers objectAtIndex:3];
    
    return chooseOptionWordModel;
}

@end
