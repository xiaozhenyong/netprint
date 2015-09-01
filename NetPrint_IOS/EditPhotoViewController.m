//
//  EditPhotoViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/8/3.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "EditPhotoViewController.h"

@interface EditPhotoViewController (){
    UIImage *image;
    float _lastTransX,_lastTransY;
    float imageViewX,imageViewY;
    CGSize originalImageViewSize;
    CGFloat imageRate, viewRate;
    int editFlag;//0=剪切,1=留白,2=原图
    int mpw,mph;//最小像素宽，最小像素高
    UIImage *newImage;
}

@end

@implementation EditPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lastTransX = 0.0;
    _lastTransY = 0.0;
    
    self.editPhoto.clipsToBounds = NO;
    self.assetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.editPhoto.frame.size.width, self.editPhoto.frame.size.height)];
    self.assetImageView.userInteractionEnabled = YES;
    [self.editPhoto addSubview:self.assetImageView];

    
    UIPanGestureRecognizer *movePan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveImage:)];
    [movePan setMinimumNumberOfTouches:1];
    [movePan setMaximumNumberOfTouches:1];
    [self.assetImageView addGestureRecognizer:movePan];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [self initViewControll];
  
}


- (void)initViewControll{

    imageViewX = self.assetImageView.frame.origin.x;
    imageViewY = self.assetImageView.frame.origin.y;
    
    [self getImageWithALAssetRepresention:[self.asset defaultRepresentation]];
    
    [self setEditPhotoWithPhotoSize];
    [self setImageViewWithPhotoSize];
}

- (void)getImageWithALAssetRepresention:(ALAssetRepresentation *)rep{
    Byte *buffer = (Byte *)malloc([rep size]);
    NSUInteger buffered = [rep getBytes:buffer fromOffset:0 length:[rep size] error:nil];
    NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered];
    image = [UIImage imageWithData:data];
   
}

- (NSData *)getALAssetRepresentationWithALAsset:(ALAsset *)alasset{
    ALAssetRepresentation *rep = [alasset defaultRepresentation];
    Byte *buffer = (Byte *)malloc([rep size]);
    NSUInteger buffered = [rep getBytes:buffer fromOffset:0 length:[rep size] error:nil];
    return [NSData dataWithBytesNoCopy:buffer length:buffered];
}

- (void)setEditPhotoWithPhotoSize{
    self.editPhoto.layer.borderWidth = 0.5;
    self.editPhoto.layer.borderColor = [UIColor redColor].CGColor;
    
    mpw = [self.ps.mixpixelwidth intValue];
    mph = [self.ps.minpixelheight intValue];
//    mpw = 1395;
//    mph = 1800;
    
    CGFloat w = 0.0;
    CGFloat h = 0.0;
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    
    if (imageW > imageH) {
        w = self.editPhoto.frame.size.width;
        if (mpw >= mph) {
            h = w * mph/mpw;
        }else{
            h = w * mpw/mph;
        }
    }else{
        h = self.editPhoto.frame.size.height;
        if (mph >= mpw) {
            w = h * mpw/mph;
        }else{
            w = h * mph/mpw;
        }
    }
    
    CGRect editPhotoFrame = self.editPhoto.frame;
    editPhotoFrame.size=CGSizeMake(w, h);
    self.editPhoto.frame = editPhotoFrame;
    self.editPhoto.center = CGPointMake(self.editPhotoField.frame.size.width/2, self.editPhotoField.frame.size.height/2);
}

