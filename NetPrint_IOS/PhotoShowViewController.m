//
//  PhotoShowViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/6/23.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "PhotoShowViewController.h"



@interface PhotoShowViewController (){
    CGSize AssetThumbnailSize;
    Goods *goods;
    PhotoSize *photoSize;
    NSInteger pIndex;
    NSString *pNum;
    NSMutableArray *dicArray;
    UIImage *bgImage;
    CGRect imageRegion;
}

@end

@implementation PhotoShowViewController

@synthesize appDelegate = _appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    pIndex = -1;
    pNum = @"1";
    
    dicArray = [[NSMutableArray alloc]init];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    goods = [self.goodsArray objectAtIndex:0];
    self.goodsNameLabel.text = goods.name;
    
    self.photoCount.text = [NSString stringWithFormat:@"%ld张",[self.dataArray count]];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAssetWithNotification:) name:@"editPhotoData" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pldAssetWithNotification:) name:@"pldPhotoData" object:nil];
    
    [self initCollentionView];
    [self getPhotoSizeWithGoods];
    [self initImageAsset];
    [self countPhoto];
    
}

- (void)getAssetWithNotification:(NSNotification *)notification{

    NSDictionary *info = [notification userInfo];
    pNum = [info valueForKey:@"photoNum"];
    NSInteger sum = [pNum integerValue] + [self.dataArray count] - 1;
    self.photoCount.text = [NSString stringWithFormat:@"%ld",sum];
    
    pIndex = [[info valueForKey:@"index"] integerValue];
    NSURL *pAsset = [info valueForKey:@"newAsset"];
    
    if (pAsset != nil) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:[pNum integerValue]],@"num",[NSString stringWithFormat:@"%@",pAsset],@"path",@"",@"set", nil];
        [dicArray removeObjectAtIndex:pIndex];
        [dicArray addObject:dic];
    }else{
        ALAsset *a=[self.dataArray objectAtIndex:pIndex];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:[pNum integerValue]],@"num",[NSString stringWithFormat:@"%@",[[a defaultRepresentation]url]],@"path",@"",@"set", nil];
        [dicArray removeObjectAtIndex:pIndex];
        [dicArray addObject:dic];
    }
    
    [self.showPhoto reloadData];
}

- (void)pldAssetWithNotification:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    pNum = [info valueForKey:@"photoNum"];
    
    NSInteger sum = [pNum integerValue] + [self.dataArray count]-1;
    self.photoCount.text = [NSString stringWithFormat:@"%ld",sum];
    
    pIndex = [[info valueForKey:@"index"] integerValue];
    NSString *pAsset = [info valueForKey:@"asseturl"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:[pNum integerValue]],@"num",pAsset,@"path",[info valueForKey:@"setV"],@"set", nil];
    [dicArray removeObjectAtIndex:pIndex];
    [dicArray addObject:dic];

    [self.showPhoto reloadData];
    
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

