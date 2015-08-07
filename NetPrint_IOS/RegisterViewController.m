//
//  RegisterViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/8.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mailTextField addTarget:self action:@selector(getFocusEvent:) forControlEvents:UIControlEventTouchDown];
    [self.userNameTextField addTarget:self action:@selector(getFocusEvent:) forControlEvents:UIControlEventTouchDown];
    
    [self.passwordTextField addTarget:self action:@selector(getFocusEventForPassword:) forControlEvents:UIControlEventTouchDown];
    
    
    [self.contersignTextField addTarget:self action:@selector(getFocusEventForPassword:) forControlEvents:UIControlEventTouchDown];
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

- (IBAction)registerButton:(id)sender {
    NSString *mail = self.mailTextField.text;
    NSString *userName = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *contensign = self.contersignTextField.text;
    BOOL mainText = NO;
    BOOL userNameText = NO;
    BOOL passworldText = NO;
    BOOL contensignText = NO;
    BOOL psAndCont = NO;

    if (mail == nil) {
        NSString *message = @"邮箱不能为空";
        [self showAlertMessage:message];
        mainText = NO;
    }else{
        mainText = YES;
    }
    if (userName == nil) {
        NSString *message = @"用户名不能为空";
        [self showAlertMessage:message];
        userNameText = NO;
    
    }else{
        userNameText = YES;
    }
    if (password == nil) {
        NSString *message = @"密码不能为空";
        [self showAlertMessage:message];
        passworldText = NO;
    }else{
        passworldText = YES;
    }
    
    if (contensign == nil) {
        NSString *message = @"密码确认不能为空";
        [self showAlertMessage:message];
        contensignText = NO;
    }else{
    
        contensignText = YES;
    }
    
    if (![password isEqualToString:contensign]) {
        NSString *message = @"两次密码输入不一致";
        [self showAlertMessage:message];
        psAndCont = NO;
    }else{
        psAndCont = YES;
    }
    
    NSString *phoneName = [self getPhoneModel];
    
    if (mainText && userNameText && psAndCont && passworldText && contensignText) {
        NSString *baseUrl = [[NSString alloc]initWithFormat: REGIST];
        NSURL *url = [NSURL URLWithString:[baseUrl URLEncodedString]];
        NSString *post = [NSString stringWithFormat:@"email=%@&username=%@&pwd=%@&szImei=%@&phoneName=%@",mail,userName,password,@"",phoneName];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            [self showData:data];
        }];
    }
    
}

- (void) showData:(NSData *)data{

    
}
- (void)showAlertMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Attention" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
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

- (NSString *)getPhoneModel{
    return [[UIDevice currentDevice]model];
}
@end
