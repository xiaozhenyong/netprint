//
//  AddAndEditAddressViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/13.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "AddAndEditAddressViewController.h"

@interface AddAndEditAddressViewController (){
    NSArray *provinces,*cities,*areas;
    NSString *userName,*password;
}

@end

@implementation AddAndEditAddressViewController

@synthesize addr = _addr;
@synthesize areaValue = _areaValue;
@synthesize addressInfo = _addressInfo;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    userName = [self.userDic objectForKey:@"u"];
    password = [self.userDic objectForKey:@"p"];

    [self initTextAll];
    [self initPickerViewDelegate];
    [self initPickerViewData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (Address *)addr{
    if (_addr == nil) {
        _addr = [[Address alloc]init];
    }
    return _addr;
}

- (void)initTextAll{

    self.addressTextField.delegate = self;
    self.addrDetailTextView.delegate = self;
    
    if (self.addressInfo) {
        NSString *province = [[self.addressInfo objectAtIndex:0]valueForKey:@"provinceName"];
        NSString *city = [[self.addressInfo objectAtIndex:0]valueForKey:@"cityName"];
        NSString *county = [[self.addressInfo objectAtIndex:0]valueForKey:@"countyName"];
        self.addressTextField.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,county];
        
        self.addrDetailTextView.text = [[self.addressInfo objectAtIndex:0]valueForKey:@"address"];
        
        
        NSString *addressId = [[self.addressInfo objectAtIndex:0]valueForKey:@"id"];
        NSInteger saveButTag = [addressId integerValue];
        self.deliverManTextField.tag = saveButTag;
        self.deliverManTextField.text = [[self.addressInfo objectAtIndex:0]valueForKey:@"deliveryMan"];
        
        self.phoneTextField.text = [[self.addressInfo objectAtIndex:0]valueForKey:@"mobilePhone"];
        
        self.telTextField.text = [[self.addressInfo objectAtIndex:0]valueForKey:@"tel"];
    }
   
    [self.deliverManTextField addTarget:self action:@selector(textFieldEvent:) forControlEvents:UIControlEventTouchDown];
    

    [self.phoneTextField addTarget:self action:@selector(textFieldEvent:) forControlEvents:UIControlEventTouchDown];
    

    [self.telTextField addTarget:self action:@selector(textFieldEvent:) forControlEvents:UIControlEventTouchDown];
}

- (void)textFieldEvent:(id)sender{
    if (!self.selectAreaPickerView.hidden) {
        self.selectAreaPickerView.hidden = YES;
    }
    UITextField  *_this = (UITextField *)sender;
    _this.text = @"";
}

- (void)initPickerViewDelegate{
    self.selectAreaPickerView.delegate = self;
    self.selectAreaPickerView.dataSource = self;
    [self.selectAreaPickerView reloadAllComponents];
}

- (void)initPickerViewData{
    provinces = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    
    
    cities = [[provinces objectAtIndex:0]objectForKey:@"cities"];
    
    self.addr.state = [[provinces objectAtIndex:0] objectForKey:@"state"];
    self.addr.city = [[cities objectAtIndex:0]objectForKey:@"city"];
    
    areas = [[cities objectAtIndex:0]objectForKey:@"areas"];
    
    if ([areas count] > 0) {
        self.addr.district = [areas objectAtIndex:0];
    }else{
        self.addr.district = @"";
    }
}

