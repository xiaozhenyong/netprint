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
    NSDictionary *userInfo,*orderDetailDic;
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
    
    self.goodsPiceLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"goodsPrice"]];
    self.feiLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"freight"]];
    self.cheapLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"cheap"]];
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"totale"]];
    
    
    userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"userName",password,@"password",uId,@"uId", nil];
    orderDetailDic = [dic valueForKey:@"orderDetail"];
}

- (void)initTableView{
    self.cartShowTableView.delegate = self;
    self.cartShowTableView.dataSource = self;
    [self.cartShowTableView registerClass:[PayOrderShowTableViewCell class] forCellReuseIdentifier:@"payOrderCell"];
    self.cartShowTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.cartArray) {
        return [self.cartArray count];
    }else if (self.goodsInfoArray){
        return [self.goodsInfoArray count];
    }else{
        return 0;
    }
    
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
    if (self.cartArray) {
        Cart *cart = [self.cartArray objectAtIndex:[indexPath row]];
        payOrderCell.goodsNameLabel.text = cart.goodsName;
        payOrderCell.goodsNumLabel.text = cart.num;
        payOrderCell.priceLabel.text = cart.price;
    }else if (self.goodsInfoArray){
        NSDictionary *dic = [self.goodsInfoArray objectAtIndex:[indexPath row]];
        payOrderCell.goodsNameLabel.text = [dic valueForKey:@"gname"];
        payOrderCell.goodsNumLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"total"]];
        payOrderCell.priceLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"totalprice"]];
    }else{
        payOrderCell.goodsNameLabel.text = @"-";
        payOrderCell.goodsNumLabel.text = @"-";
        payOrderCell.priceLabel.text = @"-";
    }
    
    
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
    NSString *billid = [orderDetailDic valueForKey:@"billid"];
    NSString *price = [orderDetailDic valueForKey:@"realPrice"];
    NSString *partner = [orderDetailDic valueForKey:@"partner"];
    NSString *seller = [orderDetailDic valueForKey:@"seller"];
    NSString *privatekey = [orderDetailDic valueForKey:@"privatekey"];
    
    [self alipayWithBillId:billid partner:partner  seller:seller privatekey:privatekey price:[price floatValue]];
}

- (IBAction)balancePayButton:(id)sender {
    [self inputPayPassword];
    
}

- (IBAction)backPage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    [self presentViewController:viewCon animated:YES completion:nil];
    
    /*
    [self presentViewController:viewCon animated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil userInfo:userInfo];
    }];
     */
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
                //NSLog(@"-------errUser-------");
                [self showPayMsg:@"用户错误"];
            }else if ([@"noPwd" isEqualToString:result]){
                //NSLog(@"--------noPwd--------");
                [self showPayMsg:@"缺少支付密码"];
            }else if ([@"errPwd" isEqualToString:result]){
                //NSLog(@"--------errPwd-------");
                [self showPayMsg:@"支付密码错误"];
            }else if ([@"errOrder" isEqualToString:result]){
                //NSLog(@"-----------errOrder---");
                [self showPayMsg:@"订单错误"];
            }else if ([@"errpayOrder" isEqualToString:result]){
               // NSLog(@"--------errpayorder-----");
                [self showPayMsg:@"订单支付错误"];
            }else{
                
                PayFinishViewController *payFinish = [storyboard instantiateViewControllerWithIdentifier:@"payFinishViewController"];
                payFinish.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    
                [self presentViewController:payFinish animated:YES completion:nil];
                 /*
                [self presentViewController:payFinish animated:YES completion:^{
                    NSDictionary *payFinishDic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"userName",password,@"password",uId,@"uId", nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"payFinishNoti" object:nil userInfo:payFinishDic];
                }];
                  */
            }
        }else{
            //NSLog(@"-----connection fail-----");
            [self showPayMsg:@"服务不可用"];
        }
    }
}


- (void)alipayWithBillId:(NSString *)billId partner:(NSString *)partner seller:(NSString *)seller privatekey:(NSString *)privateKey price:(float )price{
    
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = billId; //订单ID（由商家自行制定）
    order.productName = billId; //商品标题
    order.productDescription = @"照片冲印"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",price]; //商品价格
    order.notifyURL =  @"http://www.36588.com.cn/phone/phone_alipay_back.html"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString *resultStatus = [resultDic valueForKey:@"resultStatus"];
            if ([@"9000" isEqualToString:resultStatus]) {
                [self showPayMsg:@"支付成功"];
            }else if ([@"4000" isEqualToString:resultStatus]){
                [self showPayMsg:@"支付失败，请与客服联系"];
            }else if([@"6002" isEqualToString:resultStatus]){
                [self showPayMsg:@"网络连接出错，请检查网络"];
            }
        }];
        
    }
}

- (void)showPayMsg:(NSString *)msg{
    UIAlertView *msgAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    msgAlertView.alertViewStyle = UIAlertActionStyleDefault;
    [msgAlertView show];
    
}

@end
