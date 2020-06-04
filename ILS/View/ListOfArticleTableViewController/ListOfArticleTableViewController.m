//
//  ListOfArticleTableViewController.m
//  ILS
//
//  Created by admin on 31.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ListOfArticleTableViewController.h"
#import "ListOfArticlePresenter.h"

static NSString *const kSeguePresentDetailScreen = @"WebViewDetailSegue";

@interface ListOfArticleTableViewController () <ListOfArticleDelegate>

@property (strong, nonatomic) ListOfArticlePresenter *presenter;

@end

@implementation ListOfArticleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupController];
}

#pragma mark - Private

- (void)setupController {
    self.presenter = [[ListOfArticlePresenter alloc] initWithDelegate:self];
    
    self.title = self.presenter.titleText;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.presenter fetchData];
}

#pragma mark - ListOfArticleDelegate

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - MainNavigationControllerDelegate

- (BOOL)showMenuBarButtonItem {
    return YES;
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.presenter getCountOfArticles];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListOfArticlePresenter.cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.presenter getTitleAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSeguePresentDetailScreen]) {
        [self.presenter preparePresenterForWebView:segue.destinationViewController atIndex:[self.tableView indexPathForCell:sender].row];
    }
}

@end
