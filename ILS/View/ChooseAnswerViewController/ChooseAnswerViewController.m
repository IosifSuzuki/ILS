//
//  ChooseAnswerViewController.m
//  ILS
//
//  Created by admin on 07.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ChooseAnswerViewController.h"
#import "MainNavigationController.h"
#import "LoaderView.h"
#import "AnswerView.h"

#import "ChooseAnswerPresenter.h"


@interface ChooseAnswerViewController () <ChooseAnswerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *textWordLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray<UIButton *> *optionButtons;

@property (strong, nonatomic) AnswerView *answerView;

@property (strong, nonatomic) ChooseAnswerPresenter *presenter;

@end

@implementation ChooseAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    [self setupController];
}

#pragma mark - Private

- (void)setupController {
    self.presenter = [[ChooseAnswerPresenter alloc] initWithDelegate:self];
    
    [self.presenter fetchData];
    
    self.answerView = [[AnswerView alloc] initWithFrame:self.view.bounds];
    
    self.title = self.presenter.titleText;
    
    [self updateScreen];
}

- (void)prepareUI {
    for (UIButton *optionButton in self.optionButtons) {
        optionButton.layer.cornerRadius = CGRectGetHeight(optionButton.bounds) / 2.f;
        optionButton.layer.borderWidth = 1.f;
        optionButton.layer.borderColor = UIColor.whiteColor.CGColor;
        optionButton.clipsToBounds = YES;
    }
}

- (void)updateScreen {
    self.textWordLabel.text = [self.presenter getWordText];
    for (UIButton *optionButton in self.optionButtons) {
        [optionButton setTitle:[self.presenter getOptionTextForType:optionButton.tag] forState:UIControlStateNormal];
    }
}

#pragma mark - Override

- (BOOL)showMenuBarButtonItem {
    return YES;
}

#pragma mark - Action

- (IBAction)tapToOptionButton:(UIButton *)optionButton {
    
    [self.presenter selectAnswer:optionButton.tag];
    [self updateScreen];
}

#pragma mark - ChooseAnswerDelegate

- (void)userCantStartTrainAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:self.presenter.okText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertViewController dismissViewControllerAnimated:NO completion:^{
            [(MainNavigationController *)self.navigationController showStartViewController];
        }];
    }];
    
    [alertViewController addAction:okAction];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

- (void)showAnswerWithAnswersWord:(NSArray *)answerWords selectedAnswerIndex:(NSInteger)selectedIndex correct:(BOOL)isCorrect {
    [self.answerView showAnswerViewFromView:self.view withAnswers:answerWords selectedIndex:selectedIndex isCorect:isCorrect completionBlock:^{
        
    }];
}

- (void)trainDidBeginEndWithTitle:(NSString *)title descriptionMessage:(NSString *)descriptionMessage {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:title message:descriptionMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:self.presenter.okText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertViewController dismissViewControllerAnimated:NO completion:^{
            [(MainNavigationController *)self.navigationController showStartViewController];
        }];
    }];
    
    [alertViewController addAction:okAction];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

- (void)startAnimation {
    [[LoaderView sharedInstance] startAnimationFromView:self.view];
}

- (void)stopAnimation {
    [[LoaderView sharedInstance] stopAnimation];
}


@end
