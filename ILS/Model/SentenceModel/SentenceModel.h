//
//  SentenceModel.h
//  ILS
//
//  Created by admin on 26.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SentenceModel : NSObject

@property (assign, readonly, nonatomic) NSInteger length;
@property (strong, nonatomic) NSArray<NSString *> *orderedWordsInSentence;
@property (strong, nonatomic) NSArray<NSString *> *randomWordsInSentence;
@property (strong, readonly, nonatomic) NSString *sentence;

+ (instancetype)createSentenceModel:(NSString *)sentenceText;

@end

NS_ASSUME_NONNULL_END
