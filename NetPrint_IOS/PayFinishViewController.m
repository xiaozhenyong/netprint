//
//  PayFinishViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/24.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "PayFinishViewController.h"

@interface PayFinishViewController (){
    UIStoryboard *storyboard;
    NSDictionary *uInfo;
}

@end

@implementation PayFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserInfoWithNotification:) name:@"payFinishNoti" object:nil];
}
/*
- (void)getUserInfoWithNotification:(NSNotification *)notification{
    uInfo = [notification userInfo];
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)toViewController:(id)sender {
    ViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"viewController"];
        [self presentViewController:viewCon animated:YES completion:nil];
    /*
    [self presentViewController:viewCon animated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil userInfo:uInfo];
    }];
     */
}

- (IBAction)toCartViewController:(id)sender {
    CartViewController *cartViewCon = [storyboard instantiateViewControllerWithIdentifier:@"cartViewController"];
    [self presentViewController:cartViewCon animated:YES completion:nil];
    /*
    [self presentViewController:cartViewCon animated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil userInfo:uInfo];
    }];
     */
}

- (IBAction)toUserIndexViewController:(id)sender {
    UserIndexViewController *userIndexViewCon = [storyboard instantiateViewControllerWithIdentifier:@"userIndexController"];
        [self presentViewController:userIndexViewCon animated:YES completion:nil];
    /*
    [self presentViewController:userIndexViewCon animated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil userInfo:uInfo];
    }];
     */
}
@end
