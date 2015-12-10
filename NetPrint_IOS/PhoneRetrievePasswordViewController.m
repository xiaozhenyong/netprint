//
//  PhoneRetrievePasswordViewController.m
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/12/3.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "PhoneRetrievePasswordViewController.h"
#import "AFNetworking.h"
#import "DefineData.h"
#import "ViewController.h"

@interface PhoneRetrievePasswordViewController (){
    UIStoryboard *storyboard;
    NSString *userId, *userName, *password;
}

@end

@implementation PhoneRetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self userInfoWithUserDefaults];
    [self initPage];
}

- (void)userInfoWithUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults valueForKey:@"uId"];
    userName = [userDefaults valueForKey:@"userName"];
    password = [userDefaults valueForKey:@"password"];
    
}

- (void)initPage{
    self.userNameLabel.text = userName;
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [self.nPasswordTextField addTarget:self action:@selector(textFieldFocusEvent:) forControlEvents:UIControlEventTouchDown];
    [self.cPasswordTextField addTarget:self action:@selector(textFieldFocusEvent:) forControlEvents:UIControlEventTouchDown];
}

- (void)textFieldFocusEvent:(id)sender{
    UITextField *textField = (UITextField *)sender;
    textField.text = @"";
    textField.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)setNewPasswordButton:(id)sender {
    NSString *nPassword = self.nPasswordTextField.text;
    NSString *cPassword = self.cPasswordTextField.text;
    
    if ([@"" isEqualToString:nPassword] || [@"输入新密码" isEqualToString:nPassword]) {
        [self alertViewMessage:@"请输入新密码"];
    }else if ([@"" isEqualToString:cPassword] || [@"确认新密码" isEqualToString:cPassword]){
        [self alertViewMessage:@"确认新密码不能为空"];
    }else if ([nPassword isEqualToString:cPassword]){
        
        NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:nPassword,@"pwd",userId,@"userId", nil];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:PHONE_SET_PWD parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *resultDic = responseObject;
            NSString *result = [resultDic objectForKey:@"res"];
            if ([@"ok" isEqualToString:result]) {
                [self alertViewMessage:@"修改成功"];
                ViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"viewController"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:nPassword forKey:@"password"];
                [self presentViewController:view animated:YES completion:nil];
            }else{
                [self alertViewMessage:@"修改失败"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self alertViewMessage:@"服务不可用"];
        }];
        
    }else{
        [self alertViewMessage:@"两次输入的密码不一致"];
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertViewMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
@end
