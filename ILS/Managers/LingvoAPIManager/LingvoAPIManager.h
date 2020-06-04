//
//  LingvoAPIManager.h
//  ILS
//
//  Created by admin on 17.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WordModel;

NS_ASSUME_NONNULL_BEGIN

@interface LingvoAPIManager : NSObject

+ (instancetype)sharedManager;

- (void)beginAuthenticateService:(void (^)(BOOL))completionBlock;
- (void)translateWord:(NSString *)word withCompletionBlock:(void (^)(WordModel * _Nullable))completionBlock;

@end

NS_ASSUME_NONNULL_END
