//
//  UIUtils.h
//  Guru
//
//  Created by jerry.yao on 15/11/30.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//  UI工具集

#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名
#define vAutomaticDissmissAlertViewShowTime  1.2  //会自动消失弹窗的显示时间

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UIUtils : NSObject
@property (nonatomic, strong) UIAlertView *_automaticDissmissAlertView;   //自动消失弹窗
@property (nonatomic, assign) SEL _theSelector;  //弹窗消失时回调方法
@property (nonatomic, strong) UIImage * _theCaptureScreen;  //截屏图片


/**
 @brief 获取工具集的单例
 */
+(UIUtils *)shared;

#pragma mark ---------------- 主代理获取 -----------------
/**
 @brief 获取主代理对象
 */
- (AppDelegate *)getAppDelegate;


#pragma mark ---------------- 控件封装  -----------------

/**
 *  创建导航条右按钮
 *
 *  @param title     按钮标题
 *  @param obj       按钮作用对象（响应方法的对象）
 *  @param selector  按钮响应的方法
 *  @param imageName 按钮图片名称
 *
 *  @return 右按钮对象
 */
- (UIBarButtonItem *)createRightBarButtonItem:(NSString *)title
                                       target:(id)obj
                                     selector:(SEL)selector
                                    imageName:(NSString*)imageName;

/**
 *  创建导航条左按钮
 *
 *  @param title     按钮标题,当为@""空时，选择默认图片vBackBarButtonItemName
 *  @param obj       按钮作用对象（响应方法的对象）
 *  @param selector  按钮响应的方法
 *  @param imageName 按钮图片名称
 *
 *  @return 左按钮对象
 */
- (UIBarButtonItem *)createLeftBarButtonItem:(NSString *)title
                                      target:(id)obj
                                    selector:(SEL)selector
                                   imageName:(NSString*)imageName;

/**
 *  自定义Lable
 *
 *  @param frame           Frame
 *  @param backgroundColor 背景颜色
 *  @param text            文字内容
 *  @param textColor       文字颜色
 *  @param font            文字大小
 *  @param textAlignment   对齐方式
 *  @param lineBreakMode   换行模式
 *  @param numberOfLines   行数，0表示不限制
 *
 *  @return 自定义Lable
 */
- (UILabel *) getACustomLableFrame: (CGRect) frame
                   backgroundColor: (UIColor *) backgroundColor
                              text: (NSString *) text
                         textColor: (UIColor *) textColor
                              font: (UIFont *) font
                     textAlignment: (NSTextAlignment) textAlignment
                     lineBreakMode: (NSLineBreakMode) lineBreakMode
                     numberOfLines: (int) numberOfLines;

/**
 *  自定义Button，有背景图片
 *
 *  @param fram                           Frame
 *  @param titleNormalColor               按钮标题正常颜色
 *  @param titleHighlightedColor          按钮标题高亮颜色
 *  @param title                          按钮标题文字
 *  @param font                           按钮标题文字大小
 *  @param normalBackgroundImageName      按钮默认背景图片
 *  @param highlightedBackgroundImageName 按钮高亮背景图片
 *  @param accessibilityLabel             标签，可方便相关UI测试找到id
 *
 *  @return 返回自定义按钮
 */
- (UIButton *) getACustomButtonWithBackgroundImage:(CGRect) frame
                                  titleNormalColor: (UIColor *) titleNormalColor
                             titleHighlightedColor: (UIColor *) titleHighlightedColor
                                             title: (NSString *) title
                                              font: (UIFont *) font
                         normalBackgroundImageName: (NSString *) normalBackgroundImageName
                    highlightedBackgroundImageName: (NSString *) highlightedBackgroundImageName
                                accessibilityLabel: (NSString *) accessibilityLabel;

/**
 *  自定义Button,无背景图片
 *
 *  @param frame                  Frame
 *  @param backgroudColor        背景颜色
 *  @param titleNormalColor      按钮标题正常颜色
 *  @param titleHighlightedColor 按钮标题高亮颜色
 *  @param title                 按钮标题文字
 *  @param font                  按钮标题文字大小
 *  @param cornerRadius          按钮外围角度
 *  @param borderWidth           按钮外围线宽度
 *  @param borderColor           按钮颜色
 *  @param accessibilityLabel    标签，可方便相关UI测试找到id
 *
 *  @return 返回自定义按钮
 */
