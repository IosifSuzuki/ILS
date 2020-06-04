//
//  ViewController.m
//  ILS
//
//  Created by admin on 02.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "SignInViewController.h"
#import "SignInPresenter.h"
#import "LoaderView.h"

#import "FirebaseManager.h"
#import "CoreDataManager.h"
#import "LingvoAPIManager.h"

#import "UserModel.h"

#import "User+CoreDataClass.h"

#import "AppSupportClass.h"

typedef NS_ENUM(NSUInteger, SignInViewControllerBarButtonItemType) {
    SignInViewControllerBarButtonItemTypeBackward,
    SignInViewControllerBarButtonItemTypeForward,
    SignInViewControllerBarButtonItemTypeDone,
};

typedef NS_ENUM(NSUInteger, SignInViewControllerButtonCompletionType) {
    SignInViewControllerButtonCompletionTypeILS,
    SignInViewControllerButtonCompletionTypeGoogle,
};

static NSString *const kSegueLaunchViewControllerIdentifier = @"SegueLaunchViewControllerIdentifier";

@interface SignInViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, SignInProtocol>

@property (strong, nonatomic) SignInPresenter *presenter;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *remeberMeTextField;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray <UITextField *> *collectionOfTextField;

@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UIPickerView *pickerView;

@property (assign, nonatomic) NSInteger selectedTextField;
@property (strong, nonatomic) NSArray <NSString *> *dataSourceOfPickerView;
@property (strong, nonatomic) NSString *selectedOptionInPickerView;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewController];
    [self prepareUI];
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

- (void)setupViewController {
    self.presenter = [[SignInPresenter alloc] initWithDelegate:self];
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 50.f)];
    
    UIBarButtonItem *backwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_backward"] style:UIBarButtonItemStylePlain target:self action:@selector(tapToBarButtonItemInToolBar:)];
    backwardBarButtonItem.tag = (NSInteger)SignInViewControllerBarButtonItemTypeBackward;
    backwardBarButtonItem.width = 20.f;
    
    UIBarButtonItem *forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_forward"] style:UIBarButtonItemStylePlain target:self action:@selector(tapToBarButtonItemInToolBar:)];
    forwardBarButtonItem.tag = (NSInteger)SignInViewControllerBarButtonItemTypeForward;
    forwardBarButtonItem.width = 20.f;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapToBarButtonItemInToolBar:)];
    doneBarButtonItem.tag = (NSInteger)SignInViewControllerBarButtonItemTypeDone;
    doneBarButtonItem.width = 20.f;
    
    self.toolbar.items = @[backwardBarButtonItem, forwardBarButtonItem, flexibleSpace, doneBarButtonItem];
    [self.toolbar sizeToFit];
    
    self.remeberMeTextField.inputAccessoryView =
    self.emailTextField.inputAccessoryView =
    self.passwordTextField.inputAccessoryView = self.toolbar;
    
    [self.scrollView addGestureRecognizer:self.tapGesture];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 150.f)];
    [self.pickerView sizeToFit];
    self.pickerView.delegate = self;
    self.remeberMeTextField.inputView = self.pickerView;
    self.dataSourceOfPickerView = [NSArray arrayWithObjects:self.presenter.noText, self.presenter.yesText, nil];
    
    BOOL rememberMe = [[[NSUserDefaults standardUserDefaults] objectForKey:kSignInViewControllerRememberMe] boolValue];
    self.selectedOptionInPickerView = [self.dataSourceOfPickerView objectAtIndex:(NSInteger)rememberMe];
    [self.pickerView selectRow:(NSInteger)rememberMe inComponent:0 animated:NO];
    if (rememberMe) {
        [self setTextInRememberMeTextField:[self.dataSourceOfPickerView objectAtIndex:(NSInteger)rememberMe]];
        self.emailTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kSignInViewControllerLoginText];
    }
}

- (void)prepareUI {
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)registerNotificationForKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setTextInRememberMeTextField:(NSString *)answer {
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc]
                                                  initWithString:[NSString stringWithFormat:SignInPresenter.templateForRememberLogin, answer]];
    [mutableAttributeString addAttribute:NSUnderlineStyleAttributeName
                                   value:[NSNumber numberWithInt:1]
                                   range:NSMakeRange(0, mutableAttributeString.length - answer.length - 2)];
    self.remeberMeTextField.attributedText = [mutableAttributeString copy];
}

