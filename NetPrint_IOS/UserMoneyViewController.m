//
//  UserMoneyViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/9.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "UserMoneyViewController.h"

@interface UserMoneyViewController ()

@end

@implementation UserMoneyViewController

@synthesize mUserInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSString *userId = [self.mUserInfo valueForKey:@"userid"];
    
    NSNumber *nprice = [self.mUserInfo valueForKey:@"money"];
    float _price = [nprice floatValue];
    NSString *price = [NSString stringWithFormat:@"%0.2f",_price];
    
    self.userNameLabel.text = userId;
    self.userMoneyLabel.text = price;
    
}

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

- (IBAction)backPage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)topUpButton:(id)sender {
}
@end
