//
//  RandomWordApiManager.h
//  ILS
//
//  Created by admin on 12.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RandomWordApiManager : NSObject

@property (class, assign, readonly, nonatomic) NSInteger wordsForStandartPacket;

+ (instancetype)sharedManager;
- (NSURL *)getURLStandartPacketRandomWords;

@end

NS_ASSUME_NONNULL_END
