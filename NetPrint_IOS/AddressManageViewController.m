//
//  AddressManageViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/10.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "AddressManageViewController.h"

@interface AddressManageViewController (){
    NSString *userName,*password;
}
@end

@implementation AddressManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getEditAddressNotification:) name:@"editAddressInfo" object:nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userName = [userDefaults valueForKey:@"userName"];
    password = [userDefaults valueForKey:@"password"];
    
    
    [self initAddressInfo];
    [self initTableView];
}

- (void)getEditAddressNotification:(NSNotification *)notification{
    NSDictionary *dic = [notification userInfo];
    NSString *addId = [dic objectForKey:@"id"];
    
    //这个有问题
    for (NSMutableDictionary *dicInfo in self.addreInfo) {
        NSString *dicAddId = [NSString stringWithFormat:@"%@",[dicInfo objectForKey:@"id"]];
        [dicInfo removeObjectForKey:@"isUsed"];
        [dicInfo setValue:@"0" forKey:@"isUsed"];
        if ([addId isEqualToString:dicAddId]) {
            [self.addreInfo removeObject:dicInfo];
        }
    }
    [self.addreInfo addObject:dic];
    [self.addressShow reloadData];
}



- (void)initAddressInfo{
    
    NSError *error;
    NSString *baseUrl = [[NSString alloc]initWithFormat:PHONE_ADDRES];
    NSURL *url = [NSURL URLWithString:[baseUrl URLEncodedString]];
    NSString *post = [NSString stringWithFormat:@"userName=%@&pwd=%@",userName,password];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (data) {
        id jsonValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (!jsonValue || error) {
            UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"数据请求出错" cancel:@"确定" other:nil];
            [alertView show];
        }
        NSString *res = [jsonValue objectForKey:@"res"];
        if ([@"success" isEqualToString:res]) {
            self.addreInfo = [jsonValue objectForKey:@"addrs"];
        }else{
            UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"数据请求出错" cancel:@"确定" other:nil];
            [alertView show];
        }
        
    }else{
        UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"服务不可用" cancel:@"确定" other:nil];
        [alertView show];
    }
    

}

