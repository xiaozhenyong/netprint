//
//  EditPhotoViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/8/3.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#include <math.h>
#import "PhotoSize.h"
#import "UIImage+Rotation.h"

@interface EditPhotoViewController : UIViewController

- (IBAction)back:(id)sender;
- (IBAction)editFinish:(id)sender;
- (IBAction)subPhotoNumBut:(id)sender;
- (IBAction)addPhotoNumBut:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *photoNum;

@property (strong, nonatomic) IBOutlet UIView *editPhotoField;

@property (strong, nonatomic) IBOutlet UIView *editPhoto;
- (IBAction)crop:(id)sender;
- (IBAction)blank:(id)sender;
- (IBAction)original:(id)sender;

@property (strong, nonatomic) UIImageView *assetImageView;
@property (strong, nonatomic) ALAsset *asset;
@property (strong, nonatomic) PhotoSize *ps;
@property (readwrite, nonatomic) NSInteger arrayIndex;
@end
