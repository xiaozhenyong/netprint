//
//  DistributionMsgViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/16.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "DistributionMsgViewController.h"

@interface DistributionMsgViewController (){
    NSArray *dlsPickerViewData;
    NSDictionary *all,*mdiDic;
    NSString *dlsId,*dlsCostPrice,*dlsDtName,*userName,*password,*allPrice,*delId,*uId,*code;
    NSMutableData *responseData;
    __block NSMutableDictionary *imgMsg;
    NSDictionary *uInfo;
    UIStoryboard *storyboard;

}

@end

@implementation DistributionMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPage];
    [self initPickerView];
    [self initPickerViewData];
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserMsgWithNotification:) name:@"UserLoginNoti" object:nil];
    
    [self.couponTextField addTarget:self action:@selector(clearCouponTextField) forControlEvents:UIControlEventTouchDown];
    
}

- (void) clearCouponTextField{
    self.couponTextField.text = @"";
}

- (void) getUserMsgWithNotification:(NSNotification *)notification{
    
    NSDictionary *dic = [notification userInfo];
    uInfo = dic;
    userName = [dic valueForKey:@"userName"];
    password = [dic valueForKey:@"password"];
    uId = [dic valueForKey:@"uId"];
    
}

- (void)initPickerView{
    self.dlsPickerView.delegate = self;
    self.dlsPickerView.dataSource = self;
    [self.dlsPickerView reloadAllComponents];
}

- (void)initPickerViewData{
    
    dlsPickerViewData = [all valueForKey:@"dls"];
    dlsDtName = [[dlsPickerViewData objectAtIndex:0] valueForKey:@"dt_name"];
    self.distributionMethodTextField.text = dlsDtName;
    
}

- (void)initPage{
    self.distributionMethodTextField.delegate = self;
    
    all = [self.mdi valueForKey:@"value"];
    mdiDic = [all valueForKey:@"mdi"];
    delId = [mdiDic valueForKey:@"id"];
    
    NSDictionary *dlsDic = [[all valueForKey:@"dls"] objectAtIndex:0];
    dlsId = [NSString stringWithFormat:@"%@",[dlsDic valueForKey:@"id"]];
    
    dlsCostPrice = [NSString stringWithFormat:@"%@",[[[all valueForKey:@"dls"]objectAtIndex:0] valueForKey:@"costprice"] ];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[mdiDic valueForKey:@"provinceName"],[mdiDic valueForKey:@"cityName"],[mdiDic valueForKey:@"countyName"],[mdiDic valueForKey:@"address"]];
    self.deliveryManLabel.text = [mdiDic valueForKey:@"deliveryMan"];
    self.phoneLabel.text = [mdiDic valueForKey:@"mobilePhone"];
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"%@",[all valueForKey:@"totalGoodsPrice"]];
    self.couponPriceLabel.text = [NSString stringWithFormat:@"%@",[all valueForKey:@"cheap"]];
    
    self.freightLabel.text = dlsCostPrice;
    
    
    NSString *gprice = [NSString stringWithFormat:@"%@",[all valueForKey:@"totalGoodsPrice"]];
    
    
    NSString *cheappice = [NSString stringWithFormat:@"%@",[all valueForKey:@"cheap"]];
    
    NSDecimalNumber *_gprice = [NSDecimalNumber decimalNumberWithString:gprice];
    NSDecimalNumber *_cheappice = [NSDecimalNumber decimalNumberWithString:cheappice];
    NSDecimalNumber *_costPrice = [NSDecimalNumber decimalNumberWithString:dlsCostPrice];
    
    allPrice = [[[_gprice decimalNumberByAdding:_cheappice]decimalNumberByAdding:_costPrice] stringValue];
    self.priceLabel.text = allPrice;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [dlsPickerViewData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *dlsDetail = [dlsPickerViewData objectAtIndex:row];
    
    return [dlsDetail valueForKey:@"dt_name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSDictionary *dlsDic = [dlsPickerViewData objectAtIndex:row];
    dlsId = [NSString stringWithFormat:@"%@",[dlsDic valueForKey:@"id"]];
    dlsCostPrice = [NSString stringWithFormat:@"%@",[dlsDic valueForKey:@"costprice"]];
    
    dlsDtName = [dlsDic valueForKey:@"dt_name"];
    self.freightLabel.text = dlsCostPrice;
    self.distributionMethodTextField.text = dlsDtName;
    
    
    NSString *frei = [NSString stringWithFormat:@"%@",[dlsDic valueForKey:@"costprice"]];
    NSString *gprice = [NSString stringWithFormat:@"%@",[all valueForKey:@"totalGoodsPrice"]];
    NSString *cheap = [NSString stringWithFormat:@"%@",[all valueForKey:@"cheap"]];
    
    
    NSDecimalNumber *_frei = [NSDecimalNumber decimalNumberWithString:frei];
    NSDecimalNumber *_gprice = [NSDecimalNumber decimalNumberWithString:gprice];
    NSDecimalNumber *_cheap = [NSDecimalNumber decimalNumberWithString:cheap];
    
    NSDecimalNumber *_allprice = [[_frei decimalNumberByAdding:_gprice]decimalNumberBySubtracting:_cheap];
    allPrice = [_allprice stringValue];
    self.priceLabel.text = allPrice;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:(UITextField *)self.distributionMethodTextField]) {
        self .dlsPickerView.hidden = NO;
    }
    return NO;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)addrManageButton:(id)sender {
    AddressManageViewController *addressManage = [storyboard instantiateViewControllerWithIdentifier:@"addressManageViewController"];
    addressManage.userDic = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"u",password,@"p", nil];
    addressManage.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:addressManage animated:YES completion:nil];
}

