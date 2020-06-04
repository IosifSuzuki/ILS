//
//  WebPresenter.m
//  ILS
//
//  Created by admin on 31.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "WebPresenter.h"

@interface WebPresenter()

@property (weak, nonatomic) id<WebDelegate> delegate;

@end

@implementation WebPresenter

- (instancetype)initWithDelegate:(id<WebDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - Accessor

- (void)setArticleModel:(ArticleModel *)articleModel {
    self->_articleModel = articleModel;
    
    self.titleArticle = articleModel.title;
    self.contentArticle = articleModel.content;
}

@end
