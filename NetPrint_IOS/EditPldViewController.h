//
//  EditPldViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/8/12.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h> 
#import <QuartzCore/QuartzCore.h>
#import "PhotoSize.h"
#import <math.h>

@interface EditPldViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *setPhotoNumLabel;

- (IBAction)back:(id)sender;
- (IBAction)editPhotoFinish:(id)sender;
- (IBAction)subPhotoNumBut:(id)sender;
- (IBAction)addPhotoNumBut:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *editView;

@property (strong, nonatomic) IBOutlet UIView *editPhotoView;

@property (strong, nonatomic) ALAsset *photoAsset;
@property (strong, nonatomic) PhotoSize *photoSize;
@property (readwrite, nonatomic) NSInteger arrayIndex;

@property (strong, nonatomic) UIImageView *assetView;

@end