- (UIButton *) getACustomButtonNoBackgroundImage:(CGRect) frame
                                  backgroudColor: (UIColor *) backgroudColor
                                titleNormalColor: (UIColor *) titleNormalColor
                           titleHighlightedColor: (UIColor *) titleHighlightedColor
                                           title: (NSString *) title
                                            font: (UIFont *) font
                                    cornerRadius: (CGFloat ) cornerRadius
                                     borderWidth: (CGFloat) borderWidth
                                     borderColor: (CGColorRef ) borderColor
                              accessibilityLabel: (NSString *) accessibilityLabel;

/**
 *   自定义TextFiled
 *
 *  @param frame              Frame
 *  @param backgroundColor    背景颜色
 *  @param placeholder        占位文字
 *  @param textColor          输入文字颜色
 *  @param font               输入文字大小
 *  @param borderStyle        输入框样式
 *  @param textAlignment      文字对齐方式
 *  @param accessibilityLabel 标签，可方便相关UI测试找到id
 *  @param autocorrectionType 自动更正功能样式
 *  @param clearButtonMode    清除按钮模式
 *  @param tag                tag
 *  @param isPassword         是否是密码输入框
 *
 *  @return 返回自定义输入框
 */
- (UITextField *) getACustomTextFiledFrame: (CGRect) frame
                           backgroundColor: (UIColor *)backgroundColor
                               placeholder: (NSString *) placeholder
                                 textColor: (UIColor *) textColor
                                      font: (UIFont *) font
                               borderStyle:(UITextBorderStyle) borderStyle
                             textAlignment: (NSTextAlignment) textAlignment
                        accessibilityLabel: (NSString *) accessibilityLabel
                        autocorrectionType: (UITextAutocorrectionType) autocorrectionType
                           clearButtonMode: (UITextFieldViewMode) clearButtonMode
                                       tag: (NSInteger) tag
                            withIsPassword: (BOOL) isPassword;

/**
 *  进一步定制化-左侧添加包含PaddingView的输入框(填充图片或文字)
 *
 *  @param frame           Frame
 *  @param placeholder     占位文字
 *  @param tag             tag
 *  @param imageName       左侧填充图片名，如非图片设置为空：@"",与paddingViewText优先选择paddingViewText
 *  @param zoomNumber      图片缩放比例  默认为1.0
 *  @param borderStyle     输入框样式
 *  @param keyboardType    键盘样式
 *  @param delegate        代理对象
 *  @param isPassword      是否是密码输入框
 *  @param paddingViewText 左侧填充文字，为空时才选择imageName
 *  @param returnKeyType   键盘Return按钮样式
 *
 *  @return 进一步定制化的输入框
 */
- (UITextField *) getACustomTextFiledWithFrame: (CGRect) frame
                               withPlaceholder: (NSString *) placeholder
                                       withTag: (NSInteger) tag
                             withLeftImaegName: (NSString *) imageName
                                      withZoom: (float) zoomNumber
                               withBorderStyle:(UITextBorderStyle)borderStyle
                              withKeyboardType: (UIKeyboardType) keyboardType
                                    toDelegate: (UIViewController<UITextFieldDelegate> *) delegate
                                withIsPassword: (BOOL) isPassword
                           withPaddingViewText: (NSString *) paddingViewText
                             withReturnKeyType: (UIReturnKeyType) returnKeyType;

/**
 *  自定义UIImageView
 *
 *  @param center        中心位置
 *  @param imageName     图片名字
 *  @param imageZoomSize 图片缩放比例  默认为1.0
 *
 *  @return 自定义UIImageView
 */
- (UIImageView *) getACustomImageViewWithCenter: (CGPoint) center
                                  withImageName: (NSString *) imageName
                              withImageZoomSize: (CGFloat) imageZoomSize;

- (UIImageView *) getACustomImageViewWithrect: (CGRect) rect
                                withImageName: (NSString *) imageName
                                 cornerRadius: (CGFloat ) cornerRadius
                                  borderWidth: (CGFloat) borderWidth
                                  borderColor: (CGColorRef ) borderColor;

