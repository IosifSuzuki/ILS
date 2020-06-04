//
//  WordCollectionViewCell.h
//  ILS
//
//  Created by admin on 26.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WordCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) NSString *textCell;
@property (strong, class, readonly, nonatomic) NSString *reusableIdentifier;

@end

NS_ASSUME_NONNULL_END