- (void)initTableView{
    [self.addressShow flashScrollIndicators];
    self.addressShow.delegate = self;
    self.addressShow.dataSource = self;
    [self.addressShow registerClass:[AddrShowTableViewCell class] forCellReuseIdentifier:@"addrShowTableViewCell"];
    self.addressShow.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.addreInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *customCell = @"addrShowTableViewCell";
    //static BOOL nibsRegistered = NO;
    //if (!nibsRegistered) {
        NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
        UINib *nib = [UINib nibWithNibName:@"AddrShowTableViewCell" bundle:classBundle];
        [tableView registerNib:nib  forCellReuseIdentifier:customCell];
    //}
    
    AddrShowTableViewCell *addrShowCell = [tableView dequeueReusableCellWithIdentifier:customCell forIndexPath:indexPath];
    NSUInteger row = [indexPath row];
    
    NSString *addrId = [[self.addreInfo objectAtIndex:row] valueForKey:@"id"];
    NSInteger _addrId = [addrId integerValue];
    
    addrShowCell.deliveryManLabel.text=[[self.addreInfo objectAtIndex:row] valueForKey:@"deliveryMan"];
    
    NSString *mobilePhone = [[self.addreInfo objectAtIndex:row] valueForKey:@"mobilePhone"];
    NSString *tel = [[self.addreInfo objectAtIndex:row] valueForKey:@"tel"];
    
    if (mobilePhone) {
        addrShowCell.contactLabel.text =mobilePhone;
    }else if(tel){
        addrShowCell.contactLabel.text = tel;
    }else{
        addrShowCell.contactLabel.text = @"-";
    }
    
    
    NSString *province = [[self.addreInfo objectAtIndex:row] valueForKey:@"provinceName"];
    NSString *city = [[self.addreInfo objectAtIndex:row] valueForKey:@"cityName"];
    NSString *county = [[self.addreInfo objectAtIndex:row] valueForKey:@"countyName"];
    NSString *addrDetail = [[self.addreInfo objectAtIndex:row] valueForKey:@"address"];
    //province,city,county,addrDetail
    NSString *a = [province stringByAppendingFormat:@"%@%@%@",city,county,addrDetail];
    
    addrShowCell.addressLabel.text = a;
    
    NSNumber *isUsed = [[self.addreInfo objectAtIndex:row] valueForKey:@"isUsed"];
    
    
    int _isUsed = [isUsed intValue];
    
    if (_isUsed == 1) {
        [addrShowCell.setAddressButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [addrShowCell.setAddressButton setTitle:@"默认地址" forState:UIControlStateNormal];
        
    }else{
        [addrShowCell.setAddressButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [addrShowCell.setAddressButton setTitle:@"设为默认" forState:UIControlStateNormal];
        [addrShowCell.setAddressButton addTarget:self action:@selector(setDefaultAddressButton:) forControlEvents:UIControlEventTouchDown];
        [addrShowCell.setAddressButton setTag:_addrId];
    }
    
    [addrShowCell.editAddressButton setTitle:@"编辑" forState:UIControlStateNormal];
    [addrShowCell.editAddressButton addTarget:self action:@selector(editAddressButton:) forControlEvents:UIControlEventTouchDown];
    [addrShowCell.editAddressButton setTag:_addrId];
    
    [addrShowCell.deleteAddressButton setTitle:@"删除" forState:UIControlStateNormal];
    [addrShowCell.deleteAddressButton addTarget:self action:@selector(deleteAddressButton:) forControlEvents:UIControlEventTouchDown];
    [addrShowCell.deleteAddressButton setTag:_addrId];
    
    return addrShowCell;
}

- (void) setDefaultAddressButton:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    NSInteger butTag = [button tag];
    NSString *_butTag = [NSString stringWithFormat:@"%ld",butTag];
    
    NSError *isDefaulError;
    
    NSString *baseUrl = [[NSString alloc]initWithFormat:PHONE_ADDR_UPDATE ];
    NSURL *url = [NSURL URLWithString:[baseUrl URLEncodedString]];
    NSString *post = [NSString stringWithFormat:@"userName=%@&pwd=%@&type=%@&addrId=%@",userName,password,@"setDefault",_butTag];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&isDefaulError];
    if (data) {
        id jsonValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (!jsonValue) {
           // NSLog(@"-----address setDefault fail----");
            UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"数据请求出错" cancel:@"确定" other:nil];
            [alertView show];
        }else{
            for (NSMutableDictionary *dic in self.addreInfo) {
                NSString *addrId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
                [dic removeObjectForKey:@"isUsed"];
                if ([addrId isEqualToString:_butTag]) {
                    [dic setValue:@"1" forKey:@"isUsed"];
                }else{
                    [dic setValue:@"0" forKey:@"isUsed"];
                }
            }
            
            [self.addressShow reloadData];
        }
    }else{
        UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"服务不可用" cancel:@"确定" other:nil];
        [alertView show];
    }
}
- (void) editAddressButton:(id)sender{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAndEditAddressViewController *addAndEdit = [storyBoard instantiateViewControllerWithIdentifier:@"addAndEditAddressViewController"];
    
    addAndEdit.addressInfo = self.addreInfo;
//    addAndEdit.userDic = self.userDic;
    [self presentViewController:addAndEdit animated:YES completion:nil];
    
}

- (void)deleteAddressButton:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger butTag = [button tag];
    NSString *_butTag = [NSString stringWithFormat:@"%ld",butTag];
    
    NSError *isDefaulError;
    
    NSString *baseUrl = [[NSString alloc]initWithFormat:PHONE_ADDR_UPDATE ];
    NSURL *url = [NSURL URLWithString:[baseUrl URLEncodedString]];
    NSString *post = [NSString stringWithFormat:@"userName=%@&pwd=%@&type=%@&addrId=%@",userName,password,@"del",_butTag];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&isDefaulError];
    if (data) {
        id jsonValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (!jsonValue) {
            UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"数据请求出错" cancel:@"确定" other:nil];
            [alertView show];
        }else{
            for (NSMutableDictionary *dic in self.addreInfo) {
                NSString *addrId = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
                if ([addrId isEqualToString:_butTag]) {
                    [self.addreInfo removeObject:dic];
                    break;
                }
            }
            [self.addressShow reloadData];
        }
    }else{
        UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"服务不可用" cancel:@"确定" other:nil];
        [alertView show];
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

- (IBAction)addNewAddress:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAndEditAddressViewController *addAndEdit = [storyBoard instantiateViewControllerWithIdentifier:@"addAndEditAddressViewController"];
    addAndEdit.addressInfo = nil;
//    addAndEdit.userDic = self.userDic;
    [self presentViewController:addAndEdit animated:YES completion:nil];
}

- (IBAction)toViewController:(id)sender {
}

- (IBAction)toCartViewController:(id)sender {
}

- (IBAction)toUserIndexViewController:(id)sender {
}
@end
