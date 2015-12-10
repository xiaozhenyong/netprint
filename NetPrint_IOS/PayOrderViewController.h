//
//  PayOrderViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/24.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cart.h"
#import "PayOrderShowTableViewCell.h"
#import "PayFinishViewController.h"
#import "DefineData.h"
#import "ViewController.h"
#import "CartViewController.h"
#import "UserIndexViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface PayOrderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *cartShowTableView;
@property (strong, nonatomic) IBOutlet UILabel *goodsPiceLabel;
@property (strong, nonatomic) IBOutlet UILabel *feiLabel;
@property (strong, nonatomic) IBOutlet UILabel *cheapLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
- (IBAction)alipayButton:(id)sender;
- (IBAction)balancePayButton:(id)sender;

- (IBAction)backPage:(id)sender;

- (IBAction)toViewController:(id)sender;
- (IBAction)toCartViewController:(id)sender;
- (IBAction)toUserIndexViewController:(id)sender;


@property (strong,nonatomic)NSArray *cartArray;
@property (strong,nonatomic)NSMutableArray *goodsInfoArray;

@end