- (void)showAlertWithTitle:(NSString *)title description:(NSString *)description {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:description preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:self.presenter.okText style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Override

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Action

- (IBAction)tapToScreen:(id)sender {
    [self.scrollView endEditing:YES];
}

- (IBAction)tapToBarButtonItemInToolBar:(UIBarButtonItem *)sender {
    BOOL showKeyboard = YES;
    
    switch ((SignInViewControllerBarButtonItemType)sender.tag) {
        case SignInViewControllerBarButtonItemTypeBackward: {
            self.selectedTextField--;
            self.selectedTextField = self.selectedTextField <  0 ? self.collectionOfTextField.count - 1 : self.selectedTextField;
        }
            break;
        case SignInViewControllerBarButtonItemTypeForward: {
            self.selectedTextField++;
            self.selectedTextField = self.selectedTextField == self.collectionOfTextField.count ? 0 : self.selectedTextField;
        }
            break;
        case SignInViewControllerBarButtonItemTypeDone: {
            showKeyboard = NO;
            
            if (self.selectedTextField == self.collectionOfTextField.count - 1) {
                [self setTextInRememberMeTextField:self.selectedOptionInPickerView];
            }
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

- (IBAction)tapToCompletionButton:(UIButton *)sender {
    switch ((SignInViewControllerButtonCompletionType)sender.tag) {
        case SignInViewControllerButtonCompletionTypeILS: {
            typeof(self) weakSelf = self;
            __block BOOL isError = NO;
            dispatch_group_t group = dispatch_group_create();
            [[LoaderView sharedInstance] startAnimationFromView:self.view];
            
            BOOL rememberMe = NO;
            NSString *loginText = [NSString string];
            
            if (self.selectedOptionInPickerView == self.dataSourceOfPickerView.lastObject) {
                 rememberMe = YES;
                 loginText = self.emailTextField.text;
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:@(rememberMe) forKey:kSignInViewControllerRememberMe];
            [[NSUserDefaults standardUserDefaults] setObject:loginText forKey:kSignInViewControllerLoginText];
            
            dispatch_group_enter(group);
            [[LoaderView sharedInstance] startAnimationFromView:self.view];
            [[FirebaseManager sharedManager] signInUserWithEmail:self.emailTextField.text password:self.passwordTextField.text completionSuccerBlock:^(BOOL succerfull) {
            }];
            
            dispatch_group_enter(group);
            [[LingvoAPIManager sharedManager] beginAuthenticateService:^(BOOL succerfull) {
                isError = !succerfull;
                dispatch_group_leave(group);
            }];
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                if (!isError) {
                    [weakSelf performSegueWithIdentifier:kSegueLaunchViewControllerIdentifier sender:nil];
                } else {
                    [weakSelf showAlertWithTitle:self.presenter.errorAuthorization description:self.presenter.errorGredentialsText];
                }
            });
        }
            break;
        case SignInViewControllerButtonCompletionTypeGoogle: {
            typeof(self) weakSelf = self;
            __block BOOL isError = NO;
            
            [[LoaderView sharedInstance] startAnimationFromView:self.view];
            [[FirebaseManager sharedManager] signInUserWithGoogleFromController:self completionSuccerBlock:^(BOOL succerfull) {
                isError = NO;
                dispatch_group_t group = dispatch_group_create();
                NSString *userId = [[[CoreDataManager sharedManager] userModel] userId];
                
                dispatch_group_enter(group);
                [[LingvoAPIManager sharedManager] beginAuthenticateService:^(BOOL succerfull) {
                    isError = !succerfull;
                    dispatch_group_leave(group);
                }];
                
                dispatch_group_enter(group);
                [[FirebaseManager sharedManager] getArticlesWithCompletionBlock:^(NSArray<ArticleModel *> *articleModels) {
                    isError = NO;
                    [[CoreDataManager sharedManager] saveArticleModels:articleModels];
                    dispatch_group_leave(group);
                }];
                
                dispatch_group_enter(group);
                [[FirebaseManager sharedManager] getWordsWithUserId:userId withCompletionBlock:^(NSArray<WordModel *> *wordModels) {
                    isError = NO;
                    [[CoreDataManager sharedManager] saveWordModels:wordModels];
                    dispatch_group_leave(group);
                }];
                
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                    [[LoaderView sharedInstance] stopAnimation];
                    if (!isError) {
                        [weakSelf performSegueWithIdentifier:kSegueLaunchViewControllerIdentifier sender:nil];
                    } else {
                        [weakSelf showAlertWithTitle:self.presenter.errorGredentialsText description:[NSString string]];
                    }
                });
            }];
            
        }
            break;
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.selectedTextField = textField.tag;
    
    [self.scrollView scrollRectToVisible:textField.superview.frame animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.scrollView scrollRectToVisible:textField.superview.frame animated:YES];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}


#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.dataSourceOfPickerView objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedOptionInPickerView = [self.dataSourceOfPickerView objectAtIndex:row];
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
