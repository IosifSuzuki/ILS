//
//  ProfileViewController.m
//  ILS
//
//  Created by admin on 14.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "FirebaseManager.h"

#import "AppSupportClass.h"
#import "AppDelegate.h"
#import <Charts/Charts-Swift.h>

#import "LoaderView.h"

#import "ProfileViewController.h"
#import "ProfilePresenter.h"

typedef NS_ENUM(NSUInteger, ProfileViewControllerBarButtonItem) {
    ProfileViewControllerBarButtonItemEdit,
    ProfileViewControllerBarButtonItemSave,
};

@interface ProfileViewController () <UINavigationControllerDelegate, UITextFieldDelegate, ProfileDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate>

@property (strong, nonatomic) ProfilePresenter *presenter;

@property (strong, nonatomic) UIAlertController *alertController;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@property (weak, nonatomic) IBOutlet UIView *containerForProfileView;
@property (weak, nonatomic) IBOutlet UIButton *iconProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *totalBallsLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *regionTextField;
@property (weak, nonatomic) IBOutlet LineChartView *chartView;

@property (strong, nonatomic) UIBarButtonItem *actionBarButtonItem;
@property (assign, nonatomic) ProfileViewControllerBarButtonItem actionBarButtonType;

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIToolbar *toolbar;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewController];
    [self setupNavigationBar];
    [self setupChart];
    [self prepareUI];
}

#pragma mark - Private

- (void)prepareUI {
    self.containerForProfileView.layer.cornerRadius = ILS_CornerRadius;
    self.containerForProfileView.clipsToBounds = YES;
    
    self.iconProfileImage.tintColor = AppSupportClass.mainColor;
    self.iconProfileImage.layer.cornerRadius = CGRectGetHeight(self.iconProfileImage.bounds) / 2.f;
    self.iconProfileImage.clipsToBounds = YES;
    self.iconProfileImage.layer.borderWidth = 1.f;
    self.iconProfileImage.layer.borderColor = AppSupportClass.mainColor.CGColor;
}

- (void)setupNavigationBar {
    self.title = self.presenter.titleText;
    
    self.actionBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(tapToBarButtonItemAction:)];
    self.actionBarButtonItem.tag = (NSInteger)ProfileViewControllerBarButtonItemEdit;
    
    self.navigationItem.rightBarButtonItems = @[self.actionBarButtonItem];
    
}
- (void)fetchData {
    
    [self.presenter getUserIcon];
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
//    NSArray *array = [persistenContainer.viewContext executeFetchRequest:fetchRequest error:nil];
//    User *user = (User *)array.firstObject;
//    self.user = user;
    
    [self.presenter updateChart];
    
    self.emailValueLabel.text = self.presenter.userEmail;
    self.nicknameTextField.text = self.presenter.userNickName;
    self.regionTextField.text = self.presenter.userRegion;
    self.totalBallsLabel.text = self.presenter.userBalls;
    [self.pickerView selectRow:self.presenter.selectedRegion inComponent:0 animated:NO];
    [self pickerView:self.pickerView didSelectRow:self.presenter.selectedRegion inComponent:0];
}

- (void)setupViewController {
    self.presenter = [[ProfilePresenter alloc] initWithDelegate:self];
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.delegate = self;
    
    self.alertController = [UIAlertController alertControllerWithTitle:nil message:self.presenter.selectOptionForPhtotoSourceText preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAlertAction = [UIAlertAction actionWithTitle:self.presenter.cameraText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.alertController dismissViewControllerAnimated:YES completion:^{
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }];
    }];
    UIAlertAction *photoLibraryAlertAction = [UIAlertAction actionWithTitle:self.presenter.photoLibraryText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.alertController dismissViewControllerAnimated:YES completion:^{
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }];
    }];
    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:self.presenter.backText style:UIAlertActionStyleCancel handler:nil];
    
    [self.alertController addAction:cameraAlertAction];
    [self.alertController addAction:photoLibraryAlertAction];
    [self.alertController addAction:cancelAlertAction];
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 50.f)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapToBarButtonItemDone:)];
    doneBarButtonItem.width = 20.f;
    
    self.toolbar.items = @[flexibleSpace, doneBarButtonItem];

    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 150.f)];
    [self.pickerView sizeToFit];
    self.pickerView.delegate = self;
    self.regionTextField.inputView = self.pickerView;
    
    self.regionTextField.inputAccessoryView =
    self.nicknameTextField.inputAccessoryView = self.toolbar;
    self.nicknameTextField.delegate = self;
    
    self.iconProfileImage.enabled =
    self.nicknameTextField.enabled =
    self.regionTextField.enabled = NO;
    
    self.regionLabel.text = self.presenter.yourRegionText;
    self.emailLabel.text = self.presenter.emailText;
    
    [self fetchData];
}

