//
//  ImaggaAPIManager.h
//  ILS
//
//  Created by admin on 28.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class WordModel;
@interface ImaggaAPIManager : NSObject

+ (instancetype)sharedManager;

- (void)purposeWordsFromImage:(NSString *)imageURL withCompletionBlock:(void (^)(NSArray<WordModel *> * _Nullable ))completionBlock;

@end

NS_ASSUME_NONNULL_END
