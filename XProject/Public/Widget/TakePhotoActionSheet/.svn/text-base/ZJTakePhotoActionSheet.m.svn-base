//
//  ZJTakePhotoActionSheet.m
//  Pods
//
//  Created by 何助金 on 8/2/15.
//
//

#import "ZJTakePhotoActionSheet.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>

@implementation ZJTakePhotoActionSheet

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        /**
         *  @author Jason He, 15-10-15
         *
         *  @brief  语言设置
         */
        
//        NSArray *languages = [NSLocale preferredLanguages];
//        NSString *currentLanguage = [languages objectAtIndex:0];
//        NSLog ( @"%@" , currentLanguage);
//        if([currentLanguage isEqualToString:@"zh-Hant-HK"] || [currentLanguage hasPrefix:@"zh-Hant"])
//        {
//            [self addButtonWithTitle:NSLocalizedString(@"從相冊選擇", nil)];
//            [self addButtonWithTitle:NSLocalizedString(@"拍照", nil)];
//            NSInteger cancleButtonIndex = [self addButtonWithTitle:NSLocalizedString(@"取消", nil)];
//            [self setCancelButtonIndex:cancleButtonIndex];
//
//        }else
//        {
            [self addButtonWithTitle:NSLocalizedString(@"Choose from the album", nil)];
            [self addButtonWithTitle:NSLocalizedString(@"Taking pictures", nil)];
            NSInteger cancleButtonIndex = [self addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
            [self setCancelButtonIndex:cancleButtonIndex];
//        }
        
        self.delegate = self;
        
    }
    
    return self;
}

#pragma -mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self openCameraOrAlbum:NO];
    }else if(buttonIndex == 1)
    {
        [self openCameraOrAlbum:YES];
        
    }
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}


#pragma 打开相机或者相册
- (void)openCameraOrAlbum:(BOOL)camera{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.view.backgroundColor = [UIColor whiteColor];
    if (camera) {
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            picker.mediaTypes = temp_MediaTypes;
        }
        
    }else
    {
        //单选时
        if (_maxNumber <= 1) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
        }else
          //多选
            if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized)
            {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    
                    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
                    //修改导航样式
                    if (_tintColor) {
                        [[elcPicker navigationBar] setTintColor:_tintColor];
                        
                    }
                    if (_barTintColor) {
                        [[elcPicker navigationBar] setBarTintColor:_barTintColor];
                    }
                    // Set the maximum number of images to select to 100
                    elcPicker.maximumImagesCount = _maxNumber;
                    // Only return the fullScreenImage, not the fullResolutionImage
                    elcPicker.returnsOriginalImage = YES;
                    // Return UIimage if YES. If NO, only return asset location information
                    elcPicker.returnsImage = YES;
                    // For multiple image selection, display and return order of selected images
                    elcPicker.onOrder = NO;
                    // Supports image and movie types
                    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage];
                    [elcPicker setImagePickerDelegate:self];
                    [_owner presentViewController:elcPicker
                                        animated:YES
                                      completion:nil];
                    return;
                    
                }
            }
        }

    //修改导航样式
    if (_tintColor) {
        [[picker navigationBar] setTintColor:_tintColor];
        
    }
    if (_barTintColor) {
        [[picker navigationBar] setBarTintColor:_barTintColor];
    }

    picker.delegate = self;
    picker.allowsEditing = _allowEdit;
    [_owner presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        UIImage *image = nil;
        
        if (self.allowEdit) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        //调整图片尺寸
        UIImage *imageToUse = [ZJTakePhotoActionSheet resizeImage:image];
        //调整图片角度
        imageToUse = [ZJTakePhotoActionSheet fixOrientation:imageToUse];
        
        //拍照模式写入相册
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(imageToUse, self,nil,nil);
        }
        
        //使用随机UUID做文件名
        NSString *str = [[NSUUID UUID] UUIDString];
        //去掉“—”
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
        //全部小写
        str = [str lowercaseString];
        
        NSString *fileSuffix = [str substringToIndex:32];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", fileSuffix];
        NSString *imageFile = [documentsDirectory stringByAppendingPathComponent:fileName];
        success = [fileManager fileExistsAtPath:imageFile];
        
        if(success) {
            [fileManager removeItemAtPath:imageFile error:&error];
        }
        
        BOOL writeSuccess = [UIImageJPEGRepresentation(imageToUse, 1.0f) writeToFile:imageFile atomically:YES];
        
        //返回的是全路径 注意按需取 路径 或是 文件名
        if (writeSuccess &&_takePhotoDelegate && [_takePhotoDelegate respondsToSelector:@selector(takePhotoActionSheet:didSelectedImageAtPath:)]) {
                [_takePhotoDelegate takePhotoActionSheet:self didSelectedImageAtPath:imageFile];
        }
    }
    [_owner dismissViewControllerAnimated:YES completion:nil];
}


