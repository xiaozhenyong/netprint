//
//  PhotoShowViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/6/23.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoImageView.h"
#import "AppDelegate.h"
#import "Goods.h"
#import "Cart.h"
#import "PhotoSize.h"
#import "SelPhotoShowCollectionViewCell.h"
#import "EditPhotoViewController.h"
#import "EditPldViewController.h"
#import "PldInCollectionView.h"



@interface PhotoShowViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NSCoding>
/*
 - (IBAction)back:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *selectShow;

@property (strong, nonatomic) IBOutlet UITableView *photoAlbumTableView;
 
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *photoCount;
*/
@property (strong, nonatomic) IBOutlet UILabel *errorPhotoNum;
@property (strong, nonatomic) IBOutlet UILabel *photoCount;
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *showPhoto;

- (IBAction)backPage:(id)sender;
- (IBAction)nextPage:(id)sender;

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) NSString *swv;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *goodsArray;
@property (strong, nonatomic) NSString *flag;

@property (strong, nonatomic) ALAsset *asset;
@end
