//
//  ILSButton.m
//  ILS
//
//  Created by admin on 02.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ILSButton.h"
#import "AppSupportClass.h"

@interface ILSButton()

@property (assign, nonatomic) CGFloat imageSide;
@property (assign, nonatomic) CGFloat padding;

@end

@implementation ILSButton

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
    self.imageSide = CGRectGetHeight(self.bounds) / 2.f;
    self.padding = self.imageSide * .4f;
}

- (void)prepareViewUI {
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOpacity = 1.f;
    self.layer.cornerRadius = ILSView_CornerRadius;
    self.clipsToBounds = NO;
}

#pragma mark - Override

- (CGRect) imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(
                      self.padding,
                      (CGRectGetHeight(self.bounds) - self.imageSide) / 2,
                      self.imageSide,
                      self.imageSide
                      );
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(
                      self.imageSide + self.padding * 2,
                      0,
                      CGRectGetWidth(self.bounds) - (self.imageSide + self.padding * 2),
                      CGRectGetHeight(self.bounds)
                      );
}

@end
