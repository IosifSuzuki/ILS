//
//  ProposeWordsPresenter.h
//  ILS
//
//  Created by admin on 28.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ProposeWordsPresenter;
@protocol ProposeWordsDelegate <NSObject>

@property (strong, nonatomic) ProposeWordsPresenter *presenter;

- (void)startAnimation;
- (void)stopAnimation;
- (void)enableSaveButton:(BOOL)enabled;

@end

@class WordModel;
@interface ProposeWordsPresenter : NSObject

@property (strong, nonatomic) NSArray<WordModel *> *proposeWords;

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *alertTitle;
@property (strong, nonatomic) NSString *alertMessage;
@property (strong, nonatomic) NSString *okText;

@property (weak, class, readonly, nonatomic) NSString *reuseIdentifier;

- (instancetype)initWithDelegate:(id<ProposeWordsDelegate>)delegate;
- (NSString *)getWordAtIndex:(NSInteger)index;
- (NSString *)getTranslatedWord:(NSInteger)index;
- (void)selectObjectAtIndex:(NSInteger)index;
- (void)deselectObjectAtIndex:(NSInteger)index;
- (void)saveWordsWithCompletionBlock:(void (^)(void))completionBlock;
- (BOOL)isSelectedWord:(NSString *)word;

@end

NS_ASSUME_NONNULL_END
