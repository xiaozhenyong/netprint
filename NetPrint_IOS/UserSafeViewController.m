//
//  UserSafeViewController.m
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/12/1.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "UserSafeViewController.h"
#import "RetrievePasswordViewController.h"
#import "AFNetworking.h"
#import "DefineData.h"

@interface UserSafeViewController (){
    UIStoryboard *storyboard;
    NSString *userId,*password,*userName;
}
@end

@implementation UserSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self userInfoWitUserDefaults];
    [self initPage];
}

- (void)userInfoWitUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userId = [userDefaults valueForKey:@"uId"];
    userName = [userDefaults valueForKey:@"userName"];
    password = [userDefaults valueForKey:@"password"];
}

- (void)initPage{
    self.userNameLabel.text = userName;
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [self.oldPasswordTextField addTarget:self action:@selector(textFieldFocusEventForPassword:) forControlEvents:UIControlEventTouchDown];
    [self.nPasswordTextField addTarget:self action:@selector(textFieldFocusEventForPassword:) forControlEvents:UIControlEventTouchDown];
    [self.confirmNewPasswordTextField addTarget:self action:@selector(textFieldFocusEventForPassword:) forControlEvents:UIControlEventTouchDown];
}

- (void)textFieldFocusEventForPassword:(id)sender{
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

- (IBAction)retrievePasswordButton:(id)sender {
    RetrievePasswordViewController *retrievePassword = [storyboard instantiateViewControllerWithIdentifier:@"retrievePasswordViewController"];
    [self presentViewController:retrievePassword animated:YES completion:nil];
}

- (IBAction)editPasswordButton:(id)sender {
    NSString *oldPassword = self.oldPasswordTextField.text;
    NSString *nPassword = self.nPasswordTextField.text;
    NSString *cPassword = self.confirmNewPasswordTextField.text;
    if ([@"" isEqualToString:oldPassword] || [@"旧密码" isEqualToString:oldPassword]) {
        [self alertViewMessage:@"旧密码不能为空"];
    }else if([@"" isEqualToString:nPassword] || [@"输入新密码" isEqualToString:nPassword]){
        [self alertViewMessage:@"新密码不能为空"];
        
    }else if ([@"" isEqualToString:oldPassword] || [@"旧密码" isEqualToString:oldPassword]){
        [self alertViewMessage:@"新密码确认不能为空"];
    }else if ([nPassword isEqualToString:cPassword]) {
        NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"userName",nPassword,@"new",oldPassword,@"old",cPassword,@"pwd", nil];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:PHONE_CHANGE_PWD parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *responseValue = responseObject;
            NSString *result = [responseValue valueForKey:@"res"];
            if ([@"ok" isEqualToString:result]) {
                [self alertViewMessage:@"修改成功"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:nPassword forKey:@"password"];
                
            }else{
                [self alertViewMessage:@"修改失败"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self alertViewMessage:@"服务不可用"];
        }];

    }else {
        [self alertViewMessage:@"两次输入密码不一致"];
    }
}

- (void)alertViewMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
