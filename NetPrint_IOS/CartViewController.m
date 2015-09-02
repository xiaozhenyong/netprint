//
//  CartViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/4.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "CartViewController.h"


@interface CartViewController (){
    NSString *userName,*password,*uId;
    NSDictionary *userInfo;
    UIStoryboard *storyboard;
}

@end

@implementation CartViewController

@synthesize appDelegate = _appDelegate;
@synthesize  cartArray = _cartArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [self initCart];
    [self initTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserMsgWithNotification:) name:@"UserLoginCompletionNotification" object:nil];
}

- (void) getUserMsgWithNotification:(NSNotification *)notification{
    
    NSDictionary *dic = [notification userInfo];
    userInfo = dic;
    userName = [dic valueForKey:@"userName"];
    password = [dic valueForKey:@"password"];
    uId = [dic valueForKey:@"uId"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)initTableView{
    self.cartShow.dataSource = self;
    self.cartShow.delegate = self;
    [self.cartShow registerClass:[CartTableViewCell class] forCellReuseIdentifier:@"cartTableViewCell"];
}
- (void)initCart{
    
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *carts = [NSEntityDescription entityForName:@"Cart" inManagedObjectContext:_appDelegate.managedObjectContext];
    [request setEntity:carts];
    
    _cartArray  = [[_appDelegate.managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    float price = 0.0;
    if (_cartArray) {
        for (Cart *cart in _cartArray) {
            price += [cart.price floatValue];
        }
    }
    NSString *totalPrice = [NSString stringWithFormat:@"￥:%.2f",price];
    self.totalPriceLabel.text = totalPrice;
}

- (Goods *)queryGoodsWithId:(NSString *)gId{
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *goods = [NSEntityDescription entityForName:@"Goods" inManagedObjectContext:_appDelegate.managedObjectContext];
    [request setEntity:goods];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gid=%@",gId];
    
    [request setPredicate:predicate];
    
    NSMutableArray *goodsArray  = [[_appDelegate.managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    if (goodsArray) {
        return (Goods *)[goodsArray objectAtIndex:0];
    }else{
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return [self.cartArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *customCell = @"cartTableViewCell";
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        NSBundle *classbundle = [NSBundle bundleForClass:[self class]];
        UINib *nib = [UINib nibWithNibName:@"CartTableViewCell" bundle:classbundle];
        [tableView registerNib:nib forCellReuseIdentifier:customCell];
 //       nibsRegistered = YES;
    }
    
   
    CartTableViewCell *cartCell = [tableView dequeueReusableCellWithIdentifier:customCell forIndexPath:indexPath];
   /*
    if (customCell == nil) {
        cartCell = [[[NSBundle mainBundle] loadNibNamed:@"CartTableViewCell" owner:self options:nil]lastObject];
    }*/
    
    NSUInteger row = [indexPath row];
    Cart *cart = [self.cartArray objectAtIndex:row];
    Goods *goods = [self queryGoodsWithId:cart.goodsId];
    if (goods) {
        cartCell.gNameLabel.text = goods.name;
    }else{
        cartCell.gNameLabel.text = @"-";
    }
    cartCell.numLabel.text = cart.num;
    cartCell.totalPriceLabel.text = cart.price;
    [cartCell.deleteCartButton addTarget:self action:@selector(deleteCartWithCartId:) forControlEvents:UIControlEventTouchDown];
    
    cartCell.deleteCartButton.tag = [cart.cartId integerValue];
    
    return cartCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
- (void)deleteCartWithCartId:(id)sender{
    
    BOOL deletSuccess = NO;
    
    UIButton *deleteBut = (UIButton *)sender;
    NSInteger butTag = [deleteBut tag];
    NSString *_butTag = [NSString stringWithFormat:@"%ld",butTag];
    
    NSError *error = nil;
    NSFetchRequest *fetched = [[NSFetchRequest alloc]init];
    NSEntityDescription *table = [NSEntityDescription entityForName:@"Cart" inManagedObjectContext:_appDelegate.managedObjectContext];
    
    [fetched setEntity:table];
    
    NSMutableArray *array = [[_appDelegate.managedObjectContext executeFetchRequest:fetched error:&error]mutableCopy];
    if (!array) {
        NSLog(@"Error delete table is %@",error);
    }else{
    
        for (Cart *cart in array) {
            if ([_butTag isEqualToString:cart.cartId]) {
                [_appDelegate.managedObjectContext deleteObject:cart];
                deletSuccess = YES;
                break;
            }
        }
    }
    
    if (deletSuccess) {
        for (Cart *cart in self.cartArray) {
            if ([_butTag isEqualToString:cart.cartId]) {
                [self.cartArray removeObject:cart];
                break;
            }
        }
        [self.cartShow reloadData];
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

- (IBAction)backPage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)settleButton:(id)sender {
    if (userName==nil && password == nil) {
        LoginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        login.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:login animated:YES completion:nil];
    }else{
        
        NSMutableArray *dicArray = [[NSMutableArray alloc]init];
        for (Cart  *cart in _cartArray) {
            
            NSMutableArray *_detail = [NSKeyedUnarchiver unarchiveObjectWithData:cart.detail];
 //           NSData *detailData = [NSJSONSerialization dataWithJSONObject:_detail options:0 error:nil];
//            NSString *detailString = [[NSString alloc]initWithData:detailData encoding:NSUTF8StringEncoding];
            
            
//            NSLog(@"-------->%ld",[_detail count]);
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:cart.cartId,@"cartId",
                cart.goodsId,@"goodsId",
                cart.goodsName,@"goodsName",
                cart.num,@"num",
                cart.price,@"price",
                _detail,@"detail",
                                 nil];
            [dicArray addObject:dic];
        }
       

        NSData *arrayData = [NSJSONSerialization dataWithJSONObject:dicArray options:0 error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:arrayData encoding:NSUTF8StringEncoding];
        
        CFStringRef ref=CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)jsonString, NULL,(CFStringRef)@"!*’();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
        NSString *_jsonString = [NSString stringWithString:(__bridge  NSString *)ref];
       
        CFRelease(ref);
        
        NSError *requestError;
        NSString *baseUrl = [[NSString alloc]initWithFormat:PHONE_ORDER_SETTLE];
        NSURL *url = [NSURL URLWithString:baseUrl];
        NSString *post = [NSString stringWithFormat:@"user=%@&pwd=%@&carts=%@&code=%@&deliveryId=%@",userName,password,_jsonString,@"",@"0"];

        
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&requestError];
        if (data) {
            id jsonValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *mdi = [NSDictionary dictionaryWithObjectsAndKeys:jsonValue,@"value", nil];
            
            DistributionMsgViewController *dis = [storyboard instantiateViewControllerWithIdentifier:@"distributionMsgViewController"];
            
            dis.mdi = mdi;
            dis.cartArray = _cartArray;
            
            dis.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:dis animated:YES completion:^{
                NSDictionary *userDic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"userName",password,@"password",uId,@"uId", nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLoginNoti" object:nil userInfo:userDic];
            }];
            
        }
      
    }
}

- (IBAction)toViewController:(id)sender {
    ViewController *viewCon = [storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    [self presentViewController:viewCon animated:YES completion:^{
        if (userInfo) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil userInfo:userInfo];
        }
    }];
    
}

- (IBAction)toUserIndexViewController:(id)sender {
    UserIndexViewController *userIndexViewCon = [storyboard instantiateViewControllerWithIdentifier:@"userIndexViewController"];
    [self presentViewController:userIndexViewCon animated:YES completion:^{
        if (userInfo) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil userInfo:userInfo];
        }
    }];
}
@end