- (void)setupChart {
    NSMutableArray<ChartDataEntry *> *mutableData = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < 5; index++) {
        [mutableData addObject:[[ChartDataEntry alloc] initWithX:index y:[[self.presenter.valuesForStatistic objectAtIndex:index] integerValue]]];
    }
    
    self.chartView.layer.cornerRadius = ILS_CornerRadius;
    self.chartView.backgroundColor = getColorFromHex(0xE5E5EA, 1.f);
    self.chartView.clipsToBounds = YES;
    
    LineChartData *chartData = [[LineChartData alloc] init];
    LineChartDataSet *lineDataSet = [[LineChartDataSet alloc] initWithEntries:[mutableData copy]];
    lineDataSet.lineWidth = 3.f;
    [lineDataSet setColor:AppSupportClass.mainColor];
    lineDataSet.drawValuesEnabled = NO;
    lineDataSet.mode = LineChartModeHorizontalBezier;
    lineDataSet.circleRadius = 5.f;
    lineDataSet.circleColors = @[UIColor.whiteColor];
    lineDataSet.circleHoleRadius = 0.f;
    [chartData addDataSet:lineDataSet];

    self.chartView.dragEnabled = NO;
    self.chartView.xAxis.labelPosition = XAxisLabelPositionBottom;
    self.chartView.leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    self.chartView.data = chartData;
    self.chartView.rightAxis.enabled =
    self.chartView.dragEnabled =
    self.chartView.legend.enabled = NO;
    self.chartView.leftAxis.drawGridLinesEnabled =
    self.chartView.xAxis.drawGridLinesEnabled = NO;
    self.chartView.xAxis.granularity = 1.f;
    self.chartView.xAxis.valueFormatter = self.presenter;
    self.chartView.extraRightOffset = 12.f;
    self.chartView.extraTopOffset =
    self.chartView.extraLeftOffset =
    self.chartView.extraBottomOffset = 8.f;
    self.chartView.scaleXEnabled =
    self.chartView.scaleYEnabled = NO;
    self.chartView.leftAxis.axisMinimum = 0.f;
    
    [self.chartView animateWithYAxisDuration:1.5];
}

#pragma mark - Accessor

- (void)setActionBarButtonType:(ProfileViewControllerBarButtonItem)actionBarButtonType {
    _actionBarButtonType = actionBarButtonType;
    
    BOOL enableEditing = YES;
    switch (actionBarButtonType) {
        case ProfileViewControllerBarButtonItemEdit: {
            self.actionBarButtonItem.title = @"Edit";
            enableEditing = NO;
        }
            break;
        case ProfileViewControllerBarButtonItemSave: {
            UIColor *oldColor = self.regionTextField.textColor;
            
            self.actionBarButtonItem.title = @"Save";
            [UIView transitionWithView:self.nicknameTextField duration:1.f options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAutoreverse animations:^{
                self.nicknameTextField.textColor = UIColor.redColor;
            } completion:^(BOOL finished) {
                self.nicknameTextField.textColor = oldColor;
            }];
            
            [UIView transitionWithView:self.regionTextField duration:1.f options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAutoreverse animations:^{
                self.regionTextField.textColor = UIColor.redColor;
            } completion:^(BOOL finished) {
                self.regionTextField.textColor = oldColor;
            }];
            
            [UIView animateWithDuration:1.f delay:0.f options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.iconProfileImage.tintColor = UIColor.redColor;
            } completion:^(BOOL finished) {
                self.iconProfileImage.tintColor = AppSupportClass.mainColor;
            }];
            
            CABasicAnimation *borderIconAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
            borderIconAnimation.fromValue = (id)self.iconProfileImage.layer.borderColor;
            borderIconAnimation.toValue = (id)UIColor.redColor.CGColor;
            borderIconAnimation.duration = 1.f;
            borderIconAnimation.autoreverses = YES;
            [self.iconProfileImage.layer addAnimation:borderIconAnimation forKey:@"borderIconAnimation"];
        }
            break;
    }
    
    self.iconProfileImage.enabled =
    self.regionTextField.enabled =
    self.nicknameTextField.enabled = enableEditing;
}

#pragma mark - Override

- (BOOL)showMenuBarButtonItem {
    return YES;
}

#pragma mark - ProfileDelegate

- (void)updateProfileIconWithData:(NSData *)iconProfileData {
    [self.iconProfileImage setImage:[UIImage imageWithData:iconProfileData] forState:UIControlStateNormal];
}

- (void)startAnimation {
    [[LoaderView sharedInstance] startAnimationFromView:self.view];
}

- (void)stopAnimation {
    [[LoaderView sharedInstance] stopAnimation];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if ([textField isEqual:self.nicknameTextField]) {
        self.presenter.nNickName = self.nicknameTextField.text;
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.presenter.numberOfRegion;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.presenter regionWithIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.presenter.nRegion =
    self.regionTextField.text = [self.presenter regionWithIndex:row];
    self.presenter.selectedRegion = row;
}

#pragma mark - UIPickerViewDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *chosenIcon = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(chosenIcon, 1.f);
    self.presenter.nIconProfile = data;
    
    [self.iconProfileImage setImage:chosenIcon forState:UIControlStateNormal];
    
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action

- (IBAction)tapToBarButtonItemDone:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
}

- (IBAction)tapToBarButtonItemAction:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case ProfileViewControllerBarButtonItemEdit: {
            sender.tag = ProfileViewControllerBarButtonItemSave;
        }
            break;
        case ProfileViewControllerBarButtonItemSave: {
            sender.tag = ProfileViewControllerBarButtonItemEdit;
            
            [self.presenter updateUserProfile];
        }
            break;
    }
    
    self.actionBarButtonType = (ProfileViewControllerBarButtonItem)sender.tag;
}

- (IBAction)tapToIconButton:(UIButton *)sender {
    [self.view endEditing:YES];
    [self presentViewController:self.alertController animated:YES completion:nil];
}

@end
