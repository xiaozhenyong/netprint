//
//  ViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/6/18.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "ViewController.h"
#import "BeginPrintViewController.h"
#import "CartViewController.h"
#import "UserIndexViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)createVindor{
    return [[[UIDevice currentDevice]identifierForVendor]UUIDString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)photoPrint:(id)sender {
    [self gotoPrint:@"0"];
}

- (IBAction)gotoCartPage:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CartViewController *cart = [storyboard instantiateViewControllerWithIdentifier:@"cartViewController"];
     cart.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:cart animated:YES completion:nil];
}

- (IBAction)testGotoRegister:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserIndexViewController *userIndex = [storyboard instantiateViewControllerWithIdentifier:@"userIndexViewController"];
    userIndex.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:userIndex animated:YES completion:nil];
}

//证件照
- (IBAction)paperPrint:(id)sender {
    [self gotoPrint:@"1"];
}

//拍立得
- (IBAction)polaroidPrint:(id)sender {
    [self gotoPrint:@"2"];
}

//页面跳转
- (void)gotoPrint:(NSString *)flag{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BeginPrintViewController *beginPrint = [storyBoard instantiateViewControllerWithIdentifier:@"beginPrintViewController"];
    beginPrint.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    beginPrint.bFlag = flag;
    
    beginPrint.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:beginPrint animated:YES completion:^{NSLog(@"");}];
 }


@end
