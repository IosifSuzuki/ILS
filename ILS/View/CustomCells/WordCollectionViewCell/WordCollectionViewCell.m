//
//  WordCollectionViewCell.m
//  ILS
//
//  Created by admin on 26.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "WordCollectionViewCell.h"

@interface WordCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *textCellLabel;

@end

@implementation WordCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self prepareCellUI];
}

#pragma mark - Private

- (void)prepareCellUI {
    self.contentView.layer.cornerRadius = 4.f;
    self.contentView.clipsToBounds = YES;
}

#pragma mark - Accessor

- (void)setTextCell:(NSString *)textCell {
    self.textCellLabel.text = textCell;
}

+ (NSString *)reusableIdentifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass([WordCollectionViewCell class])];
}

@end
