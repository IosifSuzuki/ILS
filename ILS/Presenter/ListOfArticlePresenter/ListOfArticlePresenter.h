//
//  ListOfArticlePresenter.h
//  ILS
//
//  Created by admin on 31.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WebPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ListOfArticleDelegate <NSObject>

- (void)reloadData;

@end

@interface ListOfArticlePresenter : NSObject

@property (strong, nonatomic) NSString *titleText;

@property (class, retain, readonly, nonatomic) NSString *cellIdentifier;

- (instancetype)initWithDelegate:(id<ListOfArticleDelegate>)delegate;
- (void)fetchData;
- (NSInteger)getCountOfArticles;
- (NSString *)getTitleAtIndex:(NSInteger)index;
- (void)preparePresenterForWebView:(id<WebDelegate>)webViewController atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
