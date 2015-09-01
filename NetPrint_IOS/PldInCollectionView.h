//
//  PldInCollectionView.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/8/21.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>

@interface PldInCollectionView : UIView
@property (strong, nonatomic) UIImage *assetImage;
@property (strong, nonatomic) UIImage *bgImage;
@property (strong, nonatomic) UIImageView *assetView;
@property (readwrite, nonatomic) CGRect imageRect;
@property (readwrite, nonatomic) CGSize  bgSize;
@property (readwrite, nonatomic) CGRect editRect;
@property (readwrite, nonatomic) NSInteger rotate;
- (void) setViewSize;
@end
