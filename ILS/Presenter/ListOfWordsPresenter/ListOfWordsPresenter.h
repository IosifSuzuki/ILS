//
//  ListOfWordsPresenter.h
//  ILS
//
//  Created by admin on 11.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ListOfWordsPresenterDelegate <NSObject>

- (void)reloadData;

@end

@interface ListOfWordsPresenter<N> : NSObject

- (instancetype)initWithDelegate:(id<ListOfWordsPresenterDelegate>)delegate;

- (NSInteger)countDataSource;
- (NSString *)getWordAtIndex:(NSInteger)index;
- (NSString *)getTranslateWordsAtIndex:(NSInteger)index;
- (NSString *)getStartLearnAtIndex:(NSInteger)index;
- (BOOL)wordAtIndexNeededTrainAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