- (IBAction)useCouponButton:(id)sender {
    NSString *coupon = self.couponTextField.text;
    code = coupon;
    NSMutableArray *cartsArray = [[NSMutableArray alloc]init];
    
    if (coupon != nil && ![@"" isEqualToString:coupon]) {
        for (Cart *cart in self.cartArray) {
            NSMutableDictionary *cartDic = [[NSMutableDictionary alloc]init];
            
            NSArray *detail = [NSKeyedUnarchiver unarchiveObjectWithData:cart.detail];
            NSMutableArray *detailArray = [[NSMutableArray alloc]init];
            for (NSDictionary *assetDic in detail) {
                
                [detailArray addObject:[self jsonStringWithNSDictionary:assetDic]];
            }
            
            
            NSInteger num = [cart.num integerValue];
            float price = [cart.price floatValue];
            
            [cartDic setValue:detailArray forKey:@"detail"];
            [cartDic setValue:cart.cartId forKey:@"cartId"];
            [cartDic setValue:cart.goodsId forKey:@"goodsId"];
            [cartDic setValue:[NSNumber numberWithInteger:num] forKey:@"num"];
            [cartDic setValue:[NSNumber numberWithFloat:price] forKey:@"price"];
            [cartDic setValue:cart.goodsName forKey:@"goodsName"];
            
            [cartsArray addObject:[self jsonStringWithNSDictionary:cartDic]];
        }
        NSData *cartsData = [NSJSONSerialization dataWithJSONObject:cartsArray options:kNilOptions error:nil];
        NSString *cartsString = [[NSString alloc]initWithData:cartsData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *requestDic = [[NSMutableDictionary alloc]init];
        [requestDic setValue:userName forKey:@"user"];
        [requestDic setValue:password forKey:@"pwd"];
        [requestDic setValue:cartsString forKey:@"carts"];
        [requestDic setValue:coupon forKey:@"code"];
        [requestDic setValue:dlsId forKey:@"deliveryId"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:PHONE_ORDER_SETTLE parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"response------>%@",responseObject);
            
            NSDictionary *resDic = responseObject;
            NSString *cheapValue = [NSString stringWithFormat:@"%@",[resDic valueForKey:@"cheap"]];
            
            NSDecimalNumber *_cheap = [NSDecimalNumber decimalNumberWithString:cheapValue];
            
            self.couponPriceLabel.text = cheapValue;
            
            NSDecimalNumber *_totalPrice = [NSDecimalNumber decimalNumberWithString:allPrice];
            NSDecimalNumber *newTotal = [_totalPrice decimalNumberBySubtracting:_cheap];
            self.priceLabel.text = [newTotal stringValue];
            allPrice = [newTotal stringValue];
            
            NSLog(@"allprice------->%@",allPrice);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{
        
    }
}

- (NSString *)jsonStringWithNSDictionary:(NSDictionary *)dic{
    NSData *assetData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:assetData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (IBAction)submitOrderButton:(id)sender {
//    [self uploadImage];
    [self uploadImageNew];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil userInfo:uInfo];
    }];

}

- (IBAction)toViewController:(id)sender {
    ViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    [self presentViewController:viewCon animated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil userInfo:uInfo];
    }];
}

- (IBAction)toCartViewController:(id)sender {
    CartViewController *cartViewCon = [storyboard instantiateViewControllerWithIdentifier:@"cartViewController"];
    [self presentViewController:cartViewCon animated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil userInfo:uInfo];
    }];
}

- (IBAction)toUserIndexViewController:(id)sender {
    UserIndexViewController *userIndexViewCon = [storyboard instantiateViewControllerWithIdentifier:@"userIndexViewController"];
    [self presentViewController:userIndexViewCon animated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil userInfo:uInfo];
    }];
}

