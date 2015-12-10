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
    NSString *userName,*uId,*password;
}

@end

@implementation UserOrdersViewController

@synthesize appDelegate = _appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    
    pageCount = 1;
    _type = @"0";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userName = [userDefaults valueForKey:@"userName"];
    uId = [userDefaults valueForKey:@"uId"];
    password = [userDefaults valueForKey:@"password"];
    
    [self initOrdersTableView];
    [self initPageButton];
}


- (void)initOrdersTableView{
    self.ordersTableView.delegate = self;
    self.ordersTableView.dataSource = self;
    [self.ordersTableView registerClass:[UserOrdersTableViewCell class] forCellReuseIdentifier:@"userOrdersTableViewCell"];
    
    self.ordersTableView.separatorColor = [UIColor redColor];
    self.ordersTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
}


- (void)initPageButton{
    
    [self setButton:self.allOrdersBtn];
    
    [self setButton:self.waitPayOrdersBtn];
    
    [self setButton:self.waitAcceptOrdersBtn];
    
    [self setButton:self.finishOrdersBtn];
    
}

- (void)setButton:(UIButton *)but{
    but.layer.cornerRadius = 5;
    but.layer.borderWidth = 0.3;
    [but addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
}

- (void) buttonAction:(id)sender{
    if (sender == self.allOrdersBtn) {
        _type = @"0";
    
        [self setBackgroundColor:self.allOrdersBtn whiteOne:self.waitPayOrdersBtn whiteTwe:self.waitAcceptOrdersBtn whiteThree:self.finishOrdersBtn];
    }else if (sender == self.waitPayOrdersBtn){
        _type = @"1";
        
        [self setBackgroundColor:self.waitPayOrdersBtn whiteOne:self.allOrdersBtn whiteTwe:self.waitAcceptOrdersBtn whiteThree:self.finishOrdersBtn];
    }else if (sender == self.waitAcceptOrdersBtn){
        _type = @"2";
        
        [self setBackgroundColor:self.waitAcceptOrdersBtn whiteOne:self.allOrdersBtn whiteTwe:self.waitPayOrdersBtn whiteThree:self.finishOrdersBtn];
    }else if (sender == self.finishOrdersBtn){
        _type = @"3";
        
        [self setBackgroundColor:self.finishOrdersBtn whiteOne:self.waitPayOrdersBtn whiteTwe:self.waitAcceptOrdersBtn whiteThree:self.allOrdersBtn];
    }
    [self getOrdersArrayInButton];
}

- (void)setBackgroundColor:(UIButton *)redButton whiteOne:(UIButton *)wOButton whiteTwe:(UIButton *)wTButton whiteThree:(UIButton *)wThButton{
    redButton.backgroundColor = [UIColor redColor];
    wOButton.backgroundColor = [UIColor whiteColor];
    wTButton.backgroundColor = [UIColor whiteColor];
    wThButton.backgroundColor = [UIColor whiteColor];
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
    
    cell.payOrderBtn.tag = [orderId integerValue]-1;
    [cell.payOrderBtn addTarget:self action:@selector(payOrderBtn:) forControlEvents:UIControlEventTouchDown];
   
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIButton *allBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [allBut setTitle:@"更多。。。" forState:UIControlStateNormal];
    [allBut addTarget:self action:@selector(getMemberOrdersNext) forControlEvents:UIControlEventTouchDown];
    if ([self.ordersArray count] > 4) {
        return allBut;
    }else{
        return nil;
    }
    
}

- (void)getMemberOrdersNext{
    pageCount =pageCount+1;
    [self requestOrdersArray];
}

- (void)requestOrdersArray{
    NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"userName",
                                password,@"pwd",
                                _type,@"type",
                                [NSString stringWithFormat:@"%ld",pageCount],@"page", nil];
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
    NSInteger orderId = ((UIButton *)sender).tag+1;
    NSDictionary *requetsDic = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",orderId],@"orderId", nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PayOrderViewController *payOrderView = [storyboard instantiateViewControllerWithIdentifier:@"payOrderViewController"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:PHONE_ORDER_DETAIL parameters:requetsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = responseObject;
        NSDictionary *detail = [result valueForKey:@"detail"];
        
        payOrderView.goodsInfoArray = [self goodsInfoWithResult:detail];

        NSDictionary *orderDetail = [[NSDictionary alloc]initWithObjectsAndKeys:userName ,@"userName",
                                     uId,@"uId",
                                     password,@"password",
                                     [result valueForKey:@"orderId"],@"orderId",
                                     [result valueForKey:@"totalPrice"],@"goodsPrice",
                                     [result valueForKey:@"fee"],@"freight",
                                     [result valueForKey:@"cheapPrice"],@"cheap",
                                     [result valueForKey:@"realPrice"],@"totale",
                                     detail,@"orderDetail", nil];
        
        [self presentViewController:payOrderView animated:YES completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"payOrderNoti" object:nil userInfo:orderDetail];
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *note = [[UIAlertView alloc]initWithTitle:@"提示" message:@"连接出错，请联系客服" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [note show];
    }];

}

- (NSMutableArray *)goodsInfoWithResult:(NSDictionary *)detail{
    
    NSMutableArray *goodsArray = [[NSMutableArray alloc]init];
    NSEnumerator *e = [detail keyEnumerator];
    for (NSString *key in e) {
        NSDictionary *valueDic = [detail valueForKey:key];
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
        Goods *goods = [self queryGoodsWithGoodsId:key];
        if (goods) {
            [newDic setValue:goods.name forKey:@"gname"];
            [newDic setValue:[NSString stringWithFormat:@"%@",[valueDic valueForKey:@"total"]] forKey:@"total"];
            NSDecimalNumber *goodsprice = [NSDecimalNumber decimalNumberWithString:goods.marketprice];
            NSDecimalNumber *total = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",[valueDic valueForKey:@"total"]]];
            NSDecimalNumber *totalPrice = [goodsprice decimalNumberByMultiplyingBy:total];
            [newDic setValue:[totalPrice stringValue] forKey:@"totalprice"];
            
            [goodsArray addObject:newDic];
            
        }else{
            NSLog(@"goods is  no");
        }
    }
    return goodsArray;
}

- (void)showOrderDetails:(id)sender{
    
    NSInteger orderId = ((UIButton *)sender).tag-1;
    NSDictionary *requetsDic = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",orderId],@"orderId", nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderDetailViewController *orderDetailView = [storyboard instantiateViewControllerWithIdentifier:@"orderDetailViewController"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:PHONE_ORDER_DETAIL parameters:requetsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = responseObject;
        
        orderDetailView.orderDetail = result;
        
        [self presentViewController:orderDetailView animated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *note = [[UIAlertView alloc]initWithTitle:@"提示" message:@"连接出错，请联系客服" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [note show];
    }];
    
}

- (Goods *)queryGoodsWithGoodsId:(NSString *)goodsId{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *table = [NSEntityDescription entityForName:@"Goods" inManagedObjectContext:_appDelegate.managedObjectContext];
    [fetchRequest setEntity:table];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gid=%@",goodsId];
    [fetchRequest setPredicate:predicate];
    NSArray *array = [_appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (array.count == 0) {
        return nil;
    }else{
        return [array objectAtIndex:0];
    }
    
}


- (IBAction)backPage:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
