//
//  ILSTextField.m
//  ILS
//
//  Created by admin on 02.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ILSTextField.h"
#import "AppSupportClass.h"

@implementation ILSTextField

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self prepareViewUI];
    
}

#pragma mark - Private

- (void)setupView {
    
}

- (void)prepareViewUI {
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOpacity = 1.f;
    self.layer.cornerRadius = ILSView_CornerRadius;
    self.clipsToBounds = NO;
}

#pragma mark - Override

- (CGRect) textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(4, 4, 4, 4));
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(4, 4, 4, 4));
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(4, 4, 4, 4));
}

@end
