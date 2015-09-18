//
//  UserIndexViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/9.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "DefineData.h"
#import "NSString+URLEncoding.h"
#import "NSNumber+Message.h"
#import "LoginViewController.h"
#import "UserMoneyViewController.h"
#import "AddressManageViewController.h"
#import "ViewController.h"
#import "CartViewController.h"
#import "UserOrdersViewController.h"

@interface UserIndexViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;


- (IBAction)userOrder:(id)sender;

- (IBAction)userMoney:(id)sender;

- (IBAction)userAddressManage:(id)sender;

- (IBAction)userCoupon:(id)sender;

- (IBAction)userMsgSafe:(id)sender;

- (IBAction)userReload:(id)sender;

- (IBAction)toViewController:(id)sender;

- (IBAction)toCartViewController:(id)sender;

@property (strong,nonatomic)NSString *userName;
@property (strong,nonatomic)NSString *password;
@property (strong,nonatomic)NSString *userId;

@end
