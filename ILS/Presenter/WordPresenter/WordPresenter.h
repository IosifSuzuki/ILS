//
//  WordPresenter.h
//  ILS
//
//  Created by admin on 12.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WordViewControllerDelegate <NSObject>

@end

@interface WordPresenter : NSObject

- (instancetype)initWithDelegate:(id<WordViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
