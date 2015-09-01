//
//  CartViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/4.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DefineData.h"
#import "NSString+URLEncoding.h"
#import "NSNumber+Message.h"
#import "Cart.h"
#import "Goods.h"
#import "CartTableViewCell.h"
#import "LoginViewController.h"
#import "DistributionMsgViewController.h"
#import "ViewController.h"
#import "UserIndexViewController.h"

@interface CartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *cartShow;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
- (IBAction)backPage:(id)sender;
- (IBAction)settleButton:(id)sender;
- (IBAction)toViewController:(id)sender;
- (IBAction)toUserIndexViewController:(id)sender;

@property (strong,nonatomic)AppDelegate *appDelegate;

@property (strong, nonatomic)NSMutableArray *cartArray;

@end
