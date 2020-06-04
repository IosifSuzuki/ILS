//
//  ProgressView.m
//  ILS
//
//  Created by admin on 23.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//
#import "AppSupportClass.h"

#import "ProgressView.h"

@implementation ProgressView

- (void)layoutSubviews {
    [super layoutSubviews];
    UIBezierPath *maskLayerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius: CGRectGetHeight(self.bounds) / 2.f];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskLayerPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
