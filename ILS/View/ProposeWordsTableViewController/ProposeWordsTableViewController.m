//
//  ProposeTableViewController.m
//  ILS
//
//  Created by admin on 28.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ProposeWordsTableViewController.h"

#import "ProposeWordsPresenter.h"

#import "MainNavigationController.h"

#import "LoaderView.h"

#import "WordModel.h"

@interface ProposeWordsTableViewController () <ProposeWordsDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButtonItem;

@end

@implementation ProposeWordsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewController];
}

#pragma mark - Private

- (void)setupViewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.presenter.alertTitle message:self.presenter.alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:self.presenter.okText style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    self.saveBarButtonItem.enabled = NO;
    
    self.title = self.presenter.titleText;
    
    self.navigationItem.rightBarButtonItem = self.saveBarButtonItem;
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.presenter.proposeWords.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProposeWordsPresenter.reuseIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.presenter getWordAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.presenter getTranslatedWord:indexPath.row];
    cell.accessoryType = [self.presenter isSelectedWord:[self.presenter getWordAtIndex:indexPath.row]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch ([cell accessoryType]) {
        case UITableViewCellAccessoryCheckmark: {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [self.presenter deselectObjectAtIndex:indexPath.row];
        }
            break;
        case UITableViewCellAccessoryNone: {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [self.presenter selectObjectAtIndex:indexPath.row];
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    [self.presenter deselectObjectAtIndex:indexPath.row];
}

#pragma mark - Action

- (IBAction)tapToSaveButton:(UIBarButtonItem *)sender {
    [self.presenter saveWordsWithCompletionBlock:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark - PropposeWordsDelegate
 
@synthesize presenter;

- (void)startAnimation {
    [[LoaderView sharedInstance] startAnimationFromView:self.view];
}

- (void)stopAnimation {
    [[LoaderView sharedInstance] stopAnimation];
}

- (void)enableSaveButton:(BOOL)enabled {
    self.saveBarButtonItem.enabled = enabled;
}

@end
