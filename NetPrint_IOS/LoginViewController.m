//
//  LoginViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/9.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "RegisterViewController.h"
#import "DefineData.h"
#import "BaseView.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.user addTarget:self action:@selector(getFocusEvent:) forControlEvents:UIControlEventTouchDown];
    
    [self.password addTarget:self action:@selector(getFocusEventForPassword:) forControlEvents:UIControlEventTouchDown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getFocusEvent:(id)sender{
    UITextField *textfiled = (UITextField *)sender;
    textfiled.text = @"";
}

- (void)getFocusEventForPassword:(id)sender{
    UITextField *textfiled = (UITextField *)sender;
    textfiled.text = @"";
    textfiled.secureTextEntry = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registPage:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterViewController *regist = [storyboard instantiateViewControllerWithIdentifier:@"registerViewController"];
    regist.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:regist animated:YES completion:nil];
    
}

- (IBAction)loginButton:(id)sender {
    NSString *userFlag = self.user.text;
    NSString *password = self.password.text;
    
    if ([@"" isEqualToString:userFlag] || [@"手机号/会员名/邮箱" isEqualToString:userFlag]) {
        [self alertViewWithMessage:@"会员名处不能为空"];
    }else if ([@"" isEqualToString:password] || [@"密码" isEqualToString:password]){
        [self alertViewWithMessage:@"密码不能为空"];
    }else{
    
        NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:userFlag,@"userName",password,@"pwd",@"",@"szImei",@"",@"phoneName", nil];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:PHONE_LOGIN parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *responseValue = responseObject;
            NSString *res = [responseValue valueForKey:@"res"];
            if ([@"ok" isEqualToString:res]) {
                [self addNotificationWithUserName:userFlag password:password userId:[NSString stringWithFormat:@"%@",[responseValue valueForKey:@"memberId"]]];
            }else{
                [self alertViewWithMessage:@"用户不存在"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self alertViewWithMessage:@"服务不可用"];
        }];
    }
}

- (void)addNotificationWithUserName:(NSString *)_uName password:(NSString *)_uPassword userId:(NSString *)_uId{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:_uId forKey:@"uId"];
    [userDefaults setObject:_uName forKey:@"userName"];
    [userDefaults setObject:_uPassword forKey:@"password"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)alertViewWithMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
@end