/**
 *  弹出一个会自动消失和弹窗
 *
 *  @param title        标题
 *  @param message      提示信息
 *  @param dissmisstime 消失等待时间
 */
- (void) showAlertViewAndDissmissAutomatic: (NSString*) title
                                andMessage: (NSString *) message
                          withDissmissTime: (CGFloat) dissmisstime
                              withDelegate:(UIViewController<UIAlertViewDelegate> *) delegate
                                withAction: (SEL) selector;

/**
 *  放置URL图片至view或button上，在此之前取磁盘图片
 *
 *  @param urlImage         图片url地址
 *  @param placeholderImage placeholderImage,如果为nil 或空，就设置为默认holder图片
 *  @param imageView        要设置此图片的view
 *  @param button           要设置此图片的button
 */
- (void) setURLImage:(NSString*)urlImage placeholderImage:(NSString*)placeholderImage imageView:(UIImageView*)imageView orButton:(UIButton *) button;

/**
 *  显示分隔视图
 *
 *  @param frame        Frame
 *  @param lineColor      边框线颜色
 *   @param backgroudColor 背景颜色
 */
- (UIView*)showSeparateView:(CGRect) frame lineColor : (UIColor*)lineColor backgroudColor:(UIColor*)backgroudColor;

/**
 *  设置UIlable的行距
 *
 *  @param lable       要设置行距的lable对象
 *  @param lableString lable显示的字符串
 *  @param lineSpacing 要设置的行距高度
 */
- (void) setLableLineSpacing:(UILabel *) lable
             withLableString:(NSString *) lableString
             withLineSpacing: (NSInteger) lineSpacing;

/**
 *  设置lable自适应，改变bounds(可以限定宽高的边界),通常设置完后要重新设置位置
 *
 *  @param theLable                  要设置自适应的lable对像
 *  @param maxWidth                  宽度最大值， 为0时不指定
 *  @param minWidth                  宽度最小值， 为0时不指定
 *  @param maxHeight                 高度最大值， 为0时不指定
 *  @param minHeight                 高度最小值， 为0时不指定
 *  @param adjustsFontSizeToFitWidth 是否字体根据宽度自动适应变化尺寸
 */
- (void) setLableSizeToFit:(UILabel *) theLable
              withMaxWidth:(CGFloat) maxWidth
              withminWidth:(CGFloat) minWidth
             withMaxHeight: (CGFloat ) maxHeight
             withminHeight:(CGFloat) minHeight
        withFontToFitWidth: (BOOL) adjustsFontSizeToFitWidth;

/**
 *  添加加载圈
 */
- (void) addLoading;

/**
 *  影藏加载圈
 */
- (void) dissmissLoading;

#pragma mark ---------------- 数据持久化 ---缓存数据plist读、写、清除(个人信息数据)，文件存储等-----------------

/**
 *  写入一条数据到plist文件(个人信息数据)
 *
 *  @param object 写入的对象
 *  @param key    写入对象的key
 *
 *  @return YES:写入成功，NO:写入失败
 */
- (BOOL)setobject:(id )object forKey:(NSString *)key;

/**
 @brief   从plist文件读取某条个人信息数据
 @param     key     读取对象的key
 @result        读取得到的对象
 */
- (id)objectForKey:(NSString *)key;

/**
 @brief 从plist文件清除某条个人信息数据
 @param key 清除对象的key
 */
- (void)removeObjectForKey:(NSString *)key;


#pragma mark ---------------- URL提取-----------------
/**
 @brief 根据接口名从urls.plist文件获取完整url
 @param serverInterfaceName url的接口名
 @result NSString 获取到的完整url，如果为空字符串代表接口名错误或plist文件配置错误
 */
- (NSString *)getUrlsFromPlistFile: (NSString *)serverInterfaceName;

/**
 @brief  从urls.plist文件获取服务器url（不带接口）
 @result NSString 获取到的服务器url
 */
- (NSString *)getServerAdderss;


#pragma mark ---------------- 格式校验 -----------------
/**
 *  密码校验
 *
 *  @param numString 待校验的密码
 *
 *  @return 校验结果，YES：合格， NO：密码格式不正确
 */
