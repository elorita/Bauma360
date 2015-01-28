//
//  SmsVerificationViewController.m
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/22.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "SmsVerificationViewController.h"

@interface SmsVerificationViewController ()

@property (nonatomic, retain) IBOutlet UITextField *verifyCodeTextField;
- (IBAction)doVerifySms:(id)sender;

@end

@implementation SmsVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    // Do any additional setup after loading the view from its nib.
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.title = @"短信验证";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doVerifySms:(id)sender {
    [self showHudInView:self.view hint:@"正在验证"];
    [AVUser verifyMobilePhone:_verifyCodeTextField.text withBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded && !error) {
            [self hideHud];
            [self AVOSSignIn];
        }else {
            TTAlertNoTitle(error.description);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void) RegistAVUserToEase{
    [self showHudInView:self.view hint:@"注册IM服务..."];
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_user.username
                                                         password:_user.password
                                                   withCompletion:
     ^(NSString *username, NSString *password, EMError *error) {
         [self hideHud];
         
         if (!error || (error && error.errorCode == EMErrorServerDuplicatedAccount)) {
             //若有错误但错误码为IM用户已存在，但由于已完成短信验证，所以直接绑定
             [self->_user setObject:[NSNumber numberWithBool:YES] forKey:@"EaseIsReady"];
             [self->_user saveInBackground];
             [self EaseSignIn];
         }else{
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                     TTAlertNoTitle(@"连接IM服务器失败!");
                     break;
                 case EMErrorServerTimeout:
                     TTAlertNoTitle(@"连接IM服务器超时!");
                     break;
                 default:
                     TTAlertNoTitle(@"IM注册失败");
                     break;
             }
             [self.navigationController popViewControllerAnimated:YES];
         }
     } onQueue:nil];
}

- (void)AVOSSignIn {
    [self showHudInView:self.view hint:@"登录中..."];
    [AVUser logInWithUsernameInBackground:_user.username password:_user.password block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            [self hideHud];
            //[self RegistAVUserToEase];
            [self EaseSignIn];
        } else {
            TTAlertNoTitle(error.description);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)EaseSignIn
{
    [self showHudInView:self.view hint:@"连接IM服务"];
    //[[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self->_user.username password:self->_user.password completion:
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self->_user.username password:@"123456" completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         [self hideHud];
         if (loginInfo && !error) {
             [[[EaseMob sharedInstance] chatManager] setIsAutoLoginEnabled:TRUE];
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             [self.navigationController popToRootViewControllerAnimated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
