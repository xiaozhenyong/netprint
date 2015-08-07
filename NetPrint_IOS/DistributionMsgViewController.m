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
    NSString *dlsId,*dlsCostPrice,*dlsDtName,*userName,*password,*allPrice,*delId,*uId;
    NSMutableData *responseData;
    __block NSMutableDictionary *imgMsg;

}

@end

@implementation DistributionMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPage];
    [self initPickerView];
    [self initPickerViewData];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserMsgWithNotification:) name:@"UserLoginNoti" object:nil];
    
}

- (void) getUserMsgWithNotification:(NSNotification *)notification{
    
    NSDictionary *dic = [notification userInfo];
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
    self.distributionMethodLabel.text = dlsDtName;
    
}

- (void)initPage{
    self.distributionMethodLabel.delegate = self;
    
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
    
    NSLog(@"------costprice----->%@",dlsCostPrice);
    
    dlsDtName = [dlsDic valueForKey:@"dt_name"];
    self.freightLabel.text = dlsCostPrice;
    self.distributionMethodLabel.text = dlsDtName;
    
    
    NSString *frei = [NSString stringWithFormat:@"%@",[dlsDic valueForKey:@"costprice"]];
    NSString *gprice = [NSString stringWithFormat:@"%@",[all valueForKey:@"totalGoodsPirce"]];
    NSString *cheap = [NSString stringWithFormat:@"%@",[all valueForKey:@"cheap"]];
    
    
    NSDecimalNumber *_frei = [NSDecimalNumber decimalNumberWithString:frei];
    NSDecimalNumber *_gprice = [NSDecimalNumber decimalNumberWithString:gprice];
    NSDecimalNumber *_cheap = [NSDecimalNumber decimalNumberWithString:cheap];
    
    NSDecimalNumber *_allprice = [[_frei decimalNumberByAdding:_gprice]decimalNumberByAdding:_cheap];
    allPrice = [_allprice stringValue];
    self.priceLabel.text = allPrice;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:(UITextField *)self.distributionMethodLabel]) {
        NSLog(@"touch -----------");
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressManageViewController *addressManage = [storyboard instantiateViewControllerWithIdentifier:@"addressManageViewController"];
    addressManage.userDic = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"u",password,@"p", nil];
    addressManage.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:addressManage animated:YES completion:nil];
}

- (IBAction)useCouponButton:(id)sender {
}

