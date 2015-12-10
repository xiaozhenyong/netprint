//
//  UserIndexViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/9.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "UserIndexViewController.h"
#import "UserCouponsShowViewController.h"
#import "UserSafeViewController.h"



@interface UserIndexViewController (){
    UIStoryboard *storyboard;
    NSString *userId,*password,*userName;
}

@end

@implementation UserIndexViewController


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

- (IBAction)userOrder:(id)sender {
    if (userName == nil) {
        LoginViewController *loginViewCon = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        [self presentViewController:loginViewCon animated:YES completion:nil];
    }else{
        NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"userName",password,@"pwd",@"0",@"type",@"1",@"page", nil];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:PHONE_MEMBER_ORDERS parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *responseValue = responseObject;
            NSString *res = [responseValue valueForKey:@"res"];
            if ([res isEqualToString:@"success"]) {
                NSArray *info = [responseValue valueForKey:@"info"];
                
                UserOrdersViewController *userOrdersView = [storyboard instantiateViewControllerWithIdentifier:@"userOrdersViewController"];
                userOrdersView.ordersArray = [info mutableCopy];
 //               userOrdersView.userInfo = userInfo;
                [self presentViewController:userOrdersView animated:YES completion:nil];
                
            }else{
               // NSLog(@"Server  is Error");
                UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"请求出错，或服务不可用" cancel:@"确定" other:nil];
                [alertView show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //NSLog(@"UserOrder Error------->%@",error);
            UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"请求出错，或服务不可用" cancel:@"确定" other:nil];
            [alertView show];
        }];
        
    }
}

- (IBAction)userMoney:(id)sender {
    if (userName == nil) {
        LoginViewController *loginViewCon = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        [self presentViewController:loginViewCon animated:YES completion:nil];
    }else{
        NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"userName",password,@"pwd", nil];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:PHONE_MEMBER_MONEY parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *responseValue = responseObject;
            NSString *res = [responseObject objectForKey:@"res"];
            if ([@"success" isEqualToString:res]) {
                NSArray *userInfoArray = [responseValue objectForKey:@"info"];
                if (userInfoArray) {
                    UserMoneyViewController *userMoney = [storyboard instantiateViewControllerWithIdentifier:@"userMoneyViewController"];
                    [userInfoArray setValue:userId forKey:@"uid"];
                    userMoney.mUserInfo = userInfoArray;
                    
                    userMoney.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [self presentViewController:userMoney animated:YES completion:nil];
                }else{
                    NSLog(@"----------no---------");
                }

            }else{
                
                UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"请求数据出错" cancel:@"确定" other:nil];
                [alertView show];
            }

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"服务不可用" cancel:@"确定" other:nil];
            [alertView show];
        }];
    }
}

- (IBAction)userAddressManage:(id)sender {
    
        AddressManageViewController *addrManage = [storyboard instantiateViewControllerWithIdentifier:@"addressManageViewController"];
    
        addrManage.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:addrManage animated:YES completion:nil];
}

- (IBAction)userCoupon:(id)sender {
    if (userName == nil) {
        LoginViewController *loginViewCon = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        [self presentViewController:loginViewCon animated:YES completion:nil];
    }else{
        NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"userName",password,@"pwd", nil];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:PHONE_MEMBER_COUPONS parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *responseValue = responseObject;
            NSString *res = [responseValue valueForKey:@"res"];
            if ([res isEqualToString:@"success"]) {
                NSDictionary *info = [responseValue valueForKey:@"info"];
                NSArray *list = [info valueForKey:@"list"];
                UserCouponsShowViewController *userCoupons = [storyboard instantiateViewControllerWithIdentifier:@"userCouponsShowViewController"];
                userCoupons.userCouponsArray = list;                //               userOrdersView.userInfo = userInfo;
                [self presentViewController:userCoupons animated:YES completion:nil];
                
            }else{
                // NSLog(@"Server  is Error");
                UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"请求出错，或服务不可用" cancel:@"确定" other:nil];
                [alertView show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //NSLog(@"UserOrder Error------->%@",error);
            UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"请求出错，或服务不可用" cancel:@"确定" other:nil];
            [alertView show];
        }];
        
    }

}

- (IBAction)userMsgSafe:(id)sender {
    UserSafeViewController *userSafe = [storyboard instantiateViewControllerWithIdentifier:@"userSafeViewController"];
    [self presentViewController:userSafe animated:YES completion:nil];
}

- (IBAction)userReload:(id)sender {
    LoginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@"uId" forKey:@""];
    [userDefaults setObject:@"userName" forKey:@""];
    [userDefaults setObject:@"password" forKey:@""];
    login.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:login
                       animated:YES completion:nil];
}

- (IBAction)toViewController:(id)sender {
    ViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    [self gotoUIViewController:viewCon];
}

- (IBAction)toCartViewController:(id)sender {
    CartViewController *cartViewCon = [storyboard instantiateViewControllerWithIdentifier:@"cartViewController"];
    [self gotoUIViewController:cartViewCon];
}

- (void)gotoUIViewController:(UIViewController *)view{
    
    [self presentViewController:view animated:YES completion:nil];
    /*
    [self presentViewController:view animated:YES completion:^{
        if (userInfo) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil userInfo:userInfo];
        }
    }];
     */
}
@end
