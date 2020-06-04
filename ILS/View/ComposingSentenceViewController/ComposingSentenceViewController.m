//
//  ComposingSentenceViewController.m
//  ILS
//
//  Created by admin on 26.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ComposingSentenceViewController.h"
#import "ComposingSentencePresenter.h"
#import "MainNavigationController.h"

#import "AppSupportClass.h"

#import "WordCollectionViewCell.h"
#import "LoaderView.h"
#import "AnswerView.h"

@interface ComposingSentenceViewController () <ComposingSentenceDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *sentenceCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *checkAnswerButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong, nonatomic) AnswerView *answerView;
@property (strong, nonatomic) ComposingSentencePresenter *presenter;

@end

@implementation ComposingSentenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupController];
    [self prepareUI];
}

#pragma mark - Private

- (void)prepareUI {
    
    self.checkAnswerButton.layer.cornerRadius = ILS_CornerRadius;
    self.checkAnswerButton.clipsToBounds = YES;
}

- (void)setupController {
    self.presenter = [[ComposingSentencePresenter alloc] initWithDelegate:self];
    
    self.answerView = [[AnswerView alloc] initWithFrame:self.view.bounds];
    
    self.title = self.presenter.titleText;
    self.sentenceCollectionView.dragInteractionEnabled = YES;
    [self.presenter fetchData];
}

#pragma mark - Action

- (IBAction)tapToCheckAnswerButton:(UIButton *)sender {
    [self.presenter checkSentence];
}

#pragma mark - ComposingSentenceDelegate

- (void)updateProgressViewWithProgress:(float)value {
    [self.progressView setProgress:value animated:YES];
}

- (void)startAnimation {
    [[LoaderView sharedInstance] startAnimationFromView:self.view];
}

- (void)stopAnimation {
    [[LoaderView sharedInstance] stopAnimation];
}

- (void)reloadData {
    [self.sentenceCollectionView reloadData];
}

- (void)showAnswerWithSentence:(NSString *)sentence rightAnswer:(BOOL)isRight withCompletionBlock:(nullable void (^)(void))completionBlock {
    [self.answerView showAnswerViewFromView:self.view withAnswers:@[
        sentence,
    ] indexRight:(isRight ? 0 : -1) completionBlock:^{
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)showResult {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:self.presenter.alertTitleText message:self.presenter.alertDesctiptionText preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:self.presenter.okText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertViewController dismissViewControllerAnimated:NO completion:^{
            [(MainNavigationController *)self.navigationController showStartViewController];
        }];
    }];
    
    [alertViewController addAction:okAction];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

#pragma mark - Accessor

- (BOOL)showMenuBarButtonItem {
    return YES;
}

#pragma mark - UICollectionViewDragDelegate

- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    
    NSItemProvider *provider = [[NSItemProvider alloc] initWithItem:@(indexPath.row) typeIdentifier:[NSString string]];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:provider];
    
    return @[
        dragItem,
    ];
}

#pragma mark - UICollectionViewDropDelegate

- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    if (collectionView.hasActiveDrag) {
        return [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationMove intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    }
    
    return [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationForbidden];
}

- (void)collectionView:(UICollectionView *)collectionView performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator {
    if (coordinator.proposal.operation != UIDropOperationMove) {
        return;
    }
    
    NSIndexPath *destionationIndexPath = coordinator.destinationIndexPath;
    NSIndexPath *sourceIndexPath = coordinator.items.firstObject.sourceIndexPath;
    if (destionationIndexPath.row != sourceIndexPath.row && destionationIndexPath) {
        [collectionView performBatchUpdates:^{
            [self.presenter moveWordsFromSourceIndex:sourceIndexPath.row toDestinationIndex:destionationIndexPath.row];
            [collectionView deleteItemsAtIndexPaths:@[sourceIndexPath]];
            [collectionView insertItemsAtIndexPaths:@[destionationIndexPath]];
            [collectionView layoutIfNeeded];
        } completion:nil];
    }
    
    [coordinator dropItem:coordinator.items.firstObject.dragItem toItemAtIndexPath:destionationIndexPath];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.presenter numberOfWords];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WordCollectionViewCell.reusableIdentifier forIndexPath:indexPath];
    cell.textCell = [self.presenter getWordByIndex:indexPath.row];
    return cell;
}

@end
