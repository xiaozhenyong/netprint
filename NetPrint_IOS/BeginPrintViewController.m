//
//  BeginPrintViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/6/23.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "BeginPrintViewController.h"
#import "CTAssetsPageViewController.h"
#import "CTAssetsPickerController.h"
#import "PhotoShowViewController.h"


@interface BeginPrintViewController ()<CTAssetsPickerControllerDelegate>

@end

@implementation BeginPrintViewController

@synthesize appDelegate = _appDelegate;
@synthesize bFlag = _bFlag;
@synthesize assets = _assets;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [self initGoodsSelect];
//    [self startRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)initGoodsSelect{
    [self.open addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    
    CGFloat psx = self.photoSize.bounds.origin.x;
    CGFloat psy = self.photoSize.bounds.origin.y;
    NSInteger psTag = self.photoSize.tag;
    
    self.psArray = [self queryForPhotoProperty:_bFlag tableName:PHOTO_SIZE];
    self.psCount = [self.psArray count];
    
    if (self.psArray) {
        [self photoSizeAddSubview:psx originY:psy psTag:psTag psArray:self.psArray];
    }else{
        NSLog(@"PhotoSize is null ");
    }
    
    CGFloat ptx = self.photoTexture.bounds.origin.x;
    CGFloat pty = self.photoTexture.bounds.origin.y;
    NSInteger ptTag = self.photoTexture.tag;
    
    self.ptArray = [self queryForPhotoProperty:_bFlag tableName:PHOTO_TEXTURE];
    self.ptCount = [self.ptArray count];
    
    if (self.ptCount != 0) {
        [self photoTextureAddSubview:ptx originY:pty psTag:ptTag psArray:self.ptArray];
    }else{
        NSLog(@"PhotoTexture is null ");
    }

}

- (void) photoSizeAddSubview:(CGFloat)psx originY:(CGFloat)psy psTag:(NSInteger) tag psArray:(NSMutableArray *)mArray{
    UIButton *but = nil;

    NSInteger i = 0;
    for (PhotoSize *ps in mArray) {
        i = [ps.photosizeid integerValue];
        but = [self createPSRadioButton:psx originY:psy sizeWidth:20 sizeHeight:20 index:i buttonTitle:ps.name];
        [self.photoSize addSubview:but];
        psx +=50;
    }
}

