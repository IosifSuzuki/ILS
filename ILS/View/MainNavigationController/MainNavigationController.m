//
//  MainNavigationController.m
//  ILS
//
//  Created by admin on 11.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//
#import "MainNavigationController.h"
#import "MainNavigationControllerDelegate.h"
#import "MainMenuViewController.h"

typedef NS_ENUM(NSUInteger, MainNavigationControllerBarButtonItemType) {
    MainNavigationControllerBarButtonItemTypeMenu,
    MainNavigationControllerBarButtonItemTypeBack,
};

@interface MainNavigationController () <UINavigationControllerDelegate>

@property (strong, nonatomic) MainMenuViewController *mainMenuViewController;

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNaviagtionController];
}

#pragma mark - Private

- (void)setupNaviagtionController {
    self.isOpenMenu = NO;
    self.delegate = self;
    
    self.mainMenuViewController = (MainMenuViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MainMenuViewController class])];
    self.mainMenuViewController.fromNavigationController = self;
}

- (void)configurateLeftBarButtonItemWithType:(MainNavigationControllerBarButtonItemType)type forViewController:(UIViewController *)viewController {
    switch(type) {
        case MainNavigationControllerBarButtonItemTypeMenu: {
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(tapToMenuBarButtonItem:)];
        }
            break;
        case MainNavigationControllerBarButtonItemTypeBack: {
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(tapToBackBarButtonItem:)];
        }
            break;
    }
}

#pragma mark - Public

- (void)showStartViewController {
    [self pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileViewController"] animated:YES];
}

#pragma mark - Action

- (IBAction)tapToMenuBarButtonItem:(UIBarButtonItem *)sender {
    self.isOpenMenu = !self.isOpenMenu;
    sender.enabled = NO;
    UIViewController *viewController = self.topViewController;
    
    if (self.isOpenMenu) {
        
        [viewController.view addSubview:self.mainMenuViewController.view];
        [viewController.view bringSubviewToFront:self.mainMenuViewController.view];
        
        [self.mainMenuViewController closeMenuAnimated:NO withCompletionBlock:nil];
        [self.mainMenuViewController showMenuAnimated:YES withCompletionBlock:^{
            sender.enabled = YES;
        }];
    } else {
        [self.mainMenuViewController showMenuAnimated:NO withCompletionBlock:nil];
        [self.mainMenuViewController closeMenuAnimated:YES withCompletionBlock:^{
            [viewController.view.subviews.lastObject removeFromSuperview];
            sender.enabled = YES;
        }];
    }
}

- (IBAction)tapToBackBarButtonItem:(id)sender {
    [self popViewControllerAnimated:YES];
}

#pragma mark - Override

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskPortrait;
    if ([self.viewControllers.lastObject conformsToProtocol:@protocol(MainNavigationControllerDelegate)]) {
        UIViewController<MainNavigationControllerDelegate> *vc = (UIViewController<MainNavigationControllerDelegate> *)self.viewControllers.lastObject;
        if ([vc respondsToSelector:@selector(allowRotation)] && vc.allowRotation) {
            orientationMask = UIInterfaceOrientationMaskAll;
        }
    }
    return orientationMask;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController conformsToProtocol:@protocol(MainNavigationControllerDelegate)]) {
        UIView *theWindow = self.view;
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.45f];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFade];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [[theWindow layer] addAnimation:animation forKey:@"Animation"];
        [super pushViewController:viewController animated:NO];
    } else {
        [super pushViewController:viewController animated:animated];
    }
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    MainNavigationControllerBarButtonItemType typeBarButtonItem;
    
    if ([viewController conformsToProtocol:@protocol(MainNavigationControllerDelegate)] && ((UIViewController<MainNavigationControllerDelegate> *)viewController).showMenuBarButtonItem) {
        typeBarButtonItem = MainNavigationControllerBarButtonItemTypeMenu;
    } else {
        typeBarButtonItem = MainNavigationControllerBarButtonItemTypeBack;
    }
    
    [self configurateLeftBarButtonItemWithType:typeBarButtonItem forViewController:viewController];
    
}

@end
