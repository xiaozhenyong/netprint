//
//  OrderDetailViewController.h
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/10/16.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Goods.h"

@interface OrderDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *billIdLabel;//订单号
@property (strong, nonatomic) IBOutlet UILabel *payStatusLabel;//支付状态

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;//订单实付金额
@property (strong, nonatomic) IBOutlet UILabel *createTimeLabel;//订单创建时间

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;//收货人
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;//收货地址
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;//联系方式
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;//收货时间安排

@property (strong, nonatomic) IBOutlet UILabel *deTypeLabel;//配送方式
@property (strong, nonatomic) IBOutlet UILabel *delPriceLabel;//运费

@property (strong, nonatomic) IBOutlet UITableView *goodsInfoTableView;//商品明细


- (IBAction)back:(id)sender;

@property (strong, nonatomic) NSDictionary *orderDetail;

@property (strong, nonatomic)AppDelegate *appDelegate;

@end
