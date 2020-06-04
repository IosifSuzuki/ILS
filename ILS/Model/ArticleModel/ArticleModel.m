//
//  ArticleModel.m
//  ILS
//
//  Created by admin on 31.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

+ (instancetype)createArticleModelWithTitle:(NSString *)title content:(NSString *)content {
    ArticleModel *articleModel = [[ArticleModel alloc] init];
    
    articleModel.title = title;
    articleModel.content = content;
    
    return articleModel;
}

@end