- (BOOL)checkPassword:(NSString *)numString;

/**
 *  邮箱校验
 *
 *  @param str2validate 待校验的邮箱
 *
 *  @return 校验结果，YES：合格， NO：邮箱格式不正确
 */
- (BOOL)checkEmail:(NSString *)str2validate;

/**
 *  手机号码简单校验并用UIAlertView提示
 *
 *  @param phoneNumberString 等校验的手机号码
 *
 *  @return 校验结果，YES：合格， NO：手机号码格式不正确
 */
- (BOOL) checkPhoneNumberAndShowAlert: (NSString *) phoneNumberString;


/**
 *  手机号码或者邮箱号码校验
 *
 *  @param numberOrEmailString 待校验的用户名（可能为手机号码或者邮箱号码）
 *
 *  @return 校验结果，YES：合格， NO：手机号码格式及邮箱格式均不正确
 */
- (BOOL)checkPhoneNumberOrEmail: (NSString *) numberOrEmailString;

#pragma mark ---------------- 截屏 -----------------
/**
 *  截屏
 *
 *  @return 返回截取得到的图片
 */
- (UIImage *) captureScreen;


#pragma mark ---------------- GUID -----------------
/**
 * 生成一个几乎不可能重复GUID
 */
- (NSString *) generateUuidString;

#pragma mark ---------------- 摄像头和相册相关的公共类 -----------------
/**
 *  判断设备是否有摄像头
 *
 *  @return YES:有摄像头，NO:没摄像头
 */
- (BOOL) isCameraAvailable;


#pragma mark ---------------- location相关 -----------------
/**
 *  更新地理位置（只更新一次，更新后停止定位，请在通知中获取定位信息）
 */
//- (void)updateLocation;


#pragma mark ---------------- TableView相关 -----------------

/**
 *  隐藏tableview cell多余的分隔线
 *
 *  @param tableView 需要隐藏分割线的tableView
 */
-(void)setExtraSeparatorHidden: (UITableView *)tableView;


#pragma mark ---------------- 缓存处理 -----------------
/**
 *  获取缓存大小（带单位）
 *
 *  @return 缓存大小（带单位）, 单位 M，小于1M用kb
 */
- (NSString *) getCacheSize;

/**
 *  获取指定缓存文件路径
 *
 *  @param appendPath 指定子路径，为空或Nil时返回整个缓存文件夹大小
 *
 *  @return 指定缓存文件路径
 */
- (NSString *) getCachesPathWithAppendPath: (NSString *) appendPath;

/**
 *  清理指定类型的指定路径文件(NSHomeDirectory 目录下)
 *
 *  @param fullPath 指定全路径，如果为空或者nil，表示整个NSDocumentDirectory
 *  @param extension  指定文件类型如 m4r,如果为空或者nil,表示删除所有文件
 */
- (void) clearFileWithPath: (NSString *) fullPath withExtension: (NSString *) extension;

#pragma mark ---------------- 版本相关 -----------------
/**
 *  获取当前App版本号
 *
 *  @return 返回版本号字符串
 */
- (NSString *) getAppNowVersion;

/**
 *  @author Jerry.Yao, 15-12-04
 *
 *  计算文字宽高
 *
 *  @param str  文字字符串
 *  @param size 要计算的宽高
 *  @param font 要计算的字体
 *
 *  @return 计算好的size
 */
- (CGSize)calculateWithStr:(NSString *)str andSize:(CGSize)size andFont:(UIFont *)font;

/**
 *  设置行间距
 *
 *  @param spacing 行间距大小
 *  @param label   要设置的label
 */
- (void)setLineSpacing:(CGFloat)spacing withLabel:(UILabel *)label;

/**
 *  自定义一根线条
 *
 *  @param frame <#frame description#>
 *  @param color <#color description#>
 */
- (UIView *)createLineViewWitFrame:(CGRect)frame andColor:(UIColor *)color;

/**
 *  显示小菊花加载中...
 *
 *  @param isShow    是否显示菊花
 *  @param superView 菊花要显示的父View
 */
- (void)showActivityIndicatorLoading:(BOOL)isShow inView:(UIView *)superView;


@end

