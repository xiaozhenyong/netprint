//
//  PayOrderViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/24.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "PayOrderViewController.h"

@interface PayOrderViewController (){
    NSString *userName,*password,*orderId,*uId,*payPwd;
    NSDictionary *userInfo;
    UIStoryboard *storyboard;
}
@end

@implementation PayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initPage:) name:@"payOrderNoti" object:nil];
    [self initTableView];
}

- (void)initPage:(NSNotification *)notification{
    NSDictionary *dic = [notification userInfo];
    
    userName = [dic valueForKey:@"userName"];
    password = [dic valueForKey:@"password"];
    uId = [dic valueForKey:@"uId"];
    orderId = [dic valueForKey:@"orderId"];
    self.goodsPiceLabel.text = [dic valueForKey:@"goodsPrice"];
    self.feiLabel.text = [dic valueForKey:@"freight"];
    self.cheapLabel.text = [dic valueForKey:@"cheap"];
    
    NSLog(@"cheap------>%@",[dic valueForKey:@"cheap"]);
    
    self.totalPriceLabel.text = [dic valueForKey:@"totale"];
    
    
    userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"userName",password,@"password",uId,@"uId", nil];
}

- (void)initTableView{
    self.cartShowTableView.delegate = self;
    self.cartShowTableView.dataSource = self;
    [self.cartShowTableView registerClass:[PayOrderShowTableViewCell class] forCellReuseIdentifier:@"payOrderCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cartArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *payOrderCellName = @"payOrderCell";
    
    static BOOL nibPayOrder = NO;
    if (!nibPayOrder) {
        NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
        UINib *nib = [UINib nibWithNibName:@"PayOrderShowTableViewCell" bundle:classBundle];
        [tableView registerNib:nib forCellReuseIdentifier:payOrderCellName];
    }
    
    PayOrderShowTableViewCell *payOrderCell = [tableView dequeueReusableCellWithIdentifier:payOrderCellName forIndexPath:indexPath];
    
    Cart *cart = [self.cartArray objectAtIndex:[indexPath row]];
    payOrderCell.goodsNameLabel.text = cart.goodsName;
    payOrderCell.goodsNumLabel.text = cart.num;
    payOrderCell.priceLabel.text = cart.price;
    
    return payOrderCell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)alipayButton:(id)sender {
}

- (IBAction)balancePayButton:(id)sender {
    
    [self inputPayPassword];
    
}

- (IBAction)toViewController:(id)sender {
    ViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    [self gotoUIViewController:viewCon];
}

- (IBAction)toCartViewController:(id)sender {
    CartViewController *cartViewCon = [storyboard instantiateViewControllerWithIdentifier:@"cartViewController"];
    [self gotoUIViewController:cartViewCon];
}

- (IBAction)toUserIndexViewController:(id)sender {
    UserIndexViewController *userIndexViewCon = [storyboard instantiateViewControllerWithIdentifier:@"userIndexViewController"];
    [self gotoUIViewController:userIndexViewCon];
}

- (void)gotoUIViewController:(UIViewController *)viewCon{
    [self presentViewController:viewCon animated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil userInfo:userInfo];
    }];
}

- (void)inputPayPassword{
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"支付密码" message:@"please input" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    //UITextField *pwdText = [alert textFieldAtIndex:0];
    //payPwd = pwdText.text;
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *pwdText = [alertView textFieldAtIndex:0];
    NSString *_paypwd = pwdText.text;
    payPwd = _paypwd;
    
    if (1 == buttonIndex && ![@"" isEqualToString:_paypwd]) {
        NSString *baseUrl = [[NSString alloc]initWithFormat:PAY_USED_REMAINING];
        NSURL *url = [NSURL URLWithString:baseUrl];
        NSString *post = [NSString stringWithFormat:@"userId=%@&orderID=%@&payPwd=%@",uId,orderId,payPwd];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if (data) {
            id jsonValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *result = [jsonValue valueForKey:@"r"];
            if ([@"errUser" isEqualToString:result]) {
                NSLog(@"-------errUser-------");
            }else if ([@"noPwd" isEqualToString:result]){
                NSLog(@"--------noPwd--------");
            }else if ([@"errPwd" isEqualToString:result]){
                NSLog(@"--------errPwd-------");
            }else if ([@"errOrder" isEqualToString:result]){
                NSLog(@"-----------errOrder---");
            }else if ([@"errpayOrder" isEqualToString:result]){
                NSLog(@"--------errpayorder-----");
            }else{
                
                PayFinishViewController *payFinish = [storyboard instantiateViewControllerWithIdentifier:@"payFinishViewController"];
                payFinish.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    
                    
                    
                [self presentViewController:payFinish animated:YES completion:^{
                    NSDictionary *payFinishDic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"userName",password,@"password",uId,@"uId", nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"payFinishNoti" object:nil userInfo:payFinishDic];
                }];
            }
        }else{
            NSLog(@"-----connection fail-----");
        }
    }
}
@end
