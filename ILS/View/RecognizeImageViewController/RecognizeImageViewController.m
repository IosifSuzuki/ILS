//
//  RecognizeImageViewController.m
//  ILS
//
//  Created by admin on 28.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "RecognizeImageViewController.h"
#import "RecognizeImagePresenter.h"

#import "LoaderView.h"

#import "AppSupportClass.h"

@interface RecognizeImageViewController () <RecognizeImageDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightPhotoIconConstraint;
@property (weak, nonatomic) IBOutlet UIControl *containerPhotoIcon;
@property (weak, nonatomic) IBOutlet UIImageView *photoIcon;
@property (weak, nonatomic) IBOutlet UIButton *sendRequestButton;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) UIAlertController *alertController;

@property (strong, nonatomic) RecognizeImagePresenter *presenter;

@end

@implementation RecognizeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    [self setupController];
}

- (void)viewWillAppear:(BOOL)animated {
    self.sendRequestButton.enabled = NO;
}

#pragma mark - Private

- (void)prepareUI {
    self.containerPhotoIcon.layer.cornerRadius = ILS_CornerRadius;
    self.containerPhotoIcon.layer.borderWidth = 4.f;
    self.containerPhotoIcon.layer.borderColor = AppSupportClass.mainColor.CGColor;
    self.containerPhotoIcon.clipsToBounds = YES;
    
    self.sendRequestButton.layer.cornerRadius = ILS_CornerRadius;
    self.sendRequestButton.clipsToBounds = YES;
}

- (void)setupController {
    self.presenter = [[RecognizeImagePresenter alloc] initWithDelegate:self];
    self.title = self.presenter.titleText;
    
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
}

#pragma mark - Action

- (IBAction)tapToSelectPhotoImage:(UIControl *)sender {
   [self presentViewController:self.alertController animated:YES completion:nil];
}

- (IBAction)tapToSendRequestButton:(id)sender {
    [self.presenter makeRequest];
}

#pragma mark - Accessor

- (BOOL)showMenuBarButtonItem {
    return YES;
}

#pragma mark - RecognizeImageDelegate

- (void)startAnimation {
    [[LoaderView sharedInstance] startAnimationFromView:self.view];
}

- (void)stopAnimation {
    [[LoaderView sharedInstance] stopAnimation];
}

- (void)makeSegue {
    [self performSegueWithIdentifier:RecognizeImagePresenter.kSegueString sender:self];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *chosenIcon = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data = UIImageJPEGRepresentation(chosenIcon, 1.f);
    self.presenter.selectedImageData = data;
    
    self.photoIcon.contentMode = UIViewContentModeScaleToFill;
    [self.photoIcon setImage:chosenIcon];
    self.heightPhotoIconConstraint.active = NO;
    
    self.sendRequestButton.enabled = YES;
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:RecognizeImagePresenter.kSegueString]) {
        [self.presenter prepareMakeSegueWithDelegate:segue.destinationViewController];
    }
}

@end
