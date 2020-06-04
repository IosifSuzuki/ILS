//
//  WordsPresenter.h
//  ILS
//
//  Created by admin on 17.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WordsDelegate <NSObject>

- (void)startAnimation;
- (void)stopAnimation;
- (void)allowSetupViewController;
- (void)enableSaveButton;
- (void)dissableSaveButton;

@end

@interface WordsPresenter : NSObject

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *descriptionText;

@property (assign, nonatomic) NSInteger selectedIndexOfWord;

- (instancetype)initWithDelegate:(id<WordsDelegate>)delegate;
- (NSString *)getWordAtIndex:(NSInteger)index;
- (void)addToSelectedWords;
- (void)fetchData;
- (void)saveWords;

@end

NS_ASSUME_NONNULL_END
