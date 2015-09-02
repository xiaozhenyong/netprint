//
//  AddressManageViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/10.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddrShowTableViewCell.h"
#import "AddAndEditAddressViewController.h"
#import "ViewController.h"
#import "CartViewController.h"
#import "UserIndexViewController.h"

@interface AddressManageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *addressShow;

- (IBAction)back:(id)sender;
- (IBAction)addNewAddress:(id)sender;

- (IBAction)toViewController:(id)sender;
- (IBAction)toCartViewController:(id)sender;
- (IBAction)toUserIndexViewController:(id)sender;

@property (strong,nonatomic)NSMutableArray *addreInfo;
@property (strong,nonatomic)NSDictionary *userDic;

@end
