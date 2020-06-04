//
//  Article+CoreDataProperties.m
//  ILS
//
//  Created by admin on 04.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//
//

#import "Article+CoreDataProperties.h"

@implementation Article (CoreDataProperties)

+ (NSFetchRequest<Article *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Article"];
}

@dynamic content;
@dynamic title;

@end
