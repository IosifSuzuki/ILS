//
//  SignUpViewController.m
//  ILS
//
//  Created by admin on 02.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignUpPresenter.h"

#import "FirebaseManager.h"

typedef NS_ENUM(NSUInteger, SignUpViewControllerBarButtonItemType ) {
    SignUpViewControllerBarButtonItemTypeBackward,
    SignUpViewControllerBarButtonItemTypeForward,
    SignUpViewControllerBarButtonItemTypeDone,
};

@interface SignUpViewController () <UITextFieldDelegate, SignUpViewControllerDelegate>

@property (strong, nonatomic) SignUpPresenter *presenter;

@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray<UITextField *> *collectionOfTextField;

@property (strong, nonatomic) UIToolbar *toolbar;

@property (assign, nonatomic) NSInteger selectedTextField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupController];
    [self registerNotificationForKeyboard];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerNotificationForKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Private

- (void)setupController {
    self.presenter = [[SignUpPresenter alloc] initWithDelegate:self];
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 50.f)];
    
    UIBarButtonItem *backwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_backward"] style:UIBarButtonItemStylePlain target:self action:@selector(tapToBarButtonItemInToolBar:)];
    backwardBarButtonItem.tag = (NSInteger)SignUpViewControllerBarButtonItemTypeBackward;
    backwardBarButtonItem.width = 20.f;
    
    UIBarButtonItem *forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_forward"] style:UIBarButtonItemStylePlain target:self action:@selector(tapToBarButtonItemInToolBar:)];
    forwardBarButtonItem.tag = (NSInteger)SignUpViewControllerBarButtonItemTypeForward;
    forwardBarButtonItem.width = 20.f;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapToBarButtonItemInToolBar:)];
    doneBarButtonItem.tag = (NSInteger)SignUpViewControllerBarButtonItemTypeDone;
    doneBarButtonItem.width = 20.f;
    
    self.toolbar.items = @[backwardBarButtonItem, forwardBarButtonItem, flexibleSpace, doneBarButtonItem];
    [self.toolbar sizeToFit];
    
    [self.scrollView addGestureRecognizer:self.tapGesture];
    
    for (UITextField *textField in self.collectionOfTextField) {
        textField.inputAccessoryView = self.toolbar;
    }
}

- (void)setupNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.backgroundColor = UIColor.clearColor;
}

- (void)registerNotificationForKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Action

- (IBAction)tapToScreen:(id)sender {
    [self.scrollView endEditing:YES];
}

- (IBAction)tapToBarButtonItemInToolBar:(UIBarButtonItem *)sender {
    BOOL showKeyboard = YES;
    
    switch ((SignUpViewControllerBarButtonItemType)sender.tag) {
        case SignUpViewControllerBarButtonItemTypeBackward: {
            self.selectedTextField--;
            self.selectedTextField = self.selectedTextField <  0 ? self.collectionOfTextField.count - 1 : self.selectedTextField;
        }
            break;
        case SignUpViewControllerBarButtonItemTypeForward: {
            self.selectedTextField++;
            self.selectedTextField = self.selectedTextField == self.collectionOfTextField.count ? 0 : self.selectedTextField;
        }
            break;
        case SignUpViewControllerBarButtonItemTypeDone: {
            showKeyboard = NO;
        }
            break;
    }
    
    for (UITextField *textField in self.collectionOfTextField) {
        if (textField.tag == self.selectedTextField) {
            if (showKeyboard) {
                [textField becomeFirstResponder];
            } else  {
                [textField resignFirstResponder];
            }
        }
    }
}

- (IBAction)tapToBackBarButtonItem:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapToCompleteButton:(UIButton *)sender {
    if ([self.presenter validateEmail:self.emailTextField.text password:self.passwordTextField.text repeatPassword:self.repeatPasswordTextField.text nickname:self.nicknameTextField.text]) {
        [[FirebaseManager sharedManager] createUserWithEmail:self.emailTextField.text password:self.passwordTextField.text nickname:self.nicknameTextField.text completionSuccerBlock:^(BOOL succerfull) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (succerfull) {
                    [self showAlertWithTitle:self.presenter.signUpWasSuccessfulText description:[NSString string] withCompletionBlock:^{
                        [self tapToBackBarButtonItem:nil];
                    }];
                } else {
                    [self showAlertWithTitle:self.presenter.errorSignUpText description:self.presenter.errorSignUpDetailText withCompletionBlock:nil];
                }
            });

        }];
    }
}

#pragma mark - SignUpViewControllerDelegate

- (void)showAlertWithTitle:(NSString *)title description:(NSString *)description withCompletionBlock:(void(^_Nullable)(void))completionBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:description preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:self.presenter.okText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completionBlock) {
            completionBlock();
        }
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.selectedTextField = textField.tag;
    [self.scrollView scrollRectToVisible:textField.superview.frame animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.scrollView scrollRectToVisible:CGRectZero animated:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)notofication {
    CGSize keyboardSize = [[[notofication userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height + CGRectGetHeight(self.toolbar.bounds), 0);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

@end