- (void)setImageViewWithPhotoSize{
    imageRate = image.size.width/image.size.height;
    viewRate = self.editPhoto.frame.size.width/self.editPhoto.frame.size.height;
    
    CGFloat imageViewW = 0.0;
    CGFloat imageViewH = 0.0;
    if (imageRate > viewRate) {
        imageViewH = self.editPhoto.frame.size.height;
        imageViewW = imageViewH * image.size.width/image.size.height;
        
        float _imageScale = self.editPhoto.frame.size.height/image.size.height;
        originalImageViewSize = CGSizeMake(image.size.width*_imageScale, image.size.height*_imageScale);
        
    }else{
        imageViewW = self.editPhoto.frame.size.width;
        imageViewH = imageViewW * image.size.height/image.size.width;
        
        float _imageScale = self.editPhoto.frame.size.width/image.size.width;
        originalImageViewSize = CGSizeMake(image.size.width*_imageScale, image.size.height*_imageScale);
    }
    
    CGRect rect = self.assetImageView.frame;
    rect.size = CGSizeMake(imageViewW, imageViewH);
    self.assetImageView.frame = rect;
    
    self.assetImageView.image = image;
    self.assetImageView.center = CGPointMake(self.editPhoto.frame.size.width/2, self.editPhoto.frame.size.height/2);
    
    
    
}


- (void)moveImage:(UIPanGestureRecognizer *)sender{

    CGPoint translatedPoint = [sender translationInView:self.editPhoto];
    
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        _lastTransX = 0.0;
        _lastTransY = 0.0;
    }
     
    //translatedPoint.y
    float imageR = image.size.width/image.size.height;
    CGAffineTransform trans;

    float tempImgX = self.assetImageView.frame.origin.x;
    float tempImgY = self.assetImageView.frame.origin.y;
    
    float tx = translatedPoint.x-_lastTransX;
    float ty = translatedPoint.y-_lastTransY;
    
    if (imageR >=1.0) {
        if (tx > 0) {//right
            if ( tempImgX >-0.2) {
                trans = CGAffineTransformMakeTranslation(0, 0);
                
            }else{
                trans = CGAffineTransformMakeTranslation(tx, 0);
            }
        }else{//left
            if (tempImgX < (0-(self.assetImageView.frame.size.width-self.editPhoto.frame.size.width))) {
                trans = CGAffineTransformMakeTranslation(0, 0);
            }else{
               trans = CGAffineTransformMakeTranslation(tx, 0);
            }
        }
        
    }else{
        if (ty > 0) {//right
            if ( tempImgY >-0.2) {
                trans = CGAffineTransformMakeTranslation(0, 0);
                
            }else{
                trans = CGAffineTransformMakeTranslation(0, ty);
            }
        }else{//left
            if (tempImgY < (0-(self.assetImageView.frame.size.height-self.editPhoto.frame.size.height))) {
                trans = CGAffineTransformMakeTranslation(0, 0);
            }else{
                trans = CGAffineTransformMakeTranslation(0, ty);
            }
        }
    }
    
    CGAffineTransform newTransform = CGAffineTransformConcat(self.assetImageView.transform, trans);
    
    _lastTransX = translatedPoint.x;
    _lastTransY = translatedPoint.y;
    
    self.assetImageView.transform = newTransform;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editFinish:(id)sender {
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    
    [library writeImageToSavedPhotosAlbum:[newImage CGImage] orientation:(ALAssetOrientation)[newImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
          
            NSDictionary *dataDic;
            NSString *index = [NSString stringWithFormat:@"%ld",self.arrayIndex];
            NSString *ef = [NSString stringWithFormat:@"%d",editFlag];
           
            if (editFlag == 0 || editFlag == 1) {//剪切

                dataDic = [[NSDictionary alloc] initWithObjectsAndKeys:self.photoNum.text,@"photoNum",index,@"index",assetURL,@"newAsset",ef,@"editFlat", nil];

            }else{//原图
                dataDic = [[NSDictionary alloc] initWithObjectsAndKeys:self.photoNum.text,@"photoNum",index,@"index",nil,@"newAsset",ef,@"editFlag", nil];
            }
            
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"editPhotoData" object:nil userInfo:dataDic];
            }];
    }];

}

- (IBAction)subPhotoNumBut:(id)sender {
    NSString *photoNum = self.photoNum.text;
    int num = [photoNum intValue];
    if (num > 0) {
        num = num-1;
    }
    self.photoNum.text = [NSString stringWithFormat:@"%d",num];
}