- (IBAction)submitOrderButton:(id)sender {
    [self uploadImage];
  
    /*
    dispatch_queue_t disUploadImage = dispatch_queue_create("dis.upload.image", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(disUploadImage, ^{
     [self uploadImage];
       
    });
    
    dispatch_barrier_async(disUploadImage, ^{
        NSLog(@"----3----");
    });
    */
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)uploadImage{
    
    imgMsg = [[NSMutableDictionary alloc]init];
    dispatch_group_t group = dispatch_group_create();
    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    NSURL *url = [NSURL URLWithString:PHONE_UPLOAD_PHOTO];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //分界线 --AaB03x
    NSString *MPboundary = [[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary = [[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http body的字符串
    NSMutableString *body = [[NSMutableString alloc]init];
    
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    
    //添加字段名称，换2行
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"userName"];
    //添加字段的值
    [body appendFormat:@"%@\r\n",userName];
    
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //添加字段名称，换2行
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"pwd"];
    //添加字段的值
    [body appendFormat:@"%@\r\n",password];
    
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //添加字段名称，换2行
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"type"];
    //添加字段的值
    [body appendFormat:@"%@\r\n",@""];
    
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //添加字段名称，换2行
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"set"];
    //添加字段的值
    [body appendFormat:@"%@\r\n",@""];
    
        for (Cart *cart in self.cartArray) {
            NSArray *arrayImage = [NSKeyedUnarchiver unarchiveObjectWithData:cart.detail];
            
            
            for (NSDictionary *dicAsset in arrayImage) {
                NSMutableData *requestData = [[NSMutableData alloc]init];
                
                NSMutableString *imageBody = [[NSMutableString alloc]init];
                [imageBody appendFormat:@"%@\r\n",MPboundary];
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
                
                NSURL *assetUrl = [NSURL URLWithString:[dicAsset valueForKey:@"path"]];
                
 //                 dispatch_queue_t disUploadImage = dispatch_queue_create("dis.upload.image", DISPATCH_QUEUE_CONCURRENT);
                dispatch_group_enter(group);
                [library assetForURL:assetUrl resultBlock:^(ALAsset *asset){
                    
                    ALAssetRepresentation *rep = [asset defaultRepresentation];
                    
                    [requestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    [imageBody appendFormat:@"Content-Disposition: form-data; name=\"file\";filename=\"%@\"\r\n\r\n",[rep filename]];
                    
                    
                    Byte *buffer = (Byte *)malloc([rep size]);
                    NSUInteger buffered = [rep getBytes:buffer fromOffset:0 length:[rep size] error:nil];
                    NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                    
                    [requestData appendData:[imageBody dataUsingEncoding:NSUTF8StringEncoding]];
                    [requestData appendData:data];
                    [requestData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    NSString *end = [[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
                    [requestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    NSString *content = [[NSString alloc]initWithFormat:@"multipart/form-data;boundary=%@",TWITTERFON_FORM_BOUNDARY];
                    
                    [request setValue:content forHTTPHeaderField:@"Content-Type"];
                    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
                    [request setHTTPBody:requestData];
                    [request setHTTPMethod:@"POST"];
                    
                    /*
                     NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
                     [conn start];
                     
                     */
                    NSError *error;
                    NSData *resData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
                    
                    id jsonValue = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableContainers error:nil];

                    [imgMsg setValue:[NSString stringWithFormat:@"%@",[jsonValue valueForKey:@"id"]] forKey:[NSString stringWithFormat:@"%@",[assetUrl absoluteString]]];

                    dispatch_group_leave(group);
                } failureBlock:nil];
                
            }
        }
    dispatch_queue_t disForOrder = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_notify(group,disForOrder, ^{
        NSLog(@"---------->%ld",[imgMsg count]);
        
        NSMutableDictionary *cartDic = [[NSMutableDictionary alloc]init];
        
        for (Cart *cart in self.cartArray) {
            NSMutableArray *selArray = [[NSMutableArray alloc]init];

            NSArray *arrayImage = [NSKeyedUnarchiver unarchiveObjectWithData:cart.detail];
            for (NSDictionary *dic in arrayImage) {
                NSDictionary *selDic = [NSDictionary dictionaryWithObjectsAndKeys:[imgMsg valueForKey:[dic valueForKey:@"path"]],@"imgId",[dic valueForKey:@"num"],@"num", nil];
                [selArray addObject:selDic];
            }
            NSDictionary *secDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"state",[NSString stringWithFormat:@"%ld",[arrayImage count]],@"total",selArray,@"sel", nil];
            [cartDic setValue:secDic forKey:cart.goodsId];
        }
        
        NSLog(@"---cartDic---->%ld",[cartDic count]);
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cartDic options:0 error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"jsonstring------->%@",jsonString);

        NSString *baseUrl = [[NSString alloc]initWithFormat:PHONE_ORDER_SUBMIT];
        NSURL *url = [NSURL URLWithString:baseUrl];
        NSString *post = [NSString stringWithFormat:@"userName=%@&pwd=%@&detail=%@&code=%@&deliveryId=%@&addressId=%@",userName,password,jsonString,@"",dlsId,delId];
        NSData *postData =[post dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                id jsonValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([@"ok" isEqualToString:[jsonValue valueForKey:@"res"]]) {
                    NSString *orderId = [jsonValue valueForKey:@"orderId"];
                    
                    NSString *goodsPrice = self.goodsPriceLabel.text;
                    NSString *freight = self.freightLabel.text;
                    NSString *cheap = self.couponPriceLabel.text;
                    NSString *totalprice = self.priceLabel.text;
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
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
            }else{
                NSLog(@"----connection fail----");
            }
            
            
        }];
    });
}

@end
