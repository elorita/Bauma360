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

#import "LoginViewController.h"
#import "EMError.h"
#import "AVOSCloud/AVOSCloud.h"
#import "SignUpViewController.h"

@interface LoginViewController ()<IChatManagerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)doRegister:(id)sender;
- (IBAction)doLogin:(id)sender;
- (IBAction)doShowHidePassword:(id)sender;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _phoneNoTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self setupForDismissKeyboard];
    _phoneNoTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doRegister:(id)sender {
    SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [self showHudInView:self.view hint:@"正在登录..."];
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         [self hideHud];
         if (loginInfo && !error) {
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             
         }else {
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                     TTAlertNoTitle(@"连接服务器失败!");
                     break;
                 case EMErrorServerAuthenticationFailure:
                     TTAlertNoTitle(@"用户名或密码错误");
                     break;
                 case EMErrorServerTimeout:
                     TTAlertNoTitle(@"连接服务器超时!");
                     break;
                 default:
                     TTAlertNoTitle(@"登录失败");
                     break;
             }
         }
     } onQueue:nil];
}

- (void)AVOSSignIn:(NSString *)username password:(NSString *)password {
    [self showHudInView:self.view hint:@"登录中..."];
    [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            [self hideHud];
            //[self EaseSignIn:username password:password];
            [self EaseSignIn:username password:@"123456"];
        } else {
            TTAlertNoTitle(error.description);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)EaseSignIn:(NSString *)username password:(NSString *)password
{
    [self showHudInView:self.view hint:@"连接IM服务"];
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         [self hideHud];
         if (loginInfo && !error) {
             [[[EaseMob sharedInstance] chatManager] setIsAutoLoginEnabled:TRUE];
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];

#if !TARGET_IPHONE_SIMULATOR
             if ([[[[EaseMob sharedInstance] chatManager] nickname] isEqual:username] ||
                 [[[[EaseMob sharedInstance] chatManager] nickname] isEqual:@""]) {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"填写昵称" message:@"为保证您的隐私，昵称请勿和账号雷同" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                 [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                 //UITextField *nameTextField = [alert textFieldAtIndex:0];
                 //nameTextField.text = _phoneNoTextField.text;
                 [alert show];
             } else {
                 [self.navigationController popViewControllerAnimated:YES];
             }
#elif TARGET_IPHONE_SIMULATOR
#endif
         }else {
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                     TTAlertNoTitle(@"连接服务器失败!");
                     break;
                 case EMErrorServerAuthenticationFailure:
                     TTAlertNoTitle(@"用户名或密码错误");
                     break;
                 case EMErrorServerTimeout:
                     TTAlertNoTitle(@"连接服务器超时!");
                     break;
                 default:
                     TTAlertNoTitle(@"登录失败");
                     break;
             }
             [self.navigationController popViewControllerAnimated:YES];
         }
     } onQueue:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView cancelButtonIndex] != buttonIndex) {
        UITextField *nameTextField = [alertView textFieldAtIndex:0];
        if(nameTextField.text.length > 0 || [nameTextField.text isEqual:[[[EaseMob sharedInstance] chatManager] nickname]])
        {
            [[AVUser currentUser] setObject:nameTextField.text forKey:@"nickname"];
            [[AVUser currentUser] save];
            [[EaseMob sharedInstance].chatManager setNickname:nameTextField.text];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doLogin:(id)sender {
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        if ([_phoneNoTextField.text isChinese]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"用户名不支持中文"
                                  message:nil
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        [self AVOSSignIn:_phoneNoTextField.text password:_passwordTextField.text];
    }
}

- (IBAction)doShowHidePassword:(id)sender {
    _passwordTextField.secureTextEntry = !_passwordTextField.secureTextEntry;
}


- (BOOL)isEmpty{
    BOOL ret = NO;
    NSString *username = _phoneNoTextField.text;
    NSString *password = _passwordTextField.text;
    if (username.length == 0 || password.length == 0) {
        ret = YES;
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"请输入账号和密码"
                     customizationBlock:nil
                        completionBlock:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles: nil];
    }
    
    return ret;
}


#pragma  mark - TextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _phoneNoTextField) {
        _passwordTextField.text = @"";
    }
    
    return YES;
}

@end
