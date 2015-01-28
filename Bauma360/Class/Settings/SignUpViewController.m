//
//  SignUpViewController.m
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/22.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "SignUpViewController.h"
#import "SmsVerificationViewController.h"
#import "Verifier.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)doRegister:(id)sender;
- (IBAction)doShowHidePassword:(id)sender;

@end

@implementation SignUpViewController {
    AVUser * user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _usernameTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _phoneNoTextField.keyboardType = UIKeyboardTypeNumberPad;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view from its nib.
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.title = @"注册";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideHud];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doRegister:(id)sender {
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        if ([_usernameTextField.text isEqual:@""]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"^_^请填写用户名"
                                  message:nil
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        if (![Verifier isMobileNumber:_phoneNoTextField.text]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"^_^手机号码格式有误，请修正后重试"
                                  message:nil
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        
        [self showHudInView:self.view hint:@"正在注册..."];
        
        //注册AVOSCloud
        user = [AVUser user];
        user.username = _usernameTextField.text;
        user.password =  _passwordTextField.text;
        user.mobilePhoneNumber = _phoneNoTextField.text;
        [user setObject:_usernameTextField.text forKey:@"nickname"];
        //[user setObject:@"213-253-0000" forKey:@"phone"];
        
//        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                
//            } else {
//                
//            }
//        }];
        if([user signUp]) {
            SmsVerificationViewController *smsVerificationVC = [[SmsVerificationViewController alloc] init];
            smsVerificationVC.user = user;
            [self.navigationController pushViewController:smsVerificationVC animated:YES];
        }else {
            TTAlertNoTitle(@"该手机号已存在，不能重复注册！");
            [self hideHud];
        }
    }
}

- (IBAction)doShowHidePassword:(id)sender {
    _passwordTextField.secureTextEntry = !_passwordTextField.secureTextEntry;
}

- (BOOL)isEmpty{
    BOOL ret = NO;
    NSString *phoneNo = _phoneNoTextField.text;
    NSString *password = _passwordTextField.text;
    if (phoneNo.length == 0 || password.length == 0) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
