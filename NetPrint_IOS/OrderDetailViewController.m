//
//  OrderDetailViewController.m
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/10/16.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController (){
    NSMutableArray *goodsArray;
    
}

@end

@implementation OrderDetailViewController

@synthesize appDelegate = _appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    goodsArray = [[NSMutableArray alloc]init];
    NSDictionary *detail = [self.orderDetail valueForKey:@"detail"];
    
    NSEnumerator *e = [detail keyEnumerator];
    for (NSString *key in e ) {
        NSDictionary *valueDic = [detail valueForKey:key];
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
        Goods *goods = [self queryGoodsWithGoodsId:key];
        if (goods) {
            [newDic setValue:goods.name forKey:@"gname"];
            [newDic setValue:[valueDic valueForKey:@"total"] forKey:@"total"];
            [goodsArray addObject:newDic];
        }else{
            NSLog(@"---goods is no");
        }
    }
    
    
    [self showOrderData];
    
    self.goodsInfoTableView.delegate = self;
    self.goodsInfoTableView.dataSource = self;
    self.goodsInfoTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)showOrderData{
    
    self.billIdLabel.text = [self.orderDetail valueForKey:@"billid"];
    NSString *payStatus = [self.orderDetail valueForKey:@"pay_status"];
    if ([@"0" isEqualToString:payStatus]) {
        self.payStatusLabel.text = @"未支付";
    }else{
        self.payStatusLabel.text = @"已支付";
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥:%@",[self.orderDetail valueForKey:@"realPrice"]] ;
    self.createTimeLabel.text = [self.orderDetail valueForKey:@"createtime"];
    
    self.userNameLabel.text = [self.orderDetail valueForKey:@"shipname"];
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[self.orderDetail valueForKey:@"province"],[self.orderDetail valueForKey:@"city"],[self.orderDetail valueForKey:@"county"],[self.orderDetail valueForKey:@"address"]];
    self.phoneLabel.text = [self.orderDetail valueForKey:@"mobilephone"];
    self.timeLabel.text = [NSString stringWithFormat:@"最佳收货时间:%@",[self.orderDetail valueForKey:@"deliverytime"]];
    self.deTypeLabel.text = [self.orderDetail valueForKey:@"deliveryName"];
    self.delPriceLabel.text = [NSString stringWithFormat:@"￥:%@",[self.orderDetail valueForKey:@"fee"]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [goodsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdetifier = @"goodsInfoTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdetifier];
    }
    NSDictionary *goodsDic = [goodsArray objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [goodsDic valueForKey:@"gname"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[goodsDic valueForKey:@"total"]];
    
     return cell;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
