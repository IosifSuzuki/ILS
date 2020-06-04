//
//  Word+CoreDataProperties.m
//  ILS
//
//  Created by admin on 04.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//
//

#import "Word+CoreDataProperties.h"

@implementation Word (CoreDataProperties)

+ (NSFetchRequest<Word *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Word"];
}

@dynamic delta;
@dynamic translatedWordText;
@dynamic wordId;
@dynamic wordText;
@dynamic xNegative;
@dynamic xPositive;
@dynamic startLearn;
@dynamic soundName;
@dynamic user;
@dynamic statisticWords;

@end
