//
//  WebPresenter.h
//  ILS
//
//  Created by admin on 31.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ArticleModel.h"

NS_ASSUME_NONNULL_BEGIN

@class WebPresenter;
@protocol WebDelegate <NSObject>

@property (strong, nonatomic) WebPresenter *presenter;

@end

@interface WebPresenter : NSObject

- (instancetype)initWithDelegate:(id<WebDelegate>)delegate;

@property (strong, nonatomic) ArticleModel *articleModel;

@property (strong, nonatomic) NSString *titleArticle;
@property (strong, nonatomic) NSString *contentArticle;

@end

NS_ASSUME_NONNULL_END
