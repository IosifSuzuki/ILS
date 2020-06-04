//
//  RandomWordApiManager.m
//  ILS
//
//  Created by admin on 12.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "RandomWordApiManager.h"

NSString *const PRESFIX_RANDOM_WORD_API = @"https://random-word-api.herokuapp.com";

@implementation RandomWordApiManager

- (instancetype)init {
    if (self = [super init]) {
        //empty
    }
    
    return self;
}


#pragma mark - Public

+ (instancetype)sharedManager {
    static RandomWordApiManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RandomWordApiManager alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Accessor

+ (NSInteger)wordsForStandartPacket {
    return 100;
}

- (NSURL *)getURLStandartPacketRandomWords {
    NSString *reguestString = [NSString stringWithFormat:@"%@/word?number=%ld", PRESFIX_RANDOM_WORD_API, RandomWordApiManager.wordsForStandartPacket];
    return [NSURL URLWithString:reguestString];
}

@end
