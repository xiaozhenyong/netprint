//
//  RetrievePasswordViewController.m
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/12/1.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "RetrievePasswordViewController.h"
#import "AFNetworking.h"
#import "DefineData.h"
#import "PhoneRetrievePasswordViewController.h"

@interface RetrievePasswordViewController (){
    UIStoryboard *storyboard;
    NSString *userId, *userName, *password;
}

@end

@implementation RetrievePasswordViewController

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
    
    [self.userPhoneTextField addTarget:self action:@selector(textFieldFocusEvent:) forControlEvents:UIControlEventTouchDown];
    [self.phoneCodeTextField addTarget:self action:@selector(textFieldFocusEvent:) forControlEvents:UIControlEventTouchDown];
}

- (void)textFieldFocusEvent:(id)sender{
    UITextField *textField = (UITextField *)sender;
    textField.text = @"";
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

- (IBAction)phoneCodeButton:(id)sender {
    NSString *phone = self.userPhoneTextField.text;
    if ([@"" isEqualToString:phone] || [@"注册的手机号" isEqualToString: phone]) {
        [self alertViewMessage:@"手机号不能为空"];
    }else{
        NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:phone,@"mobile",userId,@"userId", nil];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:PHONE_GET_CODE parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *responseValue = responseObject;
            [self alertViewMessage:[responseValue valueForKey:@"word"]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self alertViewMessage:@"服务不可用"];
        }];
    }
}

- (IBAction)retrievePasswordButton:(id)sender {
    NSString *phone = self.userPhoneTextField.text;
    NSString *code = self.phoneCodeTextField.text;
    
    if ([@"" isEqualToString:phone] || [@"注册的手机号" isEqualToString: phone]) {
        [self alertViewMessage:@"手机号不能为空"];
    }else if ([@"" isEqualToString:code] || [@"手机验证码" isEqualToString:code]){
        [self alertViewMessage:@"手机验证码不能为空"];
    }else{
        
        NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:phone,@"mobile",code,@"code",userId,@"userId", nil];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:PHONE_FIND_PWD parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *responseDic = responseObject;
            NSString *result = [responseDic valueForKey:@"result"];
            if ([@"codeOk" isEqualToString:result]) {
                PhoneRetrievePasswordViewController *phoneRetrieve = [storyboard instantiateViewControllerWithIdentifier:@"phoneRetrievePasswordViewController"];
                [self presentViewController:phoneRetrieve animated:YES completion:nil];
            }else{
                [self alertViewMessage:result];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self alertViewMessage:@"服务不可用"];
        }];
    }
}

- (void)alertViewMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
