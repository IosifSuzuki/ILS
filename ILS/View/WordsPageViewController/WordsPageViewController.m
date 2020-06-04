//
//  WordsPageViewController.m
//  ILS
//
//  Created by admin on 12.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "WordsPageViewController.h"
#import "WordViewController.h"
#import "AppDelegate.h"

#import "WordsPresenter.h"

#import "LoaderView.h"

#import "WordModel.h"
#import "User+CoreDataClass.h"

#import "FirebaseManager.h"
#import "RandomWordApiManager.h"
#import "LingvoAPIManager.h"

typedef NS_ENUM(NSUInteger, WordsPageViewControllerDirection) {
    WordsPageViewControllerDirectionLeft,
    WordsPageViewControllerDirectionRight,
};

@interface WordsPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, WordsDelegate>

@property (strong, nonatomic) WordsPresenter *presenter;

@property (assign, nonatomic) WordsPageViewControllerDirection direction;

@property (strong, nonatomic) NSArray<WordViewController *> *wordViewControllers;

@end

@implementation WordsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewController];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Private

- (void)setupViewController {
    self.presenter = [[WordsPresenter alloc] initWithDelegate:self];
    self.dataSource = self;
    self.delegate = self;
    
    self.title = self.presenter.titleText;
    
    WordViewController *wordViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([WordViewController class])];
    [self setViewControllers:@[wordViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(tapToSaveBarButtonItem:)];
    self.navigationItem.rightBarButtonItem = saveBarButtonItem;
    [self dissableSaveButton];
    [self fetchData];
}

- (void)fetchData {
    [self.presenter fetchData];
}

- (void)setupViewControllers {
    NSMutableArray<WordViewController *> *viewControllers = [NSMutableArray array];
    
    for (NSInteger index = 0; index < 3; index++) {
        WordViewController *wordViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([WordViewController class])];
        wordViewController.presenterWordText = [self.presenter getWordAtIndex:self.presenter.selectedIndexOfWord + 1];
        
        [viewControllers addObject:wordViewController];
    }
    
    
    [viewControllers objectAtIndex:1].presenterWordText =[self.presenter getWordAtIndex:self.presenter.selectedIndexOfWord];
    
    self.wordViewControllers = [viewControllers copy];
    [self setViewControllers:@[[self.wordViewControllers objectAtIndex:1]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - Action

- (IBAction)tapToSaveBarButtonItem:(id)sender {
    [self.presenter saveWords];
}

#pragma mark - MainNavigationControllerDelegate

- (BOOL)showMenuBarButtonItem {
    return YES;
}

#pragma mark - WordsDelegate

- (void)startAnimation {
    [[LoaderView sharedInstance] startAnimationFromView:self.view];
}

- (void)stopAnimation {
    [[LoaderView sharedInstance] stopAnimation];
}

- (void)allowSetupViewController {
    [self setupViewControllers];
}

- (void)enableSaveButton {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)dissableSaveButton {
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return self.wordViewControllers.firstObject;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return self.wordViewControllers.lastObject;
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    if ([self.wordViewControllers indexOfObject:(WordViewController *)pendingViewControllers.firstObject] > 1) {
        self.direction = WordsPageViewControllerDirectionRight;
    } else {
        self.direction = WordsPageViewControllerDirectionLeft;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        NSMutableArray<WordViewController *> *viewControllers = [NSMutableArray arrayWithArray:self.wordViewControllers];
        switch (self.direction) {
            case WordsPageViewControllerDirectionRight: {
                [self.presenter addToSelectedWords];
                
                [viewControllers addObject:viewControllers.firstObject];
                [viewControllers removeObjectAtIndex:0];
            }
                break;
            case WordsPageViewControllerDirectionLeft: {
                [viewControllers insertObject:viewControllers.lastObject atIndex:0];
                [viewControllers removeLastObject];
            }
                break;
        }
        self.presenter.selectedIndexOfWord++;
        [viewControllers objectAtIndex:1].presenterWordText = [self.presenter getWordAtIndex:self.presenter.selectedIndexOfWord];
        viewControllers.lastObject.presenterWordText =
        viewControllers.firstObject.presenterWordText = [self.presenter getWordAtIndex:self.presenter.selectedIndexOfWord + 1];
        self.wordViewControllers = [viewControllers copy];
    }
}

@end
