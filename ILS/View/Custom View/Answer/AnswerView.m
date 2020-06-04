//
//  AnswerView.m
//  ILS
//
//  Created by admin on 23.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "AnswerView.h"

#import "AppSupportClass.h"

static const NSString *kAnswerViewTrue = @"true";
static const NSString *kAnswerViewFalse = @"false";

@interface AnswerView()

@property (weak, nonatomic) IBOutlet UIView *transparentView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIStackView *answersStackView;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSString *trueText;
@property (strong, nonatomic) NSString *falseText;

@property (copy, nonatomic, nullable) void (^completionBlock)(void);
@property (strong, nonatomic) UIColor *notChoiceOptionColor;

@end

@implementation AnswerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    
    return self;
}

#pragma mark - Private

- (void)setupView {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AnswerView class]) owner:self options:nil];
    [self addSubview: self.transparentView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Answer" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.trueText = [data objectForKey:kAnswerViewTrue];
    self.falseText = [data objectForKey:kAnswerViewFalse];
    
    self.transparentView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:.5f];
    self.containerView.layer.cornerRadius = ILS_CornerRadius;
    self.containerView.clipsToBounds = YES;
    
    self.notChoiceOptionColor = AppSupportClass.declineColor;
}

#pragma mark - Action

- (IBAction)tapToUnusedArea:(UIGestureRecognizer *)sender {
    if (self.timer) {
        [self.timer invalidate];
    }
    [self removeFromSuperview];
    self.completionBlock();
    self.completionBlock = nil;
}

#pragma mark - Accessor

- (void)setAnswerViewMode:(AnswerViewMode)answerViewMode {
    switch (answerViewMode) {
        case AnswerViewModeClassic: {
            self.notChoiceOptionColor = AppSupportClass.declineColor;
        }
            break;
        case AnswerViewModeWithMultipleOptions: {
            self.notChoiceOptionColor = UIColor.grayColor;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Public

- (void)showAnswerViewFromView:(UIView *)view withAnswers:(NSArray<NSString *> *)answers indexRight:(NSInteger)index completionBlock:(void (^)(void))completionBlock {
    self.titleLabel.text = index >= 0 ? self.trueText : self.falseText;
    self.completionBlock = completionBlock;
    [view addSubview:self];
    CGFloat offsetY = CGRectGetHeight(self.containerView.bounds);
    self.containerView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - offsetY);
    self.alpha = 0.f;
    for (UIView *view in self.answersStackView.arrangedSubviews) {
        [view removeFromSuperview];
    }
    for (NSString *answer in answers) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = answer;
        if ([answers indexOfObject:answer] == index) {
            titleLabel.textColor = AppSupportClass.acceptColor;
        } else {
            titleLabel.textColor = self.notChoiceOptionColor;
        }
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        [self.answersStackView addArrangedSubview:titleLabel];
    }
    [UIView animateWithDuration:.5f delay:0.f usingSpringWithDamping:1.f initialSpringVelocity:2.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.f;
        self.containerView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) + offsetY);
    } completion:^(BOOL finished) {
        if (finished) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3.f repeats:NO block:^(NSTimer * _Nonnull timer) {
                self.timer = nil;
                [timer invalidate];
                [UIView animateWithDuration:.5f delay:0.f usingSpringWithDamping:1.f initialSpringVelocity:2.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.alpha = 0.f;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                    completionBlock();
                    self.completionBlock = nil;
                }];
            }];
        }
    }];
}

@end
