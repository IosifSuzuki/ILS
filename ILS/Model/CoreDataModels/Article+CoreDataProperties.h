//
//  Article+CoreDataProperties.h
//  ILS
//
//  Created by admin on 04.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//
//

#import "Article+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Article (CoreDataProperties)

+ (NSFetchRequest<Article *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
