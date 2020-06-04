//
//  ListOfWordsViewController.m
//  ILS
//
//  Created by admin on 11.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ListOfWordsViewController.h"

#import "ListOfWordsPresenter.h"

#import "WordTableViewCell.h"
#import "WordModel.h"

@interface ListOfWordsViewController () <ListOfWordsPresenterDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray <WordModel *> *dataSource;
@property (strong, nonatomic) ListOfWordsPresenter *presenter;

@end

@implementation ListOfWordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupController];
}

#pragma mark - Privates

- (void)setupController {
    self.presenter = [[ListOfWordsPresenter alloc] initWithDelegate:self];
    
    [self registerTableViewCell];
}

- (void)registerTableViewCell {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WordTableViewCell class]) bundle:nil] forCellReuseIdentifier:WordTableViewCell.identifierWordTableViewCell];
}

#pragma mark - Accessor

- (BOOL)showMenuBarButtonItem {
    return YES;
}

#pragma mark - ListOfWordsViewDelegate

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.presenter countDataSource];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WordTableViewCell *wordTableViewCell = [tableView dequeueReusableCellWithIdentifier:WordTableViewCell.identifierWordTableViewCell];
    
    [wordTableViewCell setDataToWord:[self.presenter getWordAtIndex:indexPath.row] translatedWord:[self.presenter getTranslateWordsAtIndex:indexPath.row] withAddedDate:[self.presenter getStartLearnAtIndex:indexPath.row]];
    wordTableViewCell.needTrain = [self.presenter wordAtIndexNeededTrainAtIndex:indexPath.row];
    
    return wordTableViewCell;
}

@end
