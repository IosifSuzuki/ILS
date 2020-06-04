//
//  WordPresenter.m
//  ILS
//
//  Created by admin on 12.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "WordPresenter.h"

@interface WordPresenter()

@property (weak, nonatomic) id<WordViewControllerDelegate> delegate;

@end

@implementation WordPresenter

- (instancetype)initWithDelegate:(id<WordViewControllerDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

@end
