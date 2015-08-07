//
//  SelPhotoShowCollectionViewCell.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/25.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelPhotoShowCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *selectedPhoto;
@property (strong, nonatomic) IBOutlet UILabel *photoNum;
@property (strong, nonatomic) IBOutlet UIImageView *warnImage;
@property (strong, nonatomic) IBOutlet UIButton *editPhotoBut;

@end
