//
//  UserIndexViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/9.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "UserIndexViewController.h"



@interface UserIndexViewController (){
    UIStoryboard *storyboard;
    NSDictionary *userInfo;
}

@end

@implementation UserIndexViewController

@synthesize userId,password,userName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserMsgWithNotification:) name:@"UserLoginCompletionNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) getUserMsgWithNotification:(NSNotification *)notification{

    NSDictionary *dic = [notification userInfo];
    self.userName = [dic objectForKey:@"userName"];
    self.userId = [dic objectForKey:@"uId"];
    self.password = [dic objectForKey:@"password"];
    
    self.userNameLabel.text = userName;
    
    userInfo = dic;
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
}

- (IBAction)userMoney:(id)sender {
    
    NSArray *userInfoArray = [[NSMutableArray alloc]init];
    /*
    __block NSInteger infoId = 0;
    __block NSString *infoUserId = nil;
    __block float infoMoney = 0.0;
    __block NSString *infoMemberAvatar = nil;
    __block NSInteger haveInfo = 0;
     */
    NSError *error;
    NSString *baseUrl = [[NSString alloc]initWithFormat:PHONE_MEMBER_MONEY];
    NSURL *url = [NSURL URLWithString:[baseUrl URLEncodedString]];
    NSString *post = [NSString stringWithFormat:@"userName=%@&pwd=%@",self.userName,self.password];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (data) {
        id jsonValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (!jsonValue || error) {
            NSLog(@"--jsonvalue fail-");
        }
        NSString *res = [jsonValue objectForKey:@"res"];
        if ([@"success" isEqualToString:res]) {
            userInfoArray = [jsonValue objectForKey:@"info"];
        }else{
            NSLog(@"-----------get  money fail-----------");
        }

    }else{
        NSLog(@"-----------money fail-----------");
    }
    /*
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
     
        if (data) {
            id jsonValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (!jsonValue || error) {
                
                NSLog(@"--jsonvalue fail-");
                
            }
            NSString *res = [jsonValue objectForKey:@"res"];
            if ([@"success" isEqualToString:res]) {
                
               NSArray  *userInfo = [jsonValue objectForKey:@"info"];
               
             }else{
            
                NSLog(@"-----------get  money fail-----------");
            }
        }else{
     
        }
    }];
    */
    
    if (userInfoArray) {
        UserMoneyViewController *userMoney = [storyboard instantiateViewControllerWithIdentifier:@"userMoneyViewController"];
        
        userMoney.mUserInfo = userInfoArray;
        
        userMoney.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:userMoney animated:YES completion:nil];
    }else{
        NSLog(@"----------no---------");
    }
    
}

- (IBAction)userAddressManage:(id)sender {
    
        AddressManageViewController *addrManage = [storyboard instantiateViewControllerWithIdentifier:@"addressManageViewController"];
    addrManage.userDic = userInfo;
    //[NSDictionary dictionaryWithObjectsAndKeys:userName,@"userName",password,@"password",userId,@"uId", nil];
    
        addrManage.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:addrManage animated:YES completion:nil];
}

- (IBAction)userCoupon:(id)sender {
}

- (IBAction)userMsgSafe:(id)sender {
}

- (IBAction)userReload:(id)sender {
    LoginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
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
    [self presentViewController:view animated:YES completion:^{
        if (userInfo) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil userInfo:userInfo];
        }
    }];
}
@end