//取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_owner dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSMutableArray *arrPaths = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto) {
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]) {
                UIImage* image = [dict objectForKey:UIImagePickerControllerOriginalImage];
                
                UIImage *imageToUse = [ZJTakePhotoActionSheet resizeImage:image];
                imageToUse = [ZJTakePhotoActionSheet fixOrientation:imageToUse];
                
                NSString *str = [[NSUUID UUID] UUIDString];
                str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
                str = [str lowercaseString];
                NSString *fileSuffix = [str substringToIndex:32];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", fileSuffix];
                NSString *imageFile = [documentsDirectory stringByAppendingPathComponent:fileName];
                success = [fileManager fileExistsAtPath:imageFile];
                if (success) {
                    [fileManager removeItemAtPath:imageFile error:&error];
                }
                [UIImageJPEGRepresentation(imageToUse, 1.0f) writeToFile:imageFile atomically:YES];
                NSLog(@"Store Image Path : %@", imageFile);
                // 由于iOS新的沙盒防御机制，这里将只存入后段文字名
                [arrPaths addObject:fileName];
            }
        }
    }
    
    if ([_takePhotoDelegate respondsToSelector:@selector(takePhotoActionSheet:didSelectedImagesPath:)]) {
        [_takePhotoDelegate takePhotoActionSheet:self didSelectedImagesPath:arrPaths];
    }
    
    NSLog(@"多图片选取完成");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 照片处理
+ (UIImage *)fixOrientation:(UIImage *)aImage
{
    if (aImage == nil) {
        return nil;
    }
    
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    
    UIImageOrientation orient = aImage.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
        {
            transform = CGAffineTransformIdentity;
            break;
        }
        case UIImageOrientationUpMirrored: //EXIF = 2
        {
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        }
        case UIImageOrientationDown: //EXIF = 3
        {
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        }
        case UIImageOrientationDownMirrored: //EXIF = 4
        {
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        }
        case UIImageOrientationLeftMirrored: //EXIF = 5
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        }
        case UIImageOrientationLeft: //EXIF = 6
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        }
        case UIImageOrientationRightMirrored: //EXIF = 7
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        }
        case UIImageOrientationRight: //EXIF = 8
        {
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        }
        default:
        {
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            break;
        }
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

+ (UIImage *)resizeImage:(UIImage *)targetImage
{
    CGFloat newScale = 1.0;
    // check to see if the image needs to be resized.
    if (targetImage.size.width < targetImage.size.height) {
        if (targetImage.size.height < 1281) {
            return targetImage;
        }
        newScale = 1280 / targetImage.size.height;
    }
    else
    {
        if (targetImage.size.width < 1281) {
            return targetImage;
        }
        newScale = 1280 / targetImage.size.width;
    }
    // reduce size of image
    CGSize size = targetImage.size;
    size.width = size.width * newScale;
    size.height = size.height * newScale;
    UIGraphicsBeginImageContext( size );
    [targetImage drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // return new image
    return newImage;
}

@end
