//
//  MainMenuViewController.m
//  ILS
//
//  Created by admin on 11.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MainNavigationController.h"
#import "ProfileViewController.h"
#import "ListOfWordsViewController.h"
#import "TrainViewController.h"
#import "ComposingSentenceViewController.h"
#import "RecognizeImageViewController.h"
#import "RatingViewController.h"
#import "ListOfArticleTableViewController.h"

#import "WordsPageViewController.h"

static NSString *const kMainMenuViewControllerTitleAlert = @"alertTitle";
static NSString *const kMainMenuViewControllerMessageAlert = @"alertMessage";
static NSString *const kMainMenuViewControllerYes = @"yes";
static NSString *const kMainMenuViewControllerNo = @"no";

@interface MainMenuViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *containerMenu;

@property (strong, nonatomic) UIAlertController *alertController;

@end

typedef NS_ENUM(NSUInteger, MainMenuViewControllerMenuItem) {
    MainMenuViewControllerMenuItemProfile,
    MainMenuViewControllerMenuItemMyWords,
    MainMenuViewControllerMenuItemTheoria,
    MainMenuViewControllerMenuItemTraining,
    MainMenuViewControllerMenuItemSearchWords,
    MainMenuViewControllerMenuItemRating,
    MainMenuViewControllerMenuItemSearchWordOnCamera,
    MainMenuViewControllerMenuItemComposingSentence,
    MainMenuViewControllerMenuItemLogout,
};

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    [self setupController];
}

#pragma mark - Private

- (void)prepareUI {
    self.containerMenu.layer.shadowOffset = CGSizeMake(1, 0);
    self.containerMenu.layer.shadowColor = UIColor.blackColor.CGColor;
    self.containerMenu.layer.shadowOpacity = .3f;
}

- (UIViewController *)getViewControllerForClass:(Class)class {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(class)];
}

- (void)setupController {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MainMenu" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString *titleAlert = [data objectForKey:kMainMenuViewControllerTitleAlert];
    NSString *messageAlert = [data objectForKey:kMainMenuViewControllerMessageAlert];
    NSString *yesText = [data objectForKey:kMainMenuViewControllerYes];
    NSString *noText = [data objectForKey:kMainMenuViewControllerNo];
    
    self.alertController = [UIAlertController alertControllerWithTitle:titleAlert message:messageAlert preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:yesText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.fromNavigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:noText style:UIAlertActionStyleCancel handler:nil];
    
    [self.alertController addAction:yesAction];
    [self.alertController addAction:noAction];
}

#pragma mark - Public

- (void)showMenuAnimated:(BOOL)animated withCompletionBlock:(void (^ _Nullable)(void))completionBlock {
    [self.view setNeedsUpdateConstraints];
    self.leftLayoutConstraint.constant = 0;
    
    if (animated) {
        [UIView animateWithDuration:0.5f delay:0.2f usingSpringWithDamping:1.f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveLinear animations:^ {
            
            self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:.3f];
            
            [self.view layoutIfNeeded];
        } completion:^(BOOL completed) {
            if (completionBlock) {
                if (completed) {
                    completionBlock();
                }
            }
        }];
    } else {
        [self.view layoutIfNeeded];
    }
}

- (void)closeMenuAnimated:(BOOL)animated withCompletionBlock:(void (^ _Nullable)(void))completionBlock {
    [self.view setNeedsUpdateConstraints];
    
    self.leftLayoutConstraint.constant = -CGRectGetWidth(self.containerMenu.bounds);
    
    if (animated) {
        [UIView animateWithDuration:0.5f delay:0.2f usingSpringWithDamping:1.f initialSpringVelocity:2.f options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:.0f];
            [self.view layoutIfNeeded];
        } completion:^(BOOL completed) {
            if (completionBlock) {
                if (completed) {
                    completionBlock();
                }
            }
        }];
    } else {
        [self.view layoutIfNeeded];
    }
}

#pragma mark - Action

- (IBAction)tapToItemMenu:(UIControl *)sender {
    [self closeMenuAnimated:YES withCompletionBlock:^{
        UIViewController *viewController;
        switch ((MainMenuViewControllerMenuItem)sender.tag) {
            case MainMenuViewControllerMenuItemProfile: {
                viewController = [self getViewControllerForClass:[ProfileViewController class]];
            }
                break;
            case MainMenuViewControllerMenuItemMyWords: {
                viewController = [self getViewControllerForClass:[ListOfWordsViewController class]];
            }
                break;
            case MainMenuViewControllerMenuItemTheoria: {
                viewController = [self getViewControllerForClass:[ListOfArticleTableViewController class]];
            }
                break;
            case MainMenuViewControllerMenuItemTraining: {
                viewController = [self getViewControllerForClass:[TrainViewController class]];
            }
                break;
            case MainMenuViewControllerMenuItemSearchWords: {
                viewController = [self getViewControllerForClass:[WordsPageViewController class]];
            }
                break;
            case MainMenuViewControllerMenuItemRating: {
                viewController = [self getViewControllerForClass:[RatingViewController class]];
            }
                break;
            case MainMenuViewControllerMenuItemComposingSentence: {
                viewController = [self getViewControllerForClass:[ComposingSentenceViewController class]];
            }
                break;
            case MainMenuViewControllerMenuItemSearchWordOnCamera: {
                viewController = [self getViewControllerForClass:[RecognizeImageViewController class]];
            }
                break;
            case MainMenuViewControllerMenuItemLogout: {
                [self presentViewController:self.alertController animated:YES completion:nil];
            }
                break;
        }
        
        UIViewController *previousViewController = self.navigationController.topViewController;
        [previousViewController.view.subviews.lastObject removeFromSuperview];
        self.fromNavigationController.isOpenMenu = NO;
        
        [self.fromNavigationController pushViewController:viewController animated:YES];
        
    }];
}

- (IBAction)tapToUnusedArea:(UITapGestureRecognizer *)sender {
    CGPoint tapPoint = [sender locationInView:self.view];
    if (tapPoint.x > CGRectGetWidth(self.containerMenu.bounds)) {
        [self closeMenuAnimated:YES withCompletionBlock:^{
            UIViewController *viewController = self.navigationController.topViewController;
            [viewController.view.subviews.lastObject removeFromSuperview];
            self.fromNavigationController.isOpenMenu = NO;
        }];
    }
}

@end