- (void) initImageAsset{
    
    NSInteger order = [photoSize.order integerValue];
    
    switch (order) {
        case 0:
            bgImage = [UIImage imageNamed:@"pld_3c.png"];
            imageRegion = CGRectMake(64, 64, 686, 969);
            break;
        case 1:
            bgImage = [UIImage imageNamed:@"pld_4c.png"];
            imageRegion = CGRectMake(65, 65, 832, 1115);
            break;
        case 2:
            bgImage = [UIImage imageNamed:@"pld_5c.png"];
            imageRegion = CGRectMake(84, 84, 882, 1182);
            break;
        case 3:
            bgImage = [UIImage imageNamed:@"pld_6c.png"];
            imageRegion = CGRectMake(80, 80, 942, 1280);
            break;
        default:
            
            break;
    }
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellName = @"selPhotoShowCollectionViewCell";
    //static BOOL nibPhotoCell = NO;
    //if (!nibPhotoCell) {
        NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
        UINib *nib = [UINib nibWithNibName:@"SelPhotoShowCollectionViewCell" bundle:classBundle];
        [collectionView registerNib:nib forCellWithReuseIdentifier:cellName];
    //}
    
    SelPhotoShowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"selPhotoShowCollectionViewCell" forIndexPath:indexPath];
    
    ALAsset *alasset = [self.dataArray objectAtIndex:indexPath.row];
    ALAssetRepresentation *rep = [alasset defaultRepresentation];
    CGSize imageSize = [rep dimensions];
    CGImageRef ref = [alasset aspectRatioThumbnail];

    UIImage *image = [UIImage imageWithCGImage:ref];
    NSInteger _photoNum;
    
    if (pIndex != -1 && pIndex == [indexPath row]) {
        cell.photoNum.text = pNum;
    }else{
        cell.photoNum.text = @"1";
        _photoNum = 1;
        
        NSDictionary *dic ;
        
        if ([@"0" isEqualToString:self.flag] || [@"1" isEqualToString:self.flag]) {
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger: _photoNum],@"num",[NSString stringWithFormat:@"%@",[rep url]],@"path",@"",@"set", nil];
        }else{
            Byte *buffer = (Byte *)malloc([rep size]);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0 length:[rep size] error:nil];
            NSData *imageData = [NSData dataWithBytesNoCopy:buffer length:buffered];
            UIImage *editImage = [UIImage imageWithData:imageData];

            
            PldInCollectionView *p = [[PldInCollectionView alloc]initWithFrame:CGRectMake(0.0, 0.0, 281, 464)];
            
            p.bgImage = bgImage;
            p.assetImage = editImage;
            p.imageRect = imageRegion;
            [p setViewSize];
            
            CGSize _size = p.bgSize;//遮罩层
            CGRect _rect = p.editRect;//图片区域、
            
            NSInteger _rotate = p.rotate;//是否翻转
            NSString *_path = [NSString stringWithFormat:@"%@",[rep url]];
            
            NSDictionary *setDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    _path,@"path",
                                    [NSNumber numberWithInteger:_size.width],@"width",
                                    [NSNumber numberWithInteger:_size.height],@"height",
                                    [NSNumber numberWithInteger:_rect.size.width],@"imageWidth",
                                    [NSNumber numberWithInteger:_rect.size.height],@"imageHeight",
                                    [NSNumber numberWithInteger:_rect.origin.x],@"left",
                                    [NSNumber numberWithInteger:_rect.origin.y],@"top",
                                    [NSNumber numberWithBool:NO],@"isEdited",
                                    [NSNumber numberWithInteger:1],@"num",
                                    [NSNumber numberWithInteger: [photoSize.order integerValue]],@"templateId",
                                    [NSNumber numberWithInteger: _rotate],@"rotate", nil];
            
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:setDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger: _photoNum],@"num",[NSString stringWithFormat:@"%@",[rep url]],@"path",jsonString,@"set", nil];
        }
        
        [dicArray addObject:dic];
    }
    if (imageSize.width < [photoSize.minpixelheight floatValue]) {
        cell.warnImage.hidden = NO;
    }
    
    cell.selectedPhoto.image = [self originImage:image scaleToSize:cell.selectedPhoto.frame.size];
    cell.editPhotoBut.tag = [indexPath row]+50;
    [cell.editPhotoBut addTarget:self action:@selector(editPhoto:) forControlEvents:UIControlEventTouchDown];
 
    
    return cell;
}

