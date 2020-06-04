//
//  SentenceModel.m
//  ILS
//
//  Created by admin on 26.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "SentenceModel.h"

@implementation SentenceModel

@synthesize sentence = _sentence;

#pragma mark - Public

- (instancetype)initWithSentenceText:(NSString *)sentenceText {
    if (self = [super init]) {
        _orderedWordsInSentence = [sentenceText componentsSeparatedByString:@" "];
        _sentence = sentenceText;
    }
    
    return self;
}

+ (instancetype)createSentenceModel:(NSString *)sentenceText {
    SentenceModel *sentenceModel = [[SentenceModel alloc] initWithSentenceText:sentenceText];
    
    [sentenceModel prepareRandWordsForSentence];
    
    return sentenceModel;
}

- (void)prepareRandWordsForSentence {
    NSMutableArray *tmpWords = [NSMutableArray arrayWithArray:self.orderedWordsInSentence];
    NSMutableArray *randWords = [NSMutableArray array];
    
    for (NSInteger index = 0; index < self.orderedWordsInSentence.count; index++) {
        NSInteger randomIndex = arc4random_uniform((uint32_t)(self.orderedWordsInSentence.count - index));
        [randWords addObject:[tmpWords objectAtIndex:randomIndex]];
        [tmpWords removeObjectAtIndex:randomIndex];
    }
    
    self.randomWordsInSentence = [randWords copy];
}

#pragma mark - Assign

- (NSInteger)length {
    return self.orderedWordsInSentence.count;
}

- (NSString *)sentence {
    return _sentence;
}


@end
