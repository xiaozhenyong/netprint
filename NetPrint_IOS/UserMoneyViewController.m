//
//  UserMoneyViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/9.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "UserMoneyViewController.h"

@interface UserMoneyViewController ()
@end

@implementation UserMoneyViewController

@synthesize mUserInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSString *userId = [self.mUserInfo valueForKey:@"userid"];
    
    NSNumber *nprice = [self.mUserInfo valueForKey:@"money"];
    float _price = [nprice floatValue];
    NSString *price = [NSString stringWithFormat:@"%0.2f",_price];
    
    self.userNameLabel.text = userId;
    self.userMoneyLabel.text = price;
    
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

- (IBAction)backPage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)topUpButton:(id)sender {
    [self inputMoneyView];
}

- (void)inputMoneyView{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"充值金额" message:@"please input" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *moneyText = [alertView textFieldAtIndex:0];
    NSString *moneyRegex = @"^[0-9]+([.]{0}|[.]{1}[0-9]+)$";
    NSString *moneyNumber = moneyText.text;
    if (1 == buttonIndex && ![@"" isEqualToString:moneyNumber]) {
        NSPredicate *moneyTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",moneyRegex];
        BOOL bValue = [moneyTest evaluateWithObject:moneyNumber];
        if (bValue) {
            NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:[self.mUserInfo valueForKey:@"uid"],@"userId",moneyNumber,@"money", nil];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:PHONE_RECHARGE parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *responseDic = responseObject;
                NSString *billid = [responseDic valueForKey:@"billId"];
                NSString *partner = [responseDic valueForKey:@"partner"];
                NSString *seller = [responseDic valueForKey:@"seller"];
                NSString *privatekey = [responseDic valueForKey:@"privatekey"];
                float price = [moneyNumber floatValue];
                [self alipayWithOrderId:billid partner:partner seller:seller privatekey:privatekey price:price];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"服务不可用" cancel:@"确定" other:nil];
                [alertView show];
            }];
            
        }else{
            [self inputError];
        }
    }
}

- (void)inputError{
    UIAlertView *inputErrorView = [BaseView alertViewHasDelegateWithTitle:@"提示" message:@"请输入正确的值" cancel:@"确定" other:nil delegate:self];
    //[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的值" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    inputErrorView.alertViewStyle = UIAlertActionStyleDefault;
    [inputErrorView show];
    
}

- (void)alipayWithOrderId:(NSString *)orderId partner:(NSString *)partner seller:(NSString *)seller privatekey:(NSString *)privateKey price:(float )price{
    
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderId; //订单ID（由商家自行制定）
    order.productName = orderId; //商品标题
    order.productDescription = @"用户充值"; //商品描述
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
                [self showPayMsg:@"充值成功"];
            }else if ([@"4000" isEqualToString:resultStatus]){
                [self showPayMsg:@"充值失败，请与客服联系"];
            }else if([@"6002" isEqualToString:resultStatus]){
                [self showPayMsg:@"网络连接出错，请检查网络"];
            }
        }];
        
    }
}

- (void)showPayMsg:(NSString *)msg{
    UIAlertView *msgAlertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:msg cancel:@"确定" other:nil];
    //[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    msgAlertView.alertViewStyle = UIAlertActionStyleDefault;
    [msgAlertView show];

}
@end
