//
//  LoaderView.m
//  ILS
//
//  Created by admin on 14.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LoaderView.h"

static const CGFloat kLoaderViewHeightLine = 50.f;
static const CGFloat kLoaderViewWidthLine = 20.f;
static const CGFloat kLoaderViewSpaceBetweenLine = 25.f;

@interface LoaderView()

@property (weak, nonatomic) IBOutlet UIView *transparentView;
@property (weak, nonatomic) IBOutlet UIView *containerLoadingView;
@property (weak, nonatomic) IBOutlet UIView *containerForAnimation;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@property (strong, nonatomic) NSString *snapshotLoadingLabelText;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation LoaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    
    return self;
}

#pragma mark - Private

- (void)setupView {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LoaderView class]) owner:self options:nil];
    [self addSubview: self.transparentView];
    
    self.snapshotLoadingLabelText = self.loadingLabel.text;
    
    self.transparentView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:.5f];
    self.containerLoadingView.layer.cornerRadius = 8.f;
    self.containerLoadingView.clipsToBounds = YES;
}

#pragma mark - Public

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LoaderView *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LoaderView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    });
    
    return sharedInstance;
}

- (void)updateLoadingLabel {
    if ([self.loadingLabel.text isEqualToString:self.snapshotLoadingLabelText]) {
        self.loadingLabel.text = [self.snapshotLoadingLabelText substringWithRange:NSMakeRange(0, self.snapshotLoadingLabelText.length - 3)];
    } else {
        self.loadingLabel.text = [self.loadingLabel.text stringByAppendingString:@"."];
    }
}

- (void)startAnimationFromView:(UIView *)view {
    [view addSubview:self];
    [view bringSubviewToFront:self];
    
    [self.containerForAnimation convertRect:self.containerForAnimation.bounds toView:self.transparentView];
    CGFloat centerX = CGRectGetMidX([self.containerForAnimation convertRect:self.containerForAnimation.bounds toView:self.transparentView]);
    CGFloat centerY = CGRectGetMaxY([self.containerForAnimation convertRect:self.containerForAnimation.bounds toView:self.transparentView]);
    
    CAShapeLayer *leftDotLayer = [CAShapeLayer layer];
    leftDotLayer.lineJoin = kCALineJoinBevel;
    leftDotLayer.lineWidth = kLoaderViewWidthLine;
    leftDotLayer.lineCap = kCALineCapRound;
    leftDotLayer.fillColor = UIColor.blueColor.CGColor;
    
    CAShapeLayer *midDotLayer = [CAShapeLayer layer];
    midDotLayer.lineJoin = kCALineJoinBevel;
    midDotLayer.lineWidth = kLoaderViewWidthLine;
    midDotLayer.lineCap = kCALineCapRound;
    midDotLayer.fillColor = UIColor.blueColor.CGColor;
    
    CAShapeLayer *rightDotLayer = [CAShapeLayer layer];
    rightDotLayer.lineJoin = kCALineJoinBevel;
    rightDotLayer.lineWidth = kLoaderViewWidthLine;
    rightDotLayer.lineCap = kCALineCapRound;
    rightDotLayer.fillColor = UIColor.blueColor.CGColor;
    
    UIBezierPath* leftDotPath = [UIBezierPath bezierPathWithOvalInRect:
        CGRectMake(centerX - kLoaderViewSpaceBetweenLine - kLoaderViewWidthLine / 2.f,
                   centerY - kLoaderViewHeightLine / 2.f,
                   kLoaderViewWidthLine,
                   kLoaderViewWidthLine)];
    leftDotLayer.path = leftDotPath.CGPath;
    
    UIBezierPath* midDotPath = [UIBezierPath bezierPathWithOvalInRect:
        CGRectMake(centerX - kLoaderViewWidthLine / 2.f,
                   centerY - kLoaderViewHeightLine / 2.f,
                   kLoaderViewWidthLine,
                   kLoaderViewWidthLine)];
    midDotLayer.path = midDotPath.CGPath;
    
    UIBezierPath* rightDotPath = [UIBezierPath bezierPathWithOvalInRect:
        CGRectMake(centerX + kLoaderViewSpaceBetweenLine - kLoaderViewWidthLine / 2.f,
                   centerY - kLoaderViewHeightLine / 2.f,
                   kLoaderViewWidthLine,
                   kLoaderViewWidthLine)];
    rightDotLayer.path = rightDotPath.CGPath;
    
    
    [self.layer addSublayer:leftDotLayer];
    [self.layer addSublayer:midDotLayer];
    [self.layer addSublayer:rightDotLayer];
    
    
    CABasicAnimation *leftDotAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.origin.y"];
    leftDotAnimation.toValue = @(40);
    
    CABasicAnimation *leftDotBackgroundAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    leftDotBackgroundAnimation.toValue = (id)UIColor.redColor.CGColor;
    
    CAAnimationGroup *groupLeftDotAnimation = [[CAAnimationGroup alloc] init];
    groupLeftDotAnimation.animations = @[leftDotAnimation, leftDotBackgroundAnimation];
    groupLeftDotAnimation.duration = .5f;
    groupLeftDotAnimation.beginTime = .10f;
    groupLeftDotAnimation.repeatCount = HUGE_VALF;
    groupLeftDotAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    groupLeftDotAnimation.autoreverses = YES;
    
    [leftDotLayer addAnimation:groupLeftDotAnimation forKey:@"positionAndBackground"];
    
    CABasicAnimation *midDotAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.origin.y"];
    midDotAnimation.toValue = @(40);
    
    CABasicAnimation *midDotBackgroundAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    midDotBackgroundAnimation.toValue = (id)UIColor.yellowColor.CGColor;
    
    CAAnimationGroup *groupMidDotAnimation = [[CAAnimationGroup alloc] init];
    groupMidDotAnimation.animations = @[midDotAnimation, midDotBackgroundAnimation];
    groupMidDotAnimation.duration = .5f;
    groupMidDotAnimation.beginTime = .20f;
    groupMidDotAnimation.repeatCount = HUGE_VALF;
    groupMidDotAnimation.duration = .5f;
    groupMidDotAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    groupMidDotAnimation.autoreverses = YES;
    
    [midDotLayer addAnimation:groupMidDotAnimation forKey:@"positionAndBackground"];
    
    CABasicAnimation *rightDotAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.origin.y"];
    rightDotAnimation.toValue = @(40);
    
    CABasicAnimation *rightDotBackgroundAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    rightDotBackgroundAnimation.toValue = (id)UIColor.greenColor.CGColor;
    
    CAAnimationGroup *groupRightDotAnimation = [[CAAnimationGroup alloc] init];
    groupRightDotAnimation.animations = @[rightDotAnimation, rightDotBackgroundAnimation];
    groupRightDotAnimation.duration = .5f;
    groupRightDotAnimation.beginTime = .30f;
    groupRightDotAnimation.repeatCount = HUGE_VALF;
    groupRightDotAnimation.duration = .5f;
    groupRightDotAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    groupRightDotAnimation.autoreverses = YES;
    
    [rightDotLayer addAnimation:groupRightDotAnimation forKey:@"positionAndBackground"];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(updateLoadingLabel) userInfo:nil repeats:YES];
}

- (void)stopAnimation {
    [self.timer invalidate];
    self.timer = nil;
    
    [self removeFromSuperview];
    
    for (NSInteger i = 0; i < self.layer.sublayers.count; i++) {
        CALayer *layer = [self.layer.sublayers objectAtIndex:i];
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
            i--;
        }
    }
}

@end