- (UIButton *) createPSRadioButton:(CGFloat)x originY:(CGFloat)y sizeWidth:(CGFloat)w sizeHeight:(CGFloat)h index:(NSInteger)index buttonTitle:(NSString *)title{
    
    UIButton *radioBut = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = CGRectMake(x, y, w,h);
    [radioBut setFrame:rect];
    [radioBut setTag:index];
    [radioBut setTitle:title forState:UIControlStateNormal];
    
    [radioBut setImage:[UIImage imageNamed:@"rbnoselect.png"] forState:UIControlStateNormal];
    
    [radioBut addTarget:self action:@selector(psRadioButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    return  radioBut;
}
- (void)psRadioButtonSelect:(id)sender{
    NSInteger i = 0;
    UIButton *deselectBut = nil;
    for (PhotoSize *ps in self.psArray) {
        i = [ps.photosizeid integerValue];
        deselectBut = (UIButton *)[self.photoSize viewWithTag:i];
        [deselectBut setImage:[UIImage imageNamed:@"rbnoselect.png"] forState:UIControlStateNormal];
    }
    
    UIButton *but = (UIButton *)sender;
    self.photoSizeId.text = [NSString stringWithFormat:@"%ld",but.tag];
    [but setImage:[UIImage imageNamed:@"rbselected.png"] forState:UIControlStateNormal];
}


- (void) photoTextureAddSubview:(CGFloat)psx originY:(CGFloat)psy psTag:(NSInteger) tag psArray:(NSMutableArray *)mArray{
    UIButton *but = nil;
    NSInteger idIndex = 0;
    for (PhotoTexture *pt in mArray) {
        idIndex = [pt.phototextureid integerValue];
        but = [self createPTRadioButton:psx originY:psy sizeWidth:20 sizeHeight:20 index:idIndex buttonTitle:pt.name];
        [self.photoTexture addSubview:but];
        psx +=50;
    }
}

- (UIButton *) createPTRadioButton:(CGFloat)x originY:(CGFloat)y sizeWidth:(CGFloat)w sizeHeight:(CGFloat)h index:(NSInteger)index buttonTitle:(NSString *)title{
    
    UIButton *radioBut = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = CGRectMake(x, y, w,h);
    [radioBut setFrame:rect];
    [radioBut setTag:index];
    [radioBut setTitle:title forState:UIControlStateNormal];
    [radioBut setImage:[UIImage imageNamed:@"rbnoselect.png"] forState:UIControlStateNormal];
    
    [radioBut addTarget:self action:@selector(ptRadioButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    return  radioBut;
}
- (void)ptRadioButtonSelect:(id)sender{
 
    NSInteger i = 0;
    UIButton *deselectBut = nil;
    for (PhotoTexture *pt in self.ptArray) {
        i = [pt.phototextureid integerValue];
        deselectBut = (UIButton *)[self.photoTexture viewWithTag:i];
        [deselectBut setImage:[UIImage imageNamed:@"rbnoselect.png"] forState:UIControlStateNormal];
    }
    
    UIButton *but = (UIButton *)sender;
    self.photoTexttureId.text = [NSString stringWithFormat:@"%ld",but.tag];
    
    [but setImage:[UIImage imageNamed:@"rbselected.png"] forState:UIControlStateNormal];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)switchChange:(id)sender{
    UISwitch *uiswitch = (UISwitch *)sender;
    self.swithValue = uiswitch.isOn;
    if (uiswitch.isOn) {
        self.switchValueLable.text = @"1";
    }else{
        self.switchValueLable.text = @"0";
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)beginPrint:(id)sender {
/*    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhotoShowViewController *photoShow = [storyBoard instantiateViewControllerWithIdentifier:@"photoShowViewController"];
    photoShow.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    photoShow.psv = self.photoSizeLable.text;
    photoShow.ptv = self.photoTextureLable.text;
    photoShow.swv = self.switchValueLable.text;
    [self presentViewController:photoShow animated:YES completion:nil];*/
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhotoShowViewController *photoShow = [storyBoard instantiateViewControllerWithIdentifier:@"photoShowViewController"];
    
    NSString *psId = self.photoSizeId.text;
    NSString *ptId = self.photoTexttureId.text;
    
    photoShow.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    photoShow.swv = self.switchValueLable.text;
    photoShow.dataArray = _assets;

    if ([@"0" isEqualToString:self.switchValueLable.text]) {
        photoShow.goodsArray = [self queryForGoodsPhotoSizeId:psId photoTextureId:ptId photoWrap:WRAP_P];
    }else{
        photoShow.goodsArray = [self queryForGoodsPhotoSizeId:psId photoTextureId:ptId photoWrap:WRAP_S];
    }
    
    
    if ([_assets count] < 1) {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Attention"
                                   message:@"请先选择照片"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
    [self presentViewController:photoShow animated:YES completion:nil];


    }

- (IBAction)selectPhoto:(id)sender {
//    if (!_assets) {
        _assets = [[NSMutableArray alloc]init];
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc]init];
        picker.assetsFilter = [ALAssetsFilter allAssets];
        picker.showsCancelButton = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
        picker.delegate = self;
        picker.selectedAssets = [NSMutableArray arrayWithArray:_assets];
        //Ipad
        /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
         self.popover = [[UIPopoverController alloc]initWithContentViewController:picker];
         self.popover.delete = self;
         [self.popover presentPopoverFramBarButtonItem:sender
         permittedArrowDirections:UIPopoverArrowDirectionAny
         animated:YES];
         }else{*/
        [self presentViewController:picker animated:YES completion:nil];
        //}
//    }

}


#pragma mark - Assets Picker Delegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
//    if (self.popover != nil)
//        [self.popover dismissPopoverAnimated:YES];
//    else
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    self.assets = [NSMutableArray arrayWithArray:assets];
//    [self.tableView reloadData];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
{
    // Enable video clips if they are at least 5s
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {
        NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        return lround(duration) >= 5;
    }
    else
    {
        return YES;
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    /*if (picker.selectedAssets.count >= 10)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Attention"
                                   message:@"Please select not more than 10 assets"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }*/
    
    if (!asset.defaultRepresentation)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Attention"
                                   message:@"Your asset has not yet been downloaded to your device"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
//    return (picker.selectedAssets.count < 10 && asset.defaultRepresentation != nil);
    return asset.defaultRepresentation != nil;
}


- (void)startRequest{
    /*异步POST请求
    NSString *baseUrl = [[NSString alloc] initWithFormat:PHONE_PHOTOS_DETAIL];
    NSURL *url = [NSURL URLWithString:[baseUrl URLEncodedString]];
    NSString *post = [NSString stringWithFormat:@"versionNumber=%@",VERSION];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:
     ^(NSURLResponse *response, NSData *d,NSError *er){
        
        [self showData:d];
    }];*/
    NSString *url = [[NSString alloc]initWithFormat:PHONE_PHOTOS_DETAIL,VERSION];
    NSURL *_url = [NSURL URLWithString:[url URLEncodedString]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:_url];
    [request setHTTPMethod:@"GET"];
    NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    [self showData:d];

}

- (void) showData:(NSData *)data{
    
    NSError *error;
    if (data) {
        id jsonValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (!jsonValue || error) {
            NSLog(@"fail");
        }
        NSMutableArray *photoSize= [jsonValue objectForKey:@"phonephotosize"];
        NSMutableArray *photoTexture = [jsonValue objectForKey:@"phonephototexture"];
        NSMutableArray *goods = [jsonValue objectForKey:@"goods"];

        [self insertDataForGoods:goods];
        [self insertDataForPhotoSize:photoSize];
        [self insertDataForPhotoTexture:photoTexture];
    }else{
        NSLog(@"fail");
    }
}


/*
    type=0 常规尺寸
        =1 证件照
        =2 拍立得
 */
- (NSMutableArray *)queryForPhotoProperty:(NSString *)flag tableName:(NSString *)tableName{
    NSError *error = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *table = [NSEntityDescription entityForName:tableName inManagedObjectContext:_appDelegate.managedObjectContext];
    [request setEntity:table];
    if (flag) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type=%@",flag];
        [request setPredicate:predicate];
    }
    
    NSMutableArray *array = [[_appDelegate.managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    if (array) {
        return array;
    }else{
        return nil;
    }
}

- (NSMutableArray *)queryForGoodsPhotoSizeId:(NSString *)psId photoTextureId:(NSString *)ptId photoWrap:(NSString *)pwId{

    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *table = [NSEntityDescription entityForName:@"Goods" inManagedObjectContext:_appDelegate.managedObjectContext];
    [request setEntity:table];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(photosizeid = %@) AND (phototextureid = %@)  AND (photowrapid = %@)",psId,ptId,pwId];
    
    [request setPredicate:predicate];

    NSMutableArray *array = [[_appDelegate.managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    
    return array;
}

/*
  删除操作
 */
- (void)deleteData:(NSString *)tableName{

    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *table = [NSEntityDescription entityForName:tableName inManagedObjectContext:_appDelegate.managedObjectContext];
    [request setEntity:table];
    
    NSMutableArray *array = [[_appDelegate.managedObjectContext  executeFetchRequest:request error:&error]mutableCopy];
    if (!array) {
        NSLog(@"Error delete table is %@",error);
    }else{
        if ([@"Goods" isEqualToString:tableName]) {
            for (Goods *good in array) {
                [_appDelegate.managedObjectContext deleteObject:good];
            }
        }else if ([@"PhotoSize" isEqualToString:tableName]){
            for (PhotoSize *ps in array) {
                [_appDelegate.managedObjectContext deleteObject:ps];
            }
        }else{
            for (PhotoTexture *pt in array) {
                [_appDelegate.managedObjectContext deleteObject:pt];
            }
        }
        if ([_appDelegate.managedObjectContext save:&error]) {
            NSLog(@"Error : %@",error);
        }
    }
}

/*
    插入操作为非线程安全
 */
- (void) insertDataForPhotoSize:(NSMutableArray *)photoSizeArray{
    NSError *error = nil;
    if (photoSizeArray) {
        for (NSDictionary *dic in photoSizeArray) {
            PhotoSize *ps = (PhotoSize *)[NSEntityDescription insertNewObjectForEntityForName:@"PhotoSize" inManagedObjectContext:_appDelegate.managedObjectContext];
            
            [ps setName:[dic objectForKey:@"name"]];
            [ps setPhotosizeid:[self nsNumberToNSString:[dic objectForKey:@"photosizeid"]]];
            [ps setMixpixelwidth:[self nsNumberToNSString:[dic objectForKey:@"mixpixelwidth"]]];
            [ps setMinpixelheight:[self nsNumberToNSString:[dic objectForKey:@"minpixelheight"]]];
            [ps setFactwidth:[self nsNumberToNSString:[dic objectForKey:@"factwidth"]]];
            [ps setFactheight:[self nsNumberToNSString:[dic objectForKey:@"factheight"]]];
            [ps setType:[self nsNumberToNSString:[dic objectForKey:@"type"]]];
            [ps setOrder:[self nsNumberToNSString:[dic objectForKey:@"order"]]];
            
            BOOL isSuccess = [_appDelegate.managedObjectContext save:&error];
            if (!isSuccess) {
                NSLog(@"Error photosize is %@",error);
            }
        }

    }else{
        NSLog(@"photosize is NULL");
    }
}

- (void) insertDataForPhotoTexture:(NSMutableArray *)photoTextureArray{
    NSError *error = nil;
    if (photoTextureArray) {
        for (NSDictionary *dic in photoTextureArray) {
            PhotoTexture *pt = (PhotoTexture *)[NSEntityDescription insertNewObjectForEntityForName:@"PhotoTexture" inManagedObjectContext:_appDelegate.managedObjectContext];
            [pt setName:[dic objectForKey:@"name"]];
            [pt setPhototextureid:[self nsNumberToNSString:[dic objectForKey:@"phototextureid"]]];
            [pt setType:[self nsNumberToNSString:[dic objectForKey:@"type"]]];
            [pt setSort:[self nsNumberToNSString:[dic objectForKey:@"sort"]]];
            
            BOOL isSuccess = [_appDelegate.managedObjectContext save:&error];
            if (!isSuccess) {
                NSLog(@"Error phototexture is %@",error);
            }
        }
    }else{
        NSLog(@"photoTextrue is NULL");
    }
}

- (void) insertDataForGoods:(NSMutableArray *)goodsArray{
    NSError *error = nil;
    if (goodsArray) {
        for (NSDictionary *dic in goodsArray) {
            Goods *g = (Goods *)[NSEntityDescription insertNewObjectForEntityForName:@"Goods" inManagedObjectContext:_appDelegate.managedObjectContext];
            
            [g setGid:[NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]]];
            [g setName:[dic valueForKey:@"name"]];
            
            [g setMarketprice:[NSString stringWithFormat:@"%@",[dic valueForKey:@"marketprice"]]];
            
            
            [g setPhotosizeid:[NSString stringWithFormat:@"%@",[dic valueForKey:@"photosizeid"]]];
            
            [g setPhototextureid:[NSString stringWithFormat:@"%@",[dic valueForKey:@"phototextureid"]]];
             
            [g setPhotowrapid:[NSString stringWithFormat:@"%@",[dic valueForKey:@"photowrapid"]]];
            
            BOOL isSuccess = [_appDelegate.managedObjectContext save:&error];
            if (!isSuccess) {
                NSLog(@"Error goods is %@",error);
            }
        }
    }else{
        NSLog(@"goods is NULL");
    }
}

- (NSString *)nsNumberToNSString:(NSNumber *)number{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    return [formatter stringFromNumber:number];
}

@end
