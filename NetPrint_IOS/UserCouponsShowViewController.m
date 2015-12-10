//
//  UserCouponsShowViewController.m
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/11/30.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "UserCouponsShowViewController.h"
#import "UserCouponsTableViewCell.h"


@interface UserCouponsShowViewController ()

@end


@implementation UserCouponsShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    
    self.couponsCountLabel.text = [NSString stringWithFormat:@"共%ld张优惠券",[self.userCouponsArray count]];
}

- (void)initTableView{
    self.couponsTableView.delegate = self;
    self.couponsTableView.dataSource = self;
    [self.couponsTableView registerClass:[UserCouponsTableViewCell class] forCellReuseIdentifier:@"userCouponsTableViewCell"];
    self.couponsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.userCouponsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *couponsDic = [self.userCouponsArray objectAtIndex:[indexPath row]];
    static NSString *cellName = @"userCouponsTableViewCell";
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
        UINib *nib = [UINib nibWithNibName:@"UserCouponsTableViewCell" bundle:classBundle];
        [tableView registerNib:nib forCellReuseIdentifier:cellName];
    }
    
    UserCouponsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
    cell.cpnsNameLabel.text = [couponsDic objectForKey:@"cpnsname"];
    cell.cpnsPrefixLabel.text = [couponsDic objectForKey:@"cpnsprefix"];
    cell.pmtDescriptionLabel.text = [couponsDic objectForKey:@"pmtdescription"];
    cell.timeLabel.text = [NSString stringWithFormat:@"有效期:%@至%@",[couponsDic objectForKey:@"pmttimebegin"],[couponsDic objectForKey:@"pmttimeend"]];
    cell.layer.borderWidth = 0.5;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton *muchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [muchButton setTitle:@"更多。。。" forState:UIControlStateNormal];
    [muchButton addTarget:self action:@selector(getOtherCoupons) forControlEvents:UIControlEventTouchDown];
    if ([self.userCouponsArray count] > 4) {
        return muchButton;
    }else{
        return nil;
    }
}

- (void)getOtherCoupons{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
