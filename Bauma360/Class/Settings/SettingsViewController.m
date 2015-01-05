/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <AVOSCloud/AVOSCloud.h>
#import "SettingsViewController.h"

#import "ApplyViewController.h"
#import "PushNotificationViewController.h"
#import "BlackListViewController.h"
#import "DebugViewController.h"
#import "WCAlertView.h"
#import "ShowUserViewCell.h"
#import "LoginViewController.h"
#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ImgShowViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface SettingsViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate, ShowUserCellDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UISwitch *beInvitedSwitch;
@property (strong, nonatomic) UILabel *beInvitedLabel;

@end

@implementation SettingsViewController {
    ShowUserViewCell *showUserCell;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = self.footerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - getter

- (UISwitch *)beInvitedSwitch
{
//    if (_beInvitedSwitch == nil) {
//        _beInvitedSwitch = [[UISwitch alloc] init];
//        [_beInvitedSwitch addTarget:self action:@selector(beInvitedChanged:) forControlEvents:UIControlEventValueChanged];
//        BOOL autoAccept = [[EaseMob sharedInstance].chatManager autoAcceptGroupInvitation];
//        [_beInvitedSwitch setOn:!autoAccept animated:YES];
//    }
    
    return _beInvitedSwitch;
}

- (UILabel *)beInvitedLabel
{
    if (_beInvitedLabel == nil) {
        _beInvitedLabel = [[UILabel alloc] init];
        _beInvitedLabel.backgroundColor = [UIColor clearColor];
        _beInvitedLabel.font = [UIFont systemFontOfSize:12.0];
        _beInvitedLabel.textColor = [UIColor grayColor];
    }
    
    return _beInvitedLabel;
}

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"ShowUserCell";
        showUserCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (showUserCell == nil) {
            //showUserCell = [[[NSBundle mainBundle] loadNibNamed:@"SettingsTableViewShowUserCell" owner:self options:nil] lastObject];
            showUserCell = [[ShowUserViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            showUserCell.delegate = self;
            [showUserCell initialize];
        }
        cell = showUserCell;
    } else {
        static NSString *cellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"昵称设置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"消息推送设置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"黑名单";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 3)
        {
            cell.textLabel.text = @"诊断";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
//        else if (indexPath.row == 3)
//        {
//            cell.textLabel.text = @"被邀请人权限";
//            
//            self.beInvitedSwitch.frame = CGRectMake(180, (cell.contentView.frame.size.height - self.beInvitedSwitch.frame.size.height) / 2, self.beInvitedSwitch.frame.size.width, self.beInvitedSwitch.frame.size.height);
//            [cell.contentView addSubview:self.beInvitedSwitch];
//            
//            self.beInvitedLabel.frame = CGRectMake(self.beInvitedSwitch.frame.origin.x + self.beInvitedSwitch.frame.size.width + 5, 0, 80, 50);
//            [cell.contentView addSubview:self.beInvitedLabel];
//        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 20;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        CGRect frameRect = CGRectMake(20, 30, 320, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:frameRect];
        label.backgroundColor = [UIColor colorWithRed:78.0/255.0 green:188.0/255.0 blue:211.0/255.0 alpha:1];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"即时聊天设置";
        return label;
    }
    return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            return 200;
        }
    } else if(indexPath.section == 1) {
        return 50;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([[[EaseMob sharedInstance] chatManager] isLoggedIn]) {
            
        } else {
            LoginViewController *loginController = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginController animated:YES];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
        }else if (indexPath.row == 1) {
            PushNotificationViewController *pushController = [[PushNotificationViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:pushController animated:YES];
        } else if (indexPath.row == 2) {
            BlackListViewController *blackController = [[BlackListViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:blackController animated:YES];
        } else if (indexPath.row == 3) {
            DebugViewController *debugController = [[DebugViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:debugController animated:YES];
        }
    }
}

#pragma mark - getter

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
        _footerView.backgroundColor = [UIColor clearColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, _footerView.frame.size.width - 10, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_footerView addSubview:line];
        
        UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, _footerView.frame.size.width - 80, 40)];
        [logoutButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];
        NSDictionary *loginInfo = [[EaseMob sharedInstance].chatManager loginInfo];
        NSString *username = [loginInfo objectForKey:kSDKUsername];
        NSString *logoutButtonTitle = [[NSString alloc] initWithFormat:@"退出登录(%@)", username];
        [logoutButton setTitle:logoutButtonTitle forState:UIControlStateNormal];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:logoutButton];
    }
    
    return _footerView;
}

#pragma mark - action

//- (void)autoLoginChanged:(UISwitch *)autoSwitch
//{
//    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:autoSwitch.isOn];
//}

- (void)beInvitedChanged:(UISwitch *)beInvitedSwitch
{
//    if (beInvitedSwitch.isOn) {
//        self.beInvitedLabel.text = @"允许选择";
//    }
//    else{
//        self.beInvitedLabel.text = @"自动加入";
//    }
//    
//    [[EaseMob sharedInstance].chatManager setAutoAcceptGroupInvitation:!(beInvitedSwitch.isOn)];
}


- (void)refreshConfig
{
    //[self.autoLoginSwitch setOn:[[EaseMob sharedInstance].chatManager isAutoLoginEnabled] animated:YES];
    
    [self.tableView reloadData];
}

- (void)logoutAction
{
    __weak SettingsViewController *weakSelf = self;
    [self showHudInView:self.view hint:@"正在退出..."];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
        [weakSelf hideHud];
        if (error) {
            [weakSelf showHint:error.description];
        }
        else{
            [[ApplyViewController shareController] clear];
            [AVUser logOut];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
    } onQueue:nil];
}

#pragma ShowUserCellDelegate
- (void)showImagePicker {
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
}

- (void)showCamera {
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
}

- (void)showCurUserFullHeadPortrait {
    AVUser *curUser = [AVUser currentUser];
    AVFile *imageFile = [curUser objectForKey:@"headPortrait"];
    NSMutableArray *images = [NSMutableArray arrayWithObject:imageFile];
    ImgShowViewController *imageShowVC = [[ImgShowViewController alloc] initWithSourceData:images withIndex:0];
    [self presentViewController:imageShowVC animated:YES completion:nil];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [showUserCell setPortaintImage: editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
         //裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma UIAlertViewDelegate
- (void) alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //得到输入框
    UITextField *tf=[alertView textFieldAtIndex:0];
    NSString *nickname = tf.text;
    if (![nickname isEqual: @""]) {
        AVUser *curUser = [AVUser currentUser];
        [curUser setObject:nickname forKey:@"nickname"];
        [curUser saveInBackground];
        [[[EaseMob sharedInstance] chatManager] setNickname:nickname];
        [showUserCell initialize];
    }
}


@end
