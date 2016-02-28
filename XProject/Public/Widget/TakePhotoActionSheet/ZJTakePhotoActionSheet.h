//
//  ZJTakePhotoActionSheet.h
//  Pods
//
//  Created by 何助金 on 8/2/15.
//
//


#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"

@class  ZJTakePhotoActionSheet;
@protocol ZJTakePhotoActionSheetDelegate <NSObject>

@optional

/**
 *  拍照模式
 *
 *  @param actionSheet actionSheet description
 *  @param path        全路径 取单张照片
 */
- (void)takePhotoActionSheet:(ZJTakePhotoActionSheet *)actionSheet didSelectedImageAtPath:(NSString *)path;
/**
 *  多选照片
 *
 *  @param actionSheet actionSheet description
 *  @param arrPaths    文件名 非全路径
 */
- (void)takePhotoActionSheet:(ZJTakePhotoActionSheet *)actionSheet didSelectedImagesPath:(NSMutableArray *)arrPaths;

@end

/**
 *  @author Jason He, 15-09-21
 *
 *  @brief  为了保持状态栏风格统一 在实现的VC实现以下方法

 -(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
 [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
 }
 -(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
 [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
 }
 */

@interface ZJTakePhotoActionSheet : UIActionSheet<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ELCImagePickerControllerDelegate>

@property(nonatomic, weak)UIViewController *owner;
@property(nonatomic,strong)UIColor *tintColor;//导航item文字颜色
@property(nonatomic,strong)UIColor *barTintColor;//导航Bar背景颜色
@property(nonatomic, assign) BOOL allowEdit;
@property (nonatomic, assign) NSInteger maxNumber;//最多可以选照片数量
@property(nonatomic, weak)id<ZJTakePhotoActionSheetDelegate> takePhotoDelegate;

/**
 *  调整照片角度为正常角度
 *
 *  @param aImage 原Image
 *
 *  @return 调整后的Image
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;
/**
 *  调整Image尺寸
 *
 *  @param targetImage
 *
 *  @return
 */
+ (UIImage *)resizeImage:(UIImage *)targetImage;

@end