//列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
//行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        case 2:
            return [areas count];
            break;
        default:
            return 0;
            break;
    }
}
/*
//行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 20.0;
}
//行宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.view.frame.size.width;
}
*/
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [[[[provinces objectAtIndex:row]objectForKey:@"state"] componentsSeparatedByString:@"-"]objectAtIndex:0];
            break;
        case 1:
            return [[cities objectAtIndex:row]objectForKey:@"city"];
            break;
        case 2:
            if ([areas count] > 0) {
                return [areas objectAtIndex:row];
                break;
            }
        default:
            return @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            cities = [[provinces objectAtIndex:row]objectForKey:@"cities"];
            [self.selectAreaPickerView selectRow:0 inComponent:1 animated:YES];
            [self.selectAreaPickerView reloadComponent:1];
            
            areas = [[cities objectAtIndex:0]objectForKey:@"areas"];
            [self.selectAreaPickerView selectRow:0 inComponent:2 animated:YES];
            [self.selectAreaPickerView reloadComponent:2];
            
            self.addr.state = [[provinces objectAtIndex:row]objectForKey:@"state"];
            self.addr.city = [[cities objectAtIndex:0]objectForKey:@"city"];
            if ([areas count] > 0) {
                self.addr.district = [areas objectAtIndex:0];
            }else{
                self.addr.district = @"";
            }
            break;
        case 1:
            areas = [[cities objectAtIndex:row]objectForKey:@"areas"];
            [self.selectAreaPickerView selectRow:0 inComponent:2 animated:YES];
            [self.selectAreaPickerView reloadComponent:2];
            
            self.addr.city = [[cities objectAtIndex:row]objectForKey:@"city"];
            if ([areas count] > 0) {
                self.addr.district = [areas objectAtIndex:0];
            }else{
                self.addr.district = @"";
            }
            break;
        case 2:
            if ([areas count] > 0) {
                self.addr.district = [areas objectAtIndex:row];
            }else{
                self.addr.district = @"";
            }
        default:
            break;
    }
    
    NSString *_addressAll = [NSString stringWithFormat:@"%@ %@ %@",[[self.addr.state componentsSeparatedByString:@"-"] objectAtIndex:0],self.addr.city,self.addr.district];
    self.addressTextField.text=_addressAll;
  
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:(UITextField *)self.addressTextField]) {
        self.selectAreaPickerView.hidden = NO;
    }
    return NO;
}

- (void) textViewDidBeginEditing:(UITextView *)textView{
    if ([textView isEqual:self.addrDetailTextView]) {
        textView.text = @"";
    }
    if (!self.selectAreaPickerView.hidden) {
        self.selectAreaPickerView.hidden = YES;
    }
}
/*
#pragma mark - Navigations

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAddressButton:(id)sender {
    NSInteger saveAddId = self.deliverManTextField.tag;
    NSString *saveDelMan = self.deliverManTextField.text;
    
    NSArray *proArray = [_addr.state componentsSeparatedByString:@"-"];
    NSString *saveProvinceName = [proArray objectAtIndex:0];
    
    NSString *saveProvinceId =[proArray objectAtIndex:1];
    
    NSString *saveAddDetail = self.addrDetailTextView.text;
    NSString *savePhone = self.phoneTextField.text;
    NSString *saveTel = self.telTextField.text;
    
    NSMutableDictionary *dicdata = [NSMutableDictionary dictionaryWithObjectsAndKeys:saveAddDetail,@"address",_addr.city,@"cityName",_addr.district,@"countyName",saveDelMan,@"deliveryMan",[NSString stringWithFormat:@"%ld",saveAddId],@"id",savePhone,@"mobilePhone",saveProvinceName,@"provinceName",saveProvinceId,@"provinceID",saveTel,@"tel",@"1",@"isUsed",nil];

   
    
    NSError *jsonerror = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicdata options:0 error:&jsonerror];
    NSString *addrString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSError *requesterror = nil;
    NSString *baseUrl = [[NSString alloc]initWithFormat:PHONE_ADDR_UPDATE];
    NSURL *url = [NSURL URLWithString:[baseUrl URLEncodedString]];
    NSString *post = nil;

    post = [NSString stringWithFormat:@"userName=%@&pwd=%@&type=%@&addr=%@",userName,password,@"ios-add",addrString];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&requesterror];
    if (data) {
        id jsonValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *_addId = [NSString stringWithFormat:@"%@",[jsonValue objectForKey:@"addrId"]];
        [dicdata removeObjectForKey:@"id"];
        [dicdata setValue:_addId forKey:@"id"];
        if (!jsonValue) {
            NSLog(@"-----address edit fail----");
        }
    }else{
        NSLog(@"------address fail----");
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"editAddressInfo" object:nil userInfo:dicdata];
    }];
    
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
