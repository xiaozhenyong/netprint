//
//  UserOrdersViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/9/7.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "UserOrdersViewController.h"

@interface UserOrdersViewController (){
    NSInteger pageCount;
    NSString *_type;//0=全部，1=待付款，2＝待收货，3=已完成
}

@end

@implementation UserOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageCount = 1;
    _type = @"0";
    
    [self initOrdersTableView];
    [self initPageButton];
}


- (void)initOrdersTableView{
    self.ordersTableView.delegate = self;
    self.ordersTableView.dataSource = self;
    [self.ordersTableView registerClass:[UserOrdersTableViewCell class] forCellReuseIdentifier:@"userOrdersTableViewCell"];
    
    self.ordersTableView.separatorColor = [UIColor redColor];
    
}


- (void)initPageButton{
    [self.allOrdersBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    
    [self.waitPayOrdersBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    
    [self.waitAcceptOrdersBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    
    [self.finishOrdersBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
}


- (void) buttonAction:(id)sender{
    if (sender == self.allOrdersBtn) {
        _type = @"0";
    }else if (sender == self.waitPayOrdersBtn){
        _type = @"1";
    }else if (sender == self.waitAcceptOrdersBtn){
        _type = @"2";
    }else if (sender == self.finishOrdersBtn){
        _type = @"3";
    }
    [self getOrdersArrayInButton];
}

- (void)getOrdersArrayInButton{
    pageCount = 1;
    [self.ordersArray removeAllObjects];
    [self requestOrdersArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.ordersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *orderDic = [self.ordersArray objectAtIndex:[indexPath row] ];
    static NSString *cellName = @"userOrdersTableCell";
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
        UINib *nib = [UINib nibWithNibName:@"UserOrdersTableViewCell" bundle:classBundle];
        [tableView registerNib:nib forCellReuseIdentifier:cellName];
    }
    
    UserOrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
    NSString *billId = [orderDic valueForKey:@"billid"];
    NSString *createTime = [orderDic valueForKey:@"createtime"];
//    NSString *goodsName = [orderDic valueForKey:@"goodsname"];
    NSInteger pay_status = [[orderDic valueForKey:@"pay_status"] integerValue];
    NSString *price = [NSString stringWithFormat:@"%@",[orderDic valueForKey:@"price"]];
//    NSInteger ship_status = [[orderDic valueForKey:@"ship_status"] integerValue];
 //   NSInteger status = [[orderDic valueForKey:@"status"] integerValue];
 //   NSInteger user_status = [[orderDic valueForKey:@"user_status"] integerValue];
    NSNumber *orderId = [orderDic valueForKey:@"id"];
    
    cell.billIdLabel.text = billId;
    cell.createTimeLabel.text = createTime;
    cell.priceLabel.text = price;
    if (pay_status == 0) {
        cell.payStateLabel.text = @"未支付";
        cell.payOrderBtn.tag = [orderId integerValue];
        [cell.payOrderBtn addTarget:self action:@selector(payOrderBtn:) forControlEvents:UIControlEventTouchDown];
        cell.payOrderBtn.hidden = NO;
    }else{
        cell.payStateLabel.text = @"已支付";
        cell.payOrderBtn.hidden = YES;
    }
    cell.orderDetailBtn.tag = [orderId integerValue]+1;
    [cell.orderDetailBtn addTarget:self action:@selector(showOrderDetails:) forControlEvents:UIControlEventTouchDown];
   
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIButton *allBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [allBut setTitle:@"更多。。。" forState:UIControlStateNormal];
    [allBut addTarget:self action:@selector(getMemberOrdersNext) forControlEvents:UIControlEventTouchDown];
    return allBut ;
}

- (void)getMemberOrdersNext{
    pageCount =pageCount+1;
    [self requestOrdersArray];
}

- (void)requestOrdersArray{
    NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:[self.userInfo valueForKey:@"userName"],@"userName",[self.userInfo valueForKey:@"password"],@"pwd",_type,@"type",[NSString stringWithFormat:@"%ld",pageCount],@"page", nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:PHONE_MEMBER_ORDERS parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseValue = responseObject;
        NSString *res = [responseValue valueForKey:@"res"];
        
        if ([res isEqualToString:@"success"]) {
            NSArray *info = [responseValue valueForKey:@"info"];
            for (NSDictionary *dic in info) {
                [self.ordersArray addObject:dic];
            }
        }
        [self.ordersTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)payOrderBtn:(id)sender{
    
}

- (void)showOrderDetails:(id)sender{

}

@end
