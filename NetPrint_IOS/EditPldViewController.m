//
//  EditPldViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/8/12.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "EditPldViewController.h"

@interface EditPldViewController (){

    UIImage *bgImage, *editImage,*ratImage,*newImage;

    CGRect imageRegion,editImageField;
    
    CGFloat _lastTransX,_lastTransY;
    
    CGSize originalImageViewSize;
    
    NSInteger rotate;
}

@end

@implementation EditPldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lastTransX = 0.0;
    _lastTransY = 0.0;
    
    [self initImageAsset];
    
    self.editPhotoView.clipsToBounds = NO;
//    self.editPhotoView.layer.borderColor = [UIColor redColor].CGColor;
 //   self.editPhotoView.layer.borderWidth = 0.5;
    
    self.assetView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.editPhotoView.frame.size.width, self.editPhotoView.frame.size.height)];
    self.assetView.userInteractionEnabled = YES;
    [self.editPhotoView addSubview:self.assetView];
    
    
//    self.bgImageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *bgPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
    [bgPan setMinimumNumberOfTouches:1];
    [bgPan setMaximumNumberOfTouches:1];
    [self.editPhotoView addGestureRecognizer:bgPan];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self initBackgroundImage];
    [self initEditPhotoView];
    [self initEditPhoto];
}

- (void) initImageAsset{

    NSInteger order = [self.photoSize.order integerValue];
    
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
            NSLog(@"bgImage is error");
            break;
    }
    
    ALAssetRepresentation *rep = [self.photoAsset defaultRepresentation];
    Byte *buffer = (Byte *)malloc([rep size]);
    NSUInteger buffered = [rep getBytes:buffer fromOffset:0 length:[rep size] error:nil];
    NSData *imageData = [NSData dataWithBytesNoCopy:buffer length:buffered];
    editImage = [UIImage imageWithData:imageData];
    
}


- (void) initBackgroundImage{
    CALayer *bgLayer = [CALayer layer];
    
    CGFloat targetRatio = self.editPhotoView.frame.size.width/self.editPhotoView.frame.size.height;
    CGFloat realRatio = bgImage.size.width/bgImage.size.height;
    
    CGFloat realW = 0.0;
    CGFloat realH = 0.0;
    
    if (realRatio > targetRatio) {
        realW = self.editPhotoView.frame.size.width;
        realH = realW/realRatio;
    }else{
        realH = self.editPhotoView.frame.size.height;
        realW = realH*realRatio;
    }
    
    CGRect rect = self.editPhotoView.frame;
    rect.size = CGSizeMake(round(realW), round(realH));
    self.editPhotoView.frame = rect;
    self.editPhotoView.center = CGPointMake(self.editView.frame.size.width/2,self.editView.frame.size.height/2);
    
    bgLayer.frame = CGRectMake(0, 0, self.editPhotoView.frame.size.width, self.editPhotoView.frame.size.height);
    bgLayer.contents = (id)bgImage.CGImage;
    [self.editPhotoView.layer insertSublayer:bgLayer above:self.assetView.layer];
}

- (void)initEditPhotoView{
    CGFloat targetRatio = imageRegion.size.width/imageRegion.size.height;
    CGFloat realRatio = editImage.size.width/editImage.size.height;
    CGFloat ratio = self.editPhotoView.frame.size.width/bgImage.size.width;
    
    CGFloat realW = 0.0;
    CGFloat realH = 0.0;
 
    if (realRatio<=1) {
        rotate = 0;
        ratImage = editImage;
        if (targetRatio > realRatio) {
            realW = imageRegion.size.width * ratio;
            realH = realW/realRatio;
        }else{
            realH = imageRegion.size.height*ratio;
            realW = realH * realRatio;
        }
    }else{
        //90°
        rotate = 90;
        ratImage  = [UIImage imageWithCGImage:editImage.CGImage scale:1 orientation:UIImageOrientationRight];
        realRatio = 1/realRatio;
        if (targetRatio > realRatio) {
            realW = imageRegion.size.width*ratio;
            realH = realW/realRatio;
        }else{
            realH = imageRegion.size.height * ratio;
            realW = realH * realRatio;
        }
    }
    
    originalImageViewSize = CGSizeMake(realW, realH);
    
    self.assetView.frame=CGRectMake(round(imageRegion.origin.x*ratio), round(imageRegion.origin.y*ratio), round(realW), round(realH));
    
    [self.assetView setImage:ratImage];

 
}

