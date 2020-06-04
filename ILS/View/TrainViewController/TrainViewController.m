//
//  TrainViewController.m
//  ILS
//
//  Created by admin on 23.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "TrainViewController.h"
#import "MainNavigationController.h"
#import "ProgressView.h"

#import "TrainPresenter.h"

#import "AnswerView.h"
#import "LoaderView.h"

#import "AppSupportClass.h"

@interface TrainViewController () <TrainDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerForTask;
@property (weak, nonatomic) IBOutlet UIButton *playAudioButton;
@property (weak, nonatomic) IBOutlet UILabel *rawWordLabel;
@property (weak, nonatomic) IBOutlet UITextField *translatedWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet ProgressView *progressView;

@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) AnswerView *answerView;

@property (strong, nonatomic) TrainPresenter *presenter;

@end

@implementation TrainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    [self setupViewController];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Private

- (void)prepareUI {
    self.acceptButton.layer.cornerRadius =
    self.skipButton.layer.cornerRadius = CGRectGetHeight(self.acceptButton.bounds) / 2.f;
    self.acceptButton.clipsToBounds =
    self.skipButton.clipsToBounds = YES;
    self.containerForTask.layer.cornerRadius = ILS_CornerRadius;
}

- (void)setupViewController {
    self.presenter = [[TrainPresenter alloc] initWithDelegate:self];
    [self.presenter fetchData];
    
    [self registerNotificationForKeyboard];
    
    self.answerView = [[AnswerView alloc] initWithFrame:self.view.bounds];
    self.answerView.answerViewMode = AnswerViewModeWithMultipleOptions;
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 50.f)];
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapToBarButtomItemDone:)];
    UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    doneBarButtonItem.width = 20.f;
    self.toolbar.items = @[flexibleSpaceButtonItem, doneBarButtonItem];
    [self.toolbar sizeToFit];
    
    self.translatedWordTextField.inputAccessoryView = self.toolbar;
    self.translatedWordTextField.delegate = self;
    
    self.title = self.presenter.titleText;
    self.playAudioButton.enabled = NO;
}

- (void)registerNotificationForKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Accessor

- (BOOL)showMenuBarButtonItem {
    return YES;
}

#pragma mark - Action

- (IBAction)tapToAcceptAnswerButton:(UIButton *)sender {
    [self.presenter checkAnswerWithWord:self.translatedWordTextField.text];
}

- (IBAction)tapToSkipAnswerButton:(UIButton *)sender {
    
}

- (IBAction)tapToBarButtomItemDone:(id)sender {
    [self.translatedWordTextField resignFirstResponder];
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)notofication {
    CGSize keyboardSize = [[[notofication userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height + CGRectGetHeight(self.toolbar.bounds), 0);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.scrollView scrollRectToVisible:textField.superview.frame animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.scrollView scrollRectToVisible:CGRectZero animated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - TrainDelegate

- (void)showAnswerWithAnswersWord:(NSArray *)answerWords selectedAnswerIndex:(NSInteger)selectedIndex {
    [self.translatedWordTextField resignFirstResponder];
    [self.answerView showAnswerViewFromView:self.view withAnswers:answerWords indexRight:selectedIndex completionBlock:^{
        [self.presenter nextWord];
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

- (void)updateProgressViewWithValue:(double)value {
    [self.progressView setProgress:value animated:YES];
}

- (void)updateTaskWithWord:(NSString *)word {
    self.rawWordLabel.text = word;
}

- (void)startAnimation {
    [[LoaderView sharedInstance] startAnimationFromView:self.view];
}

- (void)stopAnimation {
    [[LoaderView sharedInstance] stopAnimation];
}

- (void)makeCleanTextField {
    self.translatedWordTextField.text = [NSString string];
}

@end
