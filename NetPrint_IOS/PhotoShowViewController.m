//
//  PhotoShowViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/6/23.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "PhotoShowViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CartViewController.h"


@interface PhotoShowViewController (){
    CGSize AssetThumbnailSize;
    Goods *goods;
    PhotoSize *photoSize;
}

@end

@implementation PhotoShowViewController

@synthesize dataArray;
@synthesize appDelegate = _appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    goods = [self.goodsArray objectAtIndex:0];
    self.goodsNameLabel.text = goods.name;
    
    self.photoCount.text = [NSString stringWithFormat:@"%ld",[self.dataArray count]];

    
    [self initCollentionView];
    [self getPhotoSizeWithGoods];
}

- (void)getPhotoSizeWithGoods{
    NSString *psId = goods.photosizeid;
    
    NSError *error = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PhotoSize" inManagedObjectContext:_appDelegate.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photosizeid = %@",psId];
    [request setPredicate:predicate];
    
    NSArray *array = [[_appDelegate.managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    photoSize = [array objectAtIndex:0];
    
}

- (void)initCollentionView{
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.showPhoto.collectionViewLayout).itemSize;
    AssetThumbnailSize = CGSizeMake(cellSize.width * scale/2, cellSize.height * scale/2);
   
    self.showPhoto.dataSource = self;
    self.showPhoto.delegate = self;
    self.showPhoto.scrollEnabled = YES;

    [self.showPhoto registerClass:[SelPhotoShowCollectionViewCell class] forCellWithReuseIdentifier:@"selPhotoShowCollectionViewCell"];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    //UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    static NSString *cellName = @"selPhotoShowCollectionViewCell";
    static BOOL nibPhotoCell = NO;
    if (!nibPhotoCell) {
        NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
        UINib *nib = [UINib nibWithNibName:@"SelPhotoShowCollectionViewCell" bundle:classBundle];
        [collectionView registerNib:nib forCellWithReuseIdentifier:cellName];
    }
    
    SelPhotoShowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"selPhotoShowCollectionViewCell" forIndexPath:indexPath];
    
    ALAsset *alasset = [self.dataArray objectAtIndex:indexPath.row];
    
    CGImageRef ref = [alasset aspectRatioThumbnail];

    UIImage *image = [UIImage imageWithCGImage:ref];
    
    cell.selectedPhoto.image = image;
    cell.editPhotoBut.tag = [indexPath row]+50;
    [cell.editPhotoBut addTarget:self action:@selector(editPhoto:) forControlEvents:UIControlEventTouchDown];
 
    
    return cell;
}

- (void)editPhoto:(id)sender{
    NSInteger arrayIndex = ((UIButton *)sender).tag-50;
    ALAsset *asset = [self.dataArray objectAtIndex:arrayIndex];
    
    //ALAssetRepresentation *rep = [asset defaultRepresentation];
    //[self getImagePixValueWithALAssetRepresention:rep];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditPhotoViewController *editPhoto = [storyboard instantiateViewControllerWithIdentifier:@"editPhotoViewController"];
    editPhoto.asset = asset;
    editPhoto.ps = photoSize;
    editPhoto.arrayIndex = arrayIndex;
    [self presentViewController:editPhoto animated:YES completion:nil];
}
- (UIImage *)getImagePixValueWithALAssetRepresention:(ALAssetRepresentation *)rep{

    Byte *buffer = (Byte *)malloc([rep size]);
    NSUInteger buffered = [rep getBytes:buffer fromOffset:0 length:[rep size] error:nil];
    NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered];
    UIImage *image = [UIImage imageWithData:data];
    NSLog(@"imagew----->%f",image.size.width);
    return image;
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

- (IBAction)nextPage:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CartViewController *cart = [storyboard instantiateViewControllerWithIdentifier:@"cartViewController"];
    cart.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    NSMutableArray *_array = [[NSMutableArray alloc]init];
    NSString *assetNum = @"1";
    for (ALAsset *a in self.dataArray) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[a valueForProperty:ALAssetPropertyAssetURL]],@"path",assetNum,@"num", nil];
        [_array addObject:dic];
    }
    
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_array];
//    NSMutableArray *dicArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    NSLog(@"------dicData ---->%ld",[dicArray count]);
    
    BOOL saveSuccess = [self insertCartGoodsArray:self.goodsArray assetData:_array];
    if (!saveSuccess) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Attention" message:@"保存购物车出错！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    [self presentViewController:cart animated:YES completion:nil];
     
}

- (BOOL) insertCartGoodsArray:(NSMutableArray *)gArray assetData:(NSMutableArray *)aArray{
    
    NSError *error = nil;
    if (gArray && aArray) {
        Goods *g = [gArray objectAtIndex:0];
        Cart *cart = (Cart *)[NSEntityDescription insertNewObjectForEntityForName:@"Cart" inManagedObjectContext:_appDelegate.managedObjectContext];
        
        [cart setGoodsId:g.gid];
        [cart setGoodsName:g.name];
        [cart setNum:[NSString stringWithFormat:@"%ld",[aArray count]]];
        
        [cart setDetail:[NSKeyedArchiver archivedDataWithRootObject:aArray]];
        
        
        NSDecimalNumber *_price = [NSDecimalNumber decimalNumberWithString:g.marketprice];
        
        NSLog(@"-----marketprice------>%@",g.marketprice);
        
        NSDecimalNumber *_num = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",[aArray count]]];
        
        NSLog(@"-----num-------------->%ld",[aArray count]);
        
        NSDecimalNumber *_totalPrice = [_price decimalNumberByMultiplyingBy:_num];
        
        [cart setPrice:[_totalPrice stringValue]];
        
        NSMutableString *cartId = [self createCartId];
        [cart setCartId:cartId==nil?@"0" : cartId];
        
        BOOL isSuccess = [_appDelegate.managedObjectContext save:&error];
        if (!isSuccess) {
            NSLog(@"error cart is  %@",error);
        }
        return  isSuccess;
    }else{
        NSLog(@"gArray or  aArray is  null");
    }
    
    return NO;
}

- (NSMutableData *) codingAssetArray:(NSMutableArray *)assetArray{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:assetArray forKey:@"asset"];
    [archiver finishEncoding];
    
    return data;
}

- (NSMutableString *)createCartId{

    NSMutableString *cartId = [[NSMutableString alloc]init];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateStyle:kCFDateFormatterMediumStyle];
//    [formatter setTimeStyle:kCFDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd-hh-mm-ss"];
    
    NSString *string_time = [formatter stringFromDate:date];
    NSArray *time = [string_time componentsSeparatedByString:@"-"];
    NSString *vMin = [time objectAtIndex:4];
    NSString *vSec = [time objectAtIndex:5];
    
    [cartId appendString:vMin];
    [cartId appendString:vSec];
    
    NSLog(@"----->%@",cartId);
    
    return cartId;
}
@end