- (IBAction)addPhotoNumBut:(id)sender {
    NSString *photoNum = self.photoNum.text;
    int num = [photoNum intValue];
    self.photoNum.text = [NSString stringWithFormat:@"%d",num+1];
}

- (IBAction)crop:(id)sender {
    float zoomScale = 0.0;
    float _imageScale = 0.0;
    
    if (imageRate > viewRate) {
        zoomScale = [[self.assetImageView.layer valueForKeyPath:@"transform.scale.y"] floatValue];
        _imageScale = image.size.height/originalImageViewSize.height;
    }else{
        zoomScale = [[self.assetImageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        _imageScale = image.size.width/originalImageViewSize.width;
    }
    
    float rotate = [[self.assetImageView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
   
    CGSize cropSize = CGSizeMake(self.editPhoto.frame.size.width/zoomScale, self.editPhoto.frame.size.height/zoomScale);
    CGPoint cropperViewOrigin = CGPointMake((0.0 - self.assetImageView.frame.origin.x)/zoomScale,
                                            (0.0 - self.assetImageView.frame.origin.y)/zoomScale);
 
    CGRect CropRectinImage = CGRectMake((cropperViewOrigin.x*_imageScale) ,( cropperViewOrigin.y*_imageScale), (cropSize.width*_imageScale),(cropSize.height*_imageScale));
    
    UIImage *rotInputImage = [image imageRotatedByRadians:rotate];

    CGImageRef tmp = CGImageCreateWithImageInRect([rotInputImage CGImage], CropRectinImage);

    newImage= [UIImage imageWithCGImage:tmp scale:image.scale orientation:image.imageOrientation];
    
    self.assetImageView.frame = CGRectMake(0, 0, self.editPhoto.frame.size.width, self.editPhoto.frame.size.height);
    self.assetImageView.image = newImage;
     
    editFlag = 0;
    
}

- (IBAction)blank:(id)sender {
    
    [self originalImage];
    
    float editViewRate = self.editPhoto.frame.size.width/self.editPhoto.frame.size.height;
    float nimageRate = image.size.width/image.size.height;
    float scale = 0.0;
    
    
    CGFloat imageViewW = 0.0;
    CGFloat imageViewH = 0.0;
    
    if (nimageRate > editViewRate) {
        imageViewW = self.editPhoto.layer.frame.size.width;
        imageViewH = imageViewW * image.size.height/image.size.width;
        scale =image.size.width/self.editPhoto.frame.size.width;
    }else{
        imageViewH = self.editPhoto.layer.frame.size.height;
        imageViewW = imageViewH * image.size.width/image.size.height;
        scale = image.size.height/self.editPhoto.frame.size.height;
    }
    
    
    CGRect rect = self.assetImageView.layer.frame;
    rect.size.width = self.editPhoto.frame.size.width;
    rect.size.height = self.editPhoto.frame.size.height;
    self.assetImageView.layer.frame = rect;
    
  
    CGSize blankImageSize = CGSizeMake(self.editPhoto.frame.size.width*scale, self.editPhoto.frame.size.height*scale);
    
    UIGraphicsBeginImageContextWithOptions(blankImageSize, YES, [UIScreen mainScreen].scale);
    [[UIColor whiteColor] set];
    UIRectFill(CGRectMake(0, 0, blankImageSize.width, blankImageSize.height));
    UIImage *blankImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(blankImageSize);
    [blankImage drawInRect:CGRectMake(0, 0, blankImageSize.width, blankImageSize.height)];
    
    [image drawInRect:CGRectMake((blankImage.size.width-image.size.width)/2,(blankImage.size.height-image.size.height)/2 , image.size.width, image.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.assetImageView.image = resultImage;
    
    self.assetImageView.center = CGPointMake(self.editPhoto.frame.size.width/2, self.editPhoto.frame.size.height/2);
    newImage = resultImage;
    
    editFlag = 1;
}

- (IBAction)original:(id)sender {
    editFlag = 2;
    [self originalImage];
}

- (void)originalImage{
    newImage = image;
    [self setImageViewWithPhotoSize];
    self.assetImageView.transform = CGAffineTransformIdentity;
}

@end