- (void)initEditPhoto{

    CGFloat ratio = self.editPhotoView.frame.size.width/bgImage.size.width;
    CGFloat realW = imageRegion.size.width*ratio;
    CGFloat realH = imageRegion.size.height*ratio;
    CGFloat irX = imageRegion.origin.x*ratio;
    CGFloat irY = imageRegion.origin.y*ratio;
    
    editImageField = CGRectMake(irX, irY, realW, realH);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)moveImage:(UIPanGestureRecognizer *)sender{
    CGPoint translatedPoint = [sender translationInView:self.editView];
    if ([sender state] == UIGestureRecognizerStateBegan) {
        _lastTransX=0.0;
        _lastTransY=0.0;
    }
    
    CGFloat tempY = self.assetView.frame.origin.y;
    
    CGFloat sub = editImageField.size.height+editImageField.origin.y-self.assetView.frame.size.height;
    
    CGFloat ty = translatedPoint.y-_lastTransY;
    
    CGAffineTransform trans;
    if (ty>0) {
        if (tempY >= editImageField.origin.y) {
            trans = CGAffineTransformMakeTranslation(0, 0);
        }else{
            trans = CGAffineTransformMakeTranslation(0, ty);
        }
    }else{
        if (tempY <= sub) {
            trans = CGAffineTransformMakeTranslation(0, 0);
        }else{
            trans = CGAffineTransformMakeTranslation(0, ty);
        }
    }

    CGAffineTransform newTransform = CGAffineTransformConcat(self.assetView.transform, trans);
    _lastTransX = translatedPoint.x;
    _lastTransY = translatedPoint.y;
    
    self.assetView.transform = newTransform;
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

- (IBAction)editPhotoFinish:(id)sender {
    NSString *photoNum = self.setPhotoNumLabel.text;
    
    CGSize size = self.editPhotoView.frame.size;
    CGRect rect = self.assetView.frame;
    NSURL *url = [[self.photoAsset defaultRepresentation]url];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%@",url],@"path",
                         [NSNumber numberWithInteger:size.width],@"width",
                         [NSNumber numberWithInteger:size.height],@"height",
                         [NSNumber numberWithInteger:rect.size.width],@"imageWidth",
                         [NSNumber numberWithInteger:rect.size.height],@"imageHeight",
                         [NSNumber numberWithInteger:rect.origin.x],@"left",
                         [NSNumber numberWithInteger:rect.origin.y],@"top",
                         [NSNumber numberWithBool:NO],@"isEdited",
                         [NSNumber numberWithInteger:1],@"num",
                         [NSNumber numberWithInteger:rotate],@"rotate",
                         [NSNumber numberWithInteger:[self.photoSize.order integerValue]],@"templateId", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *viewDic = [NSDictionary dictionaryWithObjectsAndKeys:photoNum,@"photoNum",[NSString stringWithFormat:@"%ld",self.arrayIndex],@"index",[NSString stringWithFormat:@"%@",url],@"asseturl",jsonString,@"setV", nil];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pldPhotoData" object:nil userInfo:viewDic];
    }];
    
}

- (IBAction)subPhotoNumBut:(id)sender {
    NSString *num = self.setPhotoNumLabel.text;
    if ([@"0" isEqualToString:num]) {
        
    }else{
        NSInteger _num = [num integerValue];
        self.setPhotoNumLabel.text = [NSString stringWithFormat:@"%ld",_num-1];
    }
}

- (IBAction)addPhotoNumBut:(id)sender {
    NSString *num = self.setPhotoNumLabel.text;
    self.setPhotoNumLabel.text = [NSString stringWithFormat:@"%ld",[num integerValue]+1];
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
