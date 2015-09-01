//
//  PldInCollectionView.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/8/21.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "PldInCollectionView.h"

@implementation PldInCollectionView{
    UIImage *ratImage;
    
}

@synthesize assetImage = _assetImage;
@synthesize bgImage = _bgImage;
@synthesize assetView = _assetView;
@synthesize imageRect = _imageRect;
@synthesize bgSize = _bgSize;
@synthesize editRect = _editRect;
@synthesize rotate = _rotate;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = frame;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
}
*/
- (void)setViewSize{
    
    self.clipsToBounds = NO;
   
    _assetView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.assetView.userInteractionEnabled = YES;
    [self addSubview:self.assetView];
    
    //背景区域
    CALayer *bgLayer = [CALayer layer];
    
    CGFloat targetRatio = self.frame.size.width/self.frame.size.height;
    CGFloat realRatio = _bgImage.size.width/_bgImage.size.height;
    
    CGFloat realW = 0.0;
    CGFloat realH = 0.0;
    
    if (realRatio > targetRatio) {
        realW = self.frame.size.width;
        realH = realW/realRatio;
    }else{
        realH = self.frame.size.height;
        realW = realH*realRatio;
    }
    
    CGRect rect = self.frame;
    rect.size = CGSizeMake(round(realW), round(realH));
    self.frame = rect;
    
    _bgSize = CGSizeMake(round(realW), round(realH));
    
    bgLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    bgLayer.contents = (id)_bgImage.CGImage;
    [self.layer insertSublayer:bgLayer above:_assetView.layer];
    

    //用户图片区域
    CGFloat iTargetRatio = _imageRect.size.width/_imageRect.size.height;
    CGFloat iRealRatio = _assetImage.size.width/_assetImage.size.height;
    CGFloat iRatio = self.frame.size.width/_bgImage.size.width;
    
    CGFloat iRealW = 0.0;
    CGFloat iRealH = 0.0;
    
    if (iRealRatio<=1) {
        _rotate = 0;
        ratImage = _assetImage;
        if (iTargetRatio > iRealRatio) {
            iRealW = _imageRect.size.width * iRatio;
            iRealH = iRealW/iRealRatio;
        }else{
            iRealH = _imageRect.size.height * iRatio;
            iRealW = iRealH * iRealRatio;
        }
    }else{
        //90°
        _rotate = 90;
        ratImage  = [UIImage imageWithCGImage:_assetImage.CGImage scale:1 orientation:UIImageOrientationRight];
        realRatio = 1/realRatio;
        if (targetRatio > realRatio) {
            iRealW = _imageRect.size.width * iRatio;
            iRealH = iRealW/realRatio;
        }else{
            iRealH = _imageRect.size.height * iRatio;
            iRealW = iRealH * iRealRatio;
        }
    }
    
    _assetView.frame=CGRectMake(round(_imageRect.origin.x * iRatio), round(_imageRect.origin.y*iRatio), round(iRealW), round(iRealH));
    
//    _editRect = CGRectMake(round(_imageRect.origin.x * iRatio), round(_imageRect.origin.y*iRatio-1), round(iRealW), round(iRealH));
    _editRect = _assetView.frame;

}
@end
