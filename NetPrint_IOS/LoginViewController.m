//
//  LoginViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/9.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

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
   __block NSString *userFlag = self.user.text;
   __block NSString *password = self.password.text;
    __block BOOL loginSuccess = NO;
    
    NSString *baseUrl = [[NSString alloc]initWithFormat:PHONE_LOGIN];
    NSURL *url = [NSURL URLWithString:[baseUrl URLEncodedString]];
    NSString *post = [NSString stringWithFormat:@"userName=%@&pwd=%@&szImei=%@&phoneName=%@",userFlag,password,@"",@""];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        if (data) {
            id jsonValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (!jsonValue || error) {
                loginSuccess = NO;
            }
            NSString *res = [jsonValue objectForKey:@"res"];
            NSString *userId = nil;
            if ([@"ok" isEqualToString:res]) {
                userId = [jsonValue objectForKey:@"memberId"];
                [self addNotificationWithUserName:userFlag password:password userId:userId];
                loginSuccess = YES;
            }else{
                NSLog(@"-----get userId  fail------");
            }
            
        }else{
            NSLog(@"----------login fail--------");
        }
    }];
    if (loginSuccess) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)addNotificationWithUserName:(NSString *)_uName password:(NSString *)_uPassword userId:(NSString *)_uId{
    [self dismissViewControllerAnimated:YES completion:^{
        NSDictionary *userDic = [[NSDictionary alloc]initWithObjectsAndKeys:_uName,@"userName",_uId,@"userId",_uPassword ,@"password" ,nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLoginCompletionNotification" object:nil userInfo:userDic];
    }];
}
@end