- (void) uploadImageNew{

    __block NSInteger i=0;
    NSInteger count = [self countNum];
    imgMsg = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    [dataDic setValue:userName forKey:@"userName"];
    [dataDic setValue:password forKey:@"pwd"];
    [dataDic setValue:@"" forKey:@"type"];
    
    
    for (Cart *cart in self.cartArray) {
        NSArray *arrayImage = [NSKeyedUnarchiver unarchiveObjectWithData:cart.detail];
        
        for (NSDictionary *dicAsset in arrayImage) {
            
            NSLog(@"set------>%@",[dicAsset valueForKey:@"set"]);
            
            [dataDic setValue:[dicAsset valueForKey:@"set"] forKey:@"set"];
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
            
            NSURL *assetUrl = [NSURL URLWithString:[dicAsset valueForKey:@"path"]];
            
            [library assetForURL:assetUrl resultBlock:^(ALAsset *asset){
                
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                
                Byte *buffer = (Byte *)malloc([rep size]);
                NSUInteger buffered = [rep getBytes:buffer fromOffset:0 length:[rep size] error:nil];
                NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                
                /*
                 NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:PHONE_UPLOAD_PHOTO parameters:dataDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                 [formData appendPartWithFileData:data name:@"file" fileName:[rep filename] mimeType:@"image/jpeg/png"];
                 } error:nil];
                 
                 AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                 NSProgress *progess = nil;
                 NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progess completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                 if (error) {
                 NSLog(@"uploadError: %@",error);
                 }else{
                 NSLog(@"success: %@-- %@",response,responseObject);
                 
                 NSDictionary *dicId = responseObject;
                 NSInteger imgId = (NSInteger)[dicId valueForKey:@"id"];
                 [imgMsg setValue:[NSNumber numberWithInteger:imgId] forKey:[NSString stringWithFormat:@"%@",[assetUrl absoluteString]]];
                 }
                 }];
                 [uploadTask resume];
                 */
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                [manager POST:PHONE_UPLOAD_PHOTO parameters:dataDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    [formData appendPartWithFileData:data name:@"file" fileName:[rep filename] mimeType:@"image/jpeg/png"];
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *dicId = responseObject;
                    
                    NSInteger imgId = [[NSString stringWithFormat:@"%@",[dicId valueForKey:@"id"]] integerValue];
                    
                    [imgMsg setValue:[NSNumber numberWithInteger:imgId] forKey:[NSString stringWithFormat:@"%@",[assetUrl absoluteString]]];
                    i++;
                    if (i == count) {
                        [self orderSubmit];
                    }
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"uploadError: %@",error);
                }];
                
            } failureBlock:nil];
            
        }
    }
}

- (NSInteger) countNum{
    NSInteger i = 0;
    
    for (Cart *cart in self.cartArray) {
        NSArray *arrayImage = [NSKeyedUnarchiver unarchiveObjectWithData:cart.detail];
        
        i = i+[arrayImage count];
    };
    return i;
}


- (void) orderSubmit{
    NSMutableDictionary *cartDic = [[NSMutableDictionary alloc]init];
    
    for (Cart *cart in self.cartArray) {
        NSMutableArray *selArray = [[NSMutableArray alloc]init];
        
        NSArray *arrayImage = [NSKeyedUnarchiver unarchiveObjectWithData:cart.detail];
        for (NSDictionary *dic in arrayImage) {
            NSInteger _num = [[dic valueForKey:@"num"] integerValue];
            NSDictionary *selDic = [NSDictionary dictionaryWithObjectsAndKeys:[imgMsg valueForKey:[dic valueForKey:@"path"]],@"imgId",[NSNumber numberWithInteger:_num],@"num", nil];
            [selArray addObject:selDic];
        }
        NSDictionary *secDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0],@"state",[NSNumber numberWithInteger:[arrayImage count]],@"total",selArray,@"sel", nil];
        [cartDic setValue:secDic forKey:cart.goodsId];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cartDic options:0 error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *orderManager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc]init];
    [dicPost setValue:userName forKey:@"userName"];
    [dicPost setValue:password forKey:@"pwd"];
    [dicPost setValue:jsonString forKey:@"detail"];
    [dicPost setValue:code forKey:@"code"];
    [dicPost setValue:dlsId forKey:@"deliveryId"];
    [dicPost setValue:delId forKey:@"addressId"];
    [orderManager POST:PHONE_ORDER_SUBMIT parameters:dicPost success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseValue = responseObject;
        if ([@"ok" isEqualToString:[responseValue valueForKey:@"res"]]) {
            NSString *orderId = [responseValue valueForKey:@"orderId"];
            
            NSString *goodsPrice = self.goodsPriceLabel.text;
            NSString *freight = self.freightLabel.text;
            NSString *cheap = self.couponPriceLabel.text;
            NSString *totalprice = self.priceLabel.text;
  
            PayOrderViewController *payOrder = [storyboard instantiateViewControllerWithIdentifier:@"payOrderViewController"];
            payOrder.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            payOrder.cartArray = self.cartArray;
            
            [self presentViewController:payOrder animated:YES completion:^{
                NSDictionary *payOrderDic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"userName",password,@"password",uId,@"uId",orderId,@"orderId",goodsPrice,@"goodsPrice",freight,@"freight",cheap,@"cheap",totalprice,@"totale", nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"payOrderNoti" object:nil userInfo:payOrderDic];
                
            }];
            
        }else{
            NSLog(@"---sumbit order  fail---");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"OrderSubmitError: %@",error);
    }];

}

@end
