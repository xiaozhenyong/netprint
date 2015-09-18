//
//  UserOrdersViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/9/7.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "DefineData.h"
#import "UserOrdersTableViewCell.h"

@interface UserOrdersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *allOrdersBtn;

@property (strong, nonatomic) IBOutlet UIButton *waitPayOrdersBtn;

@property (strong, nonatomic) IBOutlet UIButton *waitAcceptOrdersBtn;

@property (strong, nonatomic) IBOutlet UIButton *finishOrdersBtn;

@property (strong, nonatomic) IBOutlet UITableView *ordersTableView;

@property (strong,nonatomic)NSDictionary *userInfo;
@property (strong,nonatomic)NSMutableArray *ordersArray;

@end