- (void)editPhoto:(id)sender{
    NSInteger arrayIndex = ((UIButton *)sender).tag-50;
    ALAsset *asset = [self.dataArray objectAtIndex:arrayIndex];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //ALAssetRepresentation *rep = [asset defaultRepresentation];
    //[self getImagePixValueWithALAssetRepresention:rep];
    if ([@"0" isEqualToString:self.flag] || [@"1" isEqualToString:self.flag]) {//0-普通冲印，1-证件照
        EditPhotoViewController *editPhoto = [storyboard instantiateViewControllerWithIdentifier:@"editPhotoViewController"];
        editPhoto.asset = asset;
        editPhoto.ps = photoSize;
        editPhoto.arrayIndex = arrayIndex;
        [self presentViewController:editPhoto animated:YES completion:nil];
    }else{//2-拍立得
    
        EditPldViewController *editPld = [storyboard instantiateViewControllerWithIdentifier:@"editPldViewController"];
        editPld.photoAsset = asset;
        editPld.photoSize = photoSize;
        editPld.arrayIndex = arrayIndex;
        [self presentViewController:editPld animated:YES completion:nil];
    }
    
}
- (UIImage *)getImagePixValueWithALAssetRepresention:(ALAssetRepresentation *)rep{

    Byte *buffer = (Byte *)malloc([rep size]);
    NSUInteger buffered = [rep getBytes:buffer fromOffset:0 length:[rep size] error:nil];
    NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered];
    UIImage *image = [UIImage imageWithData:data];
    
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
    
  //    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_array];
//    NSMutableArray *dicArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"------dicData ---->%ld",[dicArray count]);
    
    BOOL saveSuccess = [self insertCartGoodsArray:self.goodsArray assetData:dicArray];
    if (!saveSuccess) {
        
        UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"保存购物车出错！" cancel:@"确定" other:nil];
        
        //UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Attention" message:@"保存购物车出错！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        [self presentViewController:cart animated:YES completion:nil];
    }     
}

- (BOOL) insertCartGoodsArray:(NSMutableArray *)gArray assetData:(NSMutableArray *)aArray{
    
    NSInteger photoSum = [self.photoCount.text integerValue];
    
    NSError *error = nil;
    if (gArray && aArray) {
        Goods *g = [gArray objectAtIndex:0];
        Cart *cart = (Cart *)[NSEntityDescription insertNewObjectForEntityForName:@"Cart" inManagedObjectContext:_appDelegate.managedObjectContext];
        
        [cart setGoodsId:g.gid];
        [cart setGoodsName:g.name];
        [cart setNum:[NSString stringWithFormat:@"%ld",photoSum]];
        
        [cart setDetail:[NSKeyedArchiver archivedDataWithRootObject:aArray]];
        
        
        NSDecimalNumber *_price = [NSDecimalNumber decimalNumberWithString:g.marketprice];
        
        
        NSDecimalNumber *_num = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",photoSum]];
        
        NSDecimalNumber *_totalPrice = [_price decimalNumberByMultiplyingBy:_num];
        
        [cart setPrice:[_totalPrice stringValue]];
        
        NSMutableString *cartId = [self createCartId];
        [cart setCartId:cartId==nil?@"0" : cartId];
        
        BOOL isSuccess = [_appDelegate.managedObjectContext save:&error];
        if (!isSuccess) {
            //NSLog(@"error cart is  %@",error);
            UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"购物车保存出错" cancel:@"确定" other:nil];
            [alertView show];
        }
        return  isSuccess;
    }else{
        UIAlertView *alertView = [BaseView alertViewNoDelegateWithTitle:@"提示" msg:@"数据为空,请重新选择" cancel:@"确定" other:nil];
        [alertView show];
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
    
    return cartId;
}

//缩放图片
- (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

//统计像素不符合的图片
- (void)countPhoto{
    __block NSInteger countPhoto = 0;
    dispatch_queue_t queue = dispatch_queue_create("com.sjky.xiao", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        for (ALAsset *alasset in self.dataArray) {
            ALAssetRepresentation *rep = [alasset defaultRepresentation];
            CGSize imageSize = [rep dimensions];
            if (imageSize.width < [photoSize.minpixelheight floatValue]) {
                NSLog(@"-------%ld",countPhoto);
                countPhoto++;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.errorPhotoNum.text = [NSString stringWithFormat:@"%ld",countPhoto];
        });
    });
}

@end
