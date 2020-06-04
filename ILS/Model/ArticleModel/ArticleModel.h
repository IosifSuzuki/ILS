//
//  ArticleModel.h
//  ILS
//
//  Created by admin on 31.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArticleModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;

+ (instancetype)createArticleModelWithTitle:(NSString *)title content:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
