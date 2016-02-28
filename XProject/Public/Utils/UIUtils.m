//
//  UIUtils.m
//  Guru
//
//  Created by jerry.yao on 15/11/30.
//  Copyright (c) 2015年 com.ylj.dev. All rights reserved.
//

#import "UIUtils.h"
#import "GlobalConstants.h"

@interface UIUtils()
{
    
}

@end

static UIUtils *_tools = nil;

@implementation UIUtils

/**
 @brief 获取工具集的单例
 */
+(UIUtils *)shared
{
    @synchronized(self)
    {
        if (_tools == nil) {
            _tools = [[UIUtils alloc] init];
            
        }
        return _tools;
    }
}

#pragma mark ---------------- 主代理等对象获取 -----------------
/**
 @brief 获取主代理对象
 */
- (AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


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
- (UIBarButtonItem *)createRightBarButtonItem:(NSString *)title target:(id)obj selector:(SEL)selector imageName:(NSString*)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton setTitle:title forState:UIControlStateNormal];
    //    leftButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    //    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [leftButton addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    
    //iOS7之前的版本需要手动设置和屏幕边缘的间距
    if (kIOSVersions < 7.0) {
        leftButton.frame = CGRectInset(leftButton.frame, -10, 0);
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return item;
}

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
- (UIBarButtonItem *)createLeftBarButtonItem:(NSString *)title target:(id)obj selector:(SEL)selector imageName:(NSString*)imageName
{
    UIImage *image;
    if ([NSString isNilOrEmpty:imageName ])
    {
        image = [UIImage imageScaleNamed:vBackBarButtonItemName];
    }
    else
    {
        image = [UIImage imageScaleNamed:imageName];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    
    if ([title isEqualToString:@"返回"]) {
        title = @"    ";
    }
    if ([title length] > 0) {
        [button setTitle:title forState:UIControlStateNormal];
    }else{
        
    }
    //ios8.0 此方法过时，用下面的方法替代---
    //    CGSize titleSize = [title sizeWithAttributes:[UIFont systemFontOfSize:18]];
    
    UIFont *fnt = [UIFont systemFontOfSize:18];
    // 根据字体得到NSString的尺寸
    CGSize titleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    //----------
    
    if (titleSize.width < 44) {
        titleSize.width = 44;
    }
    button.frame = CGRectMake(0, 0, titleSize.width, 44);
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:130.0/255 green:56.0/255 blue:23.0/255 alpha:1] forState:UIControlStateHighlighted];
    [button addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    //    CGPoint tempCenter = button.center;
    //    //图片尺寸不对时，用默认参数进行缩放
    //    [button setFrame:CGRectMake(0, 0, image.size.width / kAllImageZoomSize, image.size.height / kAllImageZoomSize)];
    //    [button setCenter:tempCenter];
    
    //iOS7之前的版本需要手动设置和屏幕边缘的间距
    if (kIOSVersions < 7.0) {
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

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
                              accessibilityLabel: (NSString *) accessibilityLabel
{
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = frame;
    customButton.backgroundColor = backgroudColor;
    [customButton setTitleColor:titleNormalColor forState:UIControlStateNormal];
    [customButton setTitleColor:titleNormalColor forState:UIControlStateHighlighted];
    [customButton setTitle:title forState:UIControlStateNormal];
    if (titleHighlightedColor != nil)
    {
        [customButton setTitleColor:titleHighlightedColor forState:UIControlStateHighlighted];
    }
    
    customButton.titleLabel.font = font;
    if (cornerRadius)
    {
        customButton.layer.cornerRadius = cornerRadius;
    }
    if (borderWidth)
    {
        customButton.layer.borderWidth = borderWidth;
        customButton.layer.borderColor = borderColor;
    }
    if (accessibilityLabel != nil)
    {
        customButton.accessibilityLabel = accessibilityLabel; //标签，可方便相关UI测试找到id
    }
    
    return customButton;
}

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
                                accessibilityLabel: (NSString *) accessibilityLabel
{
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = frame;
    [customButton setTitle:title forState:UIControlStateNormal];
    [customButton setTitle:title forState:UIControlStateHighlighted];
    [customButton setTitleColor:titleNormalColor forState:UIControlStateNormal];
    if (titleHighlightedColor)
    {
        [customButton setTitleColor:titleHighlightedColor forState:UIControlStateHighlighted];
    }
    customButton.titleLabel.font = font;
    [customButton setBackgroundImage:[UIImage imageNamed:normalBackgroundImageName] forState:UIControlStateNormal];  //设置成backimage才能在上面添加文字
    if (highlightedBackgroundImageName)
    {
        [customButton setBackgroundImage:[UIImage imageNamed:highlightedBackgroundImageName] forState:UIControlStateHighlighted];
    }
    if (accessibilityLabel != nil)
    {
        customButton.accessibilityLabel = accessibilityLabel; //标签，可方便相关UI测试找到id
    }
    return customButton;
}

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
- (UILabel *) getACustomLableFrame: (CGRect) frame backgroundColor: (UIColor *) backgroundColor text: (NSString *) text textColor: (UIColor *) textColor font: (UIFont *) font textAlignment: (NSTextAlignment) textAlignment lineBreakMode: (NSLineBreakMode) lineBreakMode numberOfLines: (int) numberOfLines
{
    UILabel *customLable = [[UILabel alloc] initWithFrame:frame];
    if (backgroundColor != nil)
    {
        customLable.backgroundColor = backgroundColor;
    }
    customLable.text = text;
    if (textColor != nil)
    {
        customLable.textColor = textColor;
    }
    customLable.font = font;
    if (textAlignment)
    {
        customLable.textAlignment = textAlignment;
    }
    //    if (lineBreakMode)
    {
        customLable.lineBreakMode = lineBreakMode;
    }
    //    if (numberOfLines)
    {
        customLable.numberOfLines = numberOfLines;
    }
    
    return customLable;
}

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
                            withIsPassword: (BOOL) isPassword
{
    UITextField *customTextFiled;
    if (isPassword)
    {
        customTextFiled = [[NoPasteTextField alloc] initWithFrame:frame];
        customTextFiled.secureTextEntry = YES;
    }
    else
    {
        customTextFiled = [[UITextField alloc] initWithFrame:frame];
    }
    if (textColor != nil)
    {
        [customTextFiled setTextColor:textColor];
    }
    if (backgroundColor != nil)
    {
        customTextFiled.backgroundColor = backgroundColor;
    }
    if (placeholder != nil)
    {
        customTextFiled.placeholder = placeholder;
    }
    if (font != nil)
    {
        customTextFiled.font = font;
    }
    if (borderStyle)  //如果是nil得自己设置背景框
    {
        customTextFiled.borderStyle = borderStyle;
    }
    if (textAlignment)
    {
        customTextFiled.textAlignment = textAlignment;  //内容对齐方式
    }
    if (accessibilityLabel != nil)
    {
        customTextFiled.accessibilityLabel = accessibilityLabel; //标签，可方便相关UI测试找到id
    }
    if (autocorrectionType)
    {
        customTextFiled.autocorrectionType = autocorrectionType; //是否自动使用iphone更正功能
    }
    if (clearButtonMode)
    {
        customTextFiled.clearButtonMode = clearButtonMode;      //清空按钮样式
    }
    if (tag)
    {
        customTextFiled.tag = tag;
    }
    
    return customTextFiled;
}

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
                             withReturnKeyType: (UIReturnKeyType) returnKeyType
{
    UITextField *theTextField = [[UIUtils shared] getACustomTextFiledFrame:frame backgroundColor:kRGB(234.0, 234.0, 234.0) placeholder:placeholder  textColor:[UIColor blackColor] font:kFont(16) borderStyle:borderStyle textAlignment:NSTextAlignmentLeft accessibilityLabel:@"did not need this" autocorrectionType:UITextAutocorrectionTypeNo clearButtonMode:UITextFieldViewModeWhileEditing tag:tag withIsPassword:isPassword];
    theTextField.keyboardType = keyboardType;
    
    kViewInCenter(theTextField);
    //设置placeHold字体颜色
    UIColor *tempColor = kHoldPlacerColor;
    theTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: tempColor}];
    
    if (![NSString isNilOrEmpty:paddingViewText ])
    {
        [self getAPaddingView:theTextField withPaddingViewText:paddingViewText];
    }
    else if (![NSString isNilOrEmpty:imageName ])
    {
        [self getAPaddingView:theTextField withImage:imageName withZoomNumber:zoomNumber];
    }
    
    theTextField.delegate = delegate;
    theTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    theTextField.returnKeyType = returnKeyType;
    
    return theTextField;
}

//返回textfield的PaddingView（包含图标）
- (UIView *) getAPaddingView: (UITextField *) theTextField withImage: (NSString *) imageName withZoomNumber: (float) zoomNumber
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, theTextField.frame.size.height)];
    theTextField.leftView = paddingView;
    theTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(3, 10, theTextField.frame.size.height / 2.0, theTextField.frame.size.height / 2.0)];
    UIImage *tempImage = [UIImage imageNamed:imageName];
    if (zoomNumber)
    {
        [icon setFrame:CGRectMake(3, 10, tempImage.size.width / zoomNumber, tempImage.size.height / zoomNumber)];   //自动适配
    }
    icon.image =[UIImage imageNamed:imageName];
    [paddingView addSubview: icon];
    icon.center = CGPointMake(paddingView.frame.size.width / 2.0, icon.center.y);
    
    return paddingView;
}

//返回textfield的PaddingView（包含文字和分隔竖线）
- (UIView *) getAPaddingView: (UITextField *) theTextField withPaddingViewText: (NSString *) text
{
    //paddingView
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, theTextField.frame.size.height)];
    theTextField.leftView = paddingView;
    theTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *paddingLabel = [self getACustomLableFrame:paddingView.frame backgroundColor:[UIColor clearColor] text:text textColor:kRGB(40.0, 47.0, 56.0) font:kFont(16) textAlignment:NSTextAlignmentCenter lineBreakMode:0 numberOfLines:0];
    
    [paddingView addSubview:paddingLabel];
    paddingLabel.center = CGPointMake(paddingView.frame.size.width / 2.0, paddingLabel.center.y);
    
    //竖线
    UIView *aLine = [[UIView alloc] initWithFrame:CGRectMake(paddingLabel.right, 12.0 , 1.0 , theTextField.height - 12.0 * 2)];
    [aLine setBackgroundColor: kHoldPlacerColor];
    [paddingView addSubview:aLine];
    
    return paddingView;
}

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
                              withImageZoomSize: (CGFloat) imageZoomSize
{
    CGFloat zoomsize = 1.0;
    UIImage *theImage = [UIImage imageNamed:imageName];
    if (imageZoomSize)
    {
        zoomsize = imageZoomSize;
    }
    UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, theImage.size.width / zoomsize, theImage.size.height / zoomsize)];
    theImageView.image = theImage;
    theImageView.center = center;
    
    return theImageView;
}

- (UIImageView *) getACustomImageViewWithrect: (CGRect) rect
                                withImageName: (NSString *) imageName
                                 cornerRadius: (CGFloat ) cornerRadius
                                  borderWidth: (CGFloat) borderWidth
                                  borderColor: (CGColorRef ) borderColor{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    imageView.image = [UIImage imageNamed:imageName];
    
    if (cornerRadius)
    {
        imageView.layer.cornerRadius = cornerRadius;
        imageView.layer.masksToBounds = YES;
        
    }
    if (borderWidth)
    {
        imageView.layer.borderWidth = borderWidth;
        imageView.layer.borderColor = borderColor;
        imageView.layer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return imageView;
}
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
                                withAction: (SEL) selector
{
    dispatch_async(dispatch_get_main_queue() , ^{
        self._automaticDissmissAlertView = [[UIAlertView alloc] init];
        self._automaticDissmissAlertView.title = title;
        self._automaticDissmissAlertView.delegate = delegate;
        self._automaticDissmissAlertView.message = message;
        [self._automaticDissmissAlertView show];
        self._theSelector = selector;
        [NSTimer scheduledTimerWithTimeInterval:dissmisstime target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    });
}

//自动消失
- (void) performDismiss:(NSTimer *)timer
{
    [self._automaticDissmissAlertView dismissWithClickedButtonIndex:0 animated:YES];
    
    if ((self._theSelector) && (self._automaticDissmissAlertView.delegate))
    {
        if ([self._automaticDissmissAlertView.delegate respondsToSelector:self._theSelector]) {
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self._automaticDissmissAlertView.delegate performSelector:self._theSelector withObject:nil];
#pragma clang diagnostic pop
        }
    }
    //    self._automaticDissmissAlertView = nil;
    //    self._theSelector = nil;
}

/**
 *  添加加载圈
 */
- (void) addLoading
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    //    dispatch_async(dispatch_get_main_queue() , ^{
    //加载圈
    //        [MBProgressHUD showHUDAddedTo:kUIWindow animated:YES];
    
    //  });
}

/**
 *  影藏加载圈
 */
- (void) dissmissLoading
{
    [SVProgressHUD dismiss];
    //    dispatch_async(dispatch_get_main_queue() , ^{
    //影藏加载圈
    //        [MBProgressHUD hideAllHUDsForView:kUIWindow animated:YES];
    
    //    });
}

/**
 *  放置URL图片至view或button上，在此之前取磁盘图片
 *
 *  @param urlImage         图片url地址
 *  @param placeholderImage placeholderImage,如果为nil 或空，就设置为默认holder图片
 *  @param imageView        要设置此图片的view
 *  @param button           要设置此图片的button
 */
- (void) setURLImage:(NSString*)urlImage placeholderImage:(NSString*)placeholderImage imageView:(UIImageView*)imageView orButton:(UIButton *) button
{
    [self setURLImage:urlImage placeholderImage:placeholderImage imageView:imageView orButton:button needGetFromDiskCache:YES];
}

/**
 *  放置URL图片至view或button上，在此之前取磁盘图片
 *
 *  @param urlImage         图片url地址
 *  @param placeholderImage placeholderImage,如果为nil 或空，就设置为默认holder图片
 *  @param imageView        要设置此图片的view
 *  @param button           要设置此图片的button
 *  @param needGetFromDiskCache  是否优先从默认的磁盘读取图片
 */
- (void) setURLImage:(NSString*)urlImage placeholderImage:(NSString*)placeholderImage imageView:(UIImageView*)imageView orButton:(UIButton *) button needGetFromDiskCache: (BOOL) needGetFromDiskCache
{
    
    //从本地磁盘取图片
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlImage];
    if (needGetFromDiskCache && image)
    {
        if (imageView)
        {
            [imageView setImage:image];
        }
        else
        {
            [button setImage:image forState:UIControlStateNormal];
        }
    }
    else
    {
        NSString *placeholderImageDefautl = kDefaultPlaceholderImage;
        if (![NSString isNilOrEmpty:placeholderImage ]) {
            placeholderImageDefautl = placeholderImage;
        }
        if (imageView)
        {
            MBProgressHUD *__block tempHUD = [MBProgressHUD showHUDAddedTo:imageView animated:YES];
            //            tempHUD.mode = MBProgressHUDModeAnnularDeterminate;
            tempHUD.color = [UIColor clearColor];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlImage] placeholderImage:[UIImage imageNamed:placeholderImageDefautl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                [tempHUD hide:YES];
                tempHUD = nil;
                if (cacheType == SDImageCacheTypeNone)
                {
                    [[SDImageCache sharedImageCache] storeImage:image forKey:urlImage toDisk:YES];
                }
                [imageView setImage:image];
            }];
        }
        else
        {
            MBProgressHUD *__block tempHUD = [MBProgressHUD showHUDAddedTo:button animated:YES];
            //            tempHUD.mode = MBProgressHUDModeAnnularDeterminate;
            tempHUD.color = [UIColor clearColor];
            [button sd_setImageWithURL:[NSURL URLWithString:urlImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:placeholderImageDefautl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [tempHUD hide:YES];
                tempHUD = nil;
                if (cacheType == SDImageCacheTypeNone)
                {
                    [[SDImageCache sharedImageCache] storeImage:image forKey:urlImage toDisk:YES];
                }
                [button setImage:image forState:UIControlStateNormal];
            }];
        }
    }
}

/**
 *  显示分隔视图
 *
 *  @param frame        Frame
 *  @param lineColor      边框线颜色
 */
- (UIView*)showSeparateView:(CGRect) frame lineColor : (UIColor*)lineColor backgroudColor:(UIColor*)backgroudColor
{
    UIView *separateView = [[UIView alloc] initWithFrame:frame];
    [separateView setBackgroundColor:backgroudColor];
    
    CGRect lineRect = CGRectZero;
    lineRect.origin.x = 0.0;
    lineRect.origin.y = 0.0;
    lineRect.size.width = frame.size.width;
    lineRect.size.height = 1.0;
    UIView *lineTopView = [[UIView alloc] initWithFrame:lineRect];
    [lineTopView setBackgroundColor:lineColor];
    lineRect.origin.y = frame.size.height-1.0;
    UIView *lineBottomView = [[UIView alloc] initWithFrame:lineRect];
    [lineBottomView setBackgroundColor:lineColor];
    
    [separateView addSubview:lineTopView];
    [separateView addSubview:lineBottomView];
    
    return separateView;
}

/**
 *  设置UIlable的行距
 *
 *  @param lable       要设置行距的lable对象
 *  @param lableString lable显示的字符串
 *  @param lineSpacing 要设置的行距高度
 */
- (void) setLableLineSpacing:(UILabel *) lable
             withLableString:(NSString *) lableString
             withLineSpacing: (NSInteger) lineSpacing
{
    if ([NSString isNilOrEmpty:lableString ])
    {
        return;
    }
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:lableString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:lineSpacing];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [lableString length])];
    [lable setAttributedText:attributedString1];
    //    [lable sizeToFit];
}

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
        withFontToFitWidth: (BOOL) adjustsFontSizeToFitWidth
{
    CGSize frameSize = [theLable.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:theLable.font, NSFontAttributeName, nil]];
    if (maxWidth && frameSize.width > maxWidth)
    {
        frameSize.width = maxWidth;
    }
    if (minWidth && frameSize.width < minWidth)
    {
        frameSize.width = minWidth;
    }
    if (maxHeight && frameSize.height > maxHeight)
    {
        frameSize.height = maxHeight;
    }
    if (minHeight && frameSize.height < minHeight)
    {
        frameSize.height = minHeight;
    }
    [theLable setAdjustsFontSizeToFitWidth:adjustsFontSizeToFitWidth];
    [theLable setWidth:frameSize.width];
    [theLable setHeight:frameSize.height];
}

#pragma mark ---------------- 缓存数据plist读、写、清除(个人信息数据)-----------------
/**
 *  写入一条数据到plist文件(个人信息数据)
 *
 *  @param object 写入的对象
 *  @param key    写入对象的key
 *
 *  @return YES:写入成功，NO:写入失败
 */
- (BOOL)setobject:(id )object forKey:(NSString *)key
{
    BOOL success = NO;
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pPath = [NSString stringWithFormat:@"%@/Userdefault.plist",docDir];
    NSLog(@"****path = %@", pPath);
    NSMutableDictionary *plistDictionary = (NSMutableDictionary *)[NSMutableDictionary dictionaryWithContentsOfFile:pPath];
    if (!plistDictionary)
    {
        plistDictionary = [NSMutableDictionary dictionary];
    }
    [plistDictionary setValue:object forKey:key];
    if (key && object)
    {
        if ([plistDictionary writeToFile:pPath atomically:YES])
        {
            success = YES;
        }
    }
    return success;
}

/**
 @brief 从plist文件读取某条个人信息数据
 @param key 读取对象的key
 @result id 读取得到的对象
 */
- (id)objectForKey:(NSString *)key
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pPath = [NSString stringWithFormat:@"%@/Userdefault.plist",docDir];
    NSLog(@"****path = %@", pPath);
    NSDictionary *arrayData = [NSDictionary dictionaryWithContentsOfFile:pPath];
    NSArray *keys = [arrayData allKeys];
    for (NSString *tempKey in keys)
    {
        if ([tempKey isEqualToString:key])
        {
            return [arrayData objectForKey:key];
        }
    }
    return nil;
}

/**
 @brief 从plist文件清除某条个人信息数据
 @param key 清除对象的key
 */
- (void)removeObjectForKey:(NSString *)key
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pPath = [NSString stringWithFormat:@"%@/Userdefault.plist",docDir];
    NSMutableDictionary *arrayData = [NSMutableDictionary dictionaryWithContentsOfFile:pPath];
    NSArray *keys = [arrayData allKeys];
    for (NSString *tempKey in keys)
    {
        if ([tempKey isEqualToString:key])
        {
            [arrayData removeObjectForKey:key];
        }
    }
    [arrayData writeToFile:pPath atomically:YES];
}


#pragma mark ---------------- URL提取-----------------
/**
 @brief 根据接口名从urls.plist文件获取完整url
 @param serverInterfaceName url的接口名
 @result NSString 获取到的完整url，如果为空字符串代表接口名错误或plist文件配置错误
 */
- (NSString *)getUrlsFromPlistFile: (NSString *)serverInterfaceName
{
    /*
     NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Urls.plist"];
     
     NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
     NSString *urlKey = (NSString*)[data objectForKey:@"MS_ENVIRONMENT"];
     
     NSDictionary *serverAdderssDic = [data objectForKey:@"serverAddress"];
     NSDictionary *serverInterfaceDic = [data objectForKey:@"serverInterface"];
     NSString *urlFullAdderss = @"";
     
     if ([serverAdderssDic objectForKey:urlKey])
     {
     urlFullAdderss = [serverAdderssDic objectForKey:urlKey];
     }
     
     NSDictionary *interfaceUrl = [serverInterfaceDic objectForKey:serverInterfaceName];
     if ([interfaceUrl objectForKey:urlKey])
     {
     NSString *interfaceUrlString = [interfaceUrl objectForKey:urlKey];
     if ([interfaceUrlString hasPrefix:@"http"])
     {
     NSLog(@"get the fullUrl path: %@", interfaceUrlString);
     return interfaceUrlString;
     }
     urlFullAdderss = [NSString stringWithFormat:@"%@%@", urlFullAdderss, interfaceUrlString];
     }
     NSLog(@"get the fullUrl path: %@", urlFullAdderss);
     
     //去掉空格，防止url出错
     urlFullAdderss = [urlFullAdderss stringByReplacingOccurrencesOfString:@" " withString:@""];
     
     return urlFullAdderss;
     */
    
    // [NSString stringWithFormat:@"%@%@",kBaseUrl,(NSString *)serverInterfaceName];
    return [NSString stringWithFormat:@"%@",(NSString *)serverInterfaceName];
}

/**
 @brief  从urls.plist文件获取服务器url（不带接口）
 @result NSString 获取到的服务器url
 */
- (NSString *)getServerAdderss
{
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Urls.plist"];
    
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *urlKey = (NSString*)[data objectForKey:@"MS_ENVIRONMENT"];
    NSDictionary *serverAdderssDic = [data objectForKey:@"serverAddress"];
    NSString *urlFullAdderss = @"";
    
    if ([serverAdderssDic objectForKey:urlKey])
    {
        urlFullAdderss = [serverAdderssDic objectForKey:urlKey];
    }
    return urlFullAdderss;
}

#pragma mark ---------------- 格式校验 -----------------
/**
 *  密码校验
 *
 *  @param numString 待校验的密码
 *
 *  @return 校验结果，YES：合格， NO：密码格式不正确
 */
- (BOOL)checkPassword:(NSString *)numString {
    NSString *urlRegex = @"[a-zA-Z0-9_]{6,20}$";  //最少6位，最多20位
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    
    return [pred evaluateWithObject:numString];
}


/**
 *  邮箱校验
 *
 *  @param str2validate 待校验的邮箱
 *
 *  @return 校验结果，YES：合格， NO：邮箱格式不正确
 */
- (BOOL)checkEmail:(NSString *)str2validate;
{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:str2validate];
}

/**
 *  手机号码简单校验并用UIAlertView提示
 *
 *  @param phoneNumberString 等校验的手机号码
 *
 *  @return 校验结果，YES：合格， NO：手机号码格式不正确
 */
- (BOOL) checkPhoneNumberAndShowAlert: (NSString *) phoneNumberString
{
    if ([phoneNumberString stringByReplacingOccurrencesOfString:@" " withString:@""].length !=11) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入11位手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    if (![[phoneNumberString substringToIndex:1] isEqualToString:@"1"]) {
        UIAlertView	*alertview = [[UIAlertView alloc] initWithTitle:@"手机号码输入不正确，请输入正确的手机号"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertview show];
        return NO;
    }
    return YES;
}

/**
 *  手机号码或者邮箱号码校验
 *
 *  @param numberOrEmailString 待校验的用户名（可能为手机号码或者邮箱号码）
 *
 *  @return 校验结果，YES：合格， NO：手机号码格式及邮箱格式均不正确
 */
- (BOOL)checkPhoneNumberOrEmail: (NSString *) numberOrEmailString
{
    if (![self checkEmail:numberOrEmailString])
    {
        //手机号码简单校验位数
        if (numberOrEmailString.length) {
            if (![[numberOrEmailString substringToIndex:1] isEqualToString:@"1"]) {
                return NO;
            }
            
            if ([numberOrEmailString stringByReplacingOccurrencesOfString:@" " withString:@""].length != 11) {
                
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark ---------------- 截屏 -----------------
/**
 *  截屏
 *
 *  @return 返回截取得到的图片
 */
- (UIImage *) captureScreen
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self._theCaptureScreen = img;
    return img;
}

#pragma mark ---------------- GUID -----------------
/**
 * 生成一个几乎不可能重复GUID
 */
- (NSString *)generateUuidString
{
    NSString *uuidString =[[NSUUID UUID] UUIDString];
    return uuidString;
}

#pragma mark ---------------- 摄像头和相册相关的公共类 -----------------
// 判断设备是否有摄像头
- (BOOL) isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}


#pragma mark ---------------- location相关 -----------------
/*
 requestWhenInUseAuthorization	请求获得应用使用时的定位服务授权，注意使用此方法前在要在info.plist中配置NSLocationWhenInUseUsageDescription
 requestAlwaysAuthorization	请求获得应用一直使用定位服务授权，注意使用此方法前要在info.plist中配置NSLocationAlwaysUsageDescription
 */

/**
 *  更新地理位置（只更新一次，更新后停止定位，请在通知中获取定位信息）
 */
//- (void)updateLocation
//{
//    if (_locmanager)
//    {
//        _locmanager = nil;
//        [_locmanager setDelegate:nil];
//    }
//    _locmanager = [[CLLocationManager alloc] init];
//
//    [_locmanager setDelegate:self];
//    [_locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
//    [_locmanager setDistanceFilter:kCLDistanceFilterNone];
//    if (kIOSVersions >= 8.0)
//    {
//        [_locmanager requestWhenInUseAuthorization];
//    }
//
//    [_locmanager startUpdatingLocation];
//}
//
//
//
//// MARK: - locationManager
//- (void)locationManager:(CLLocationManager *)manager  didFailWithError:(NSError *)error
//{
//
//    NSString *errorString;
//
//    NSLog(@"Error: %@",[error localizedDescription]);
//    switch([error code]) {
//        case kCLErrorDenied:
//            errorString = @"我有礼没有权限访问您的定位服务，请在手机的“设置-隐私-定位服务”选项中设置。设置为允许访问后才可进行定位";
//            break;
//        case kCLErrorLocationUnknown:
//            errorString = @"定位失败,请重新定位";
//            break;
//        default:
//            errorString = @"未知错误";
//            break;
//    }
//
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLocationFail object:nil];
//
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                        message:errorString
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//    [alertView show];
//    [_locmanager stopUpdatingLocation];
//}
//
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    [_locmanager stopUpdatingLocation];
//
//    NSLog(@"update the location,latitude:= %@, longitude = %@",[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude], [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude]);
//    //    NSLog(@"进行相关数据处理，并发送通知");
//    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLocationNotification object:newLocation];
//}
//
//
#pragma mark ---------------- TableView相关 -----------------
/**
 *  隐藏tableview cell多余的分隔线
 *
 *  @param tableView 需要隐藏分割线的tableView
 */
-(void)setExtraSeparatorHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    view = nil;
}

#pragma mark ---------------- 缓存处理 -----------------
/**
 *  获取缓存大小（带单位）
 *
 *  @return 缓存大小（带单位）, 单位 M，小于1M用kb
 */
- (NSString *) getCacheSize
{
    CGFloat tempSize = [self folderSizeAtPath:[self getCachesPathWithAppendPath:nil]];
    
    if (tempSize / 1024.0 > 1.0)
    {
        return [NSString stringWithFormat:@"%.2f M", tempSize / (1024.0 * 1024.0)];
    }
    else
    {
        return [NSString stringWithFormat:@"%.2f kb", tempSize / 1024.0];
    }
}

/**
 *  获取指定全路径的文件总大小
 *
 *  @param folderPath 指定全路径
 *
 *  @return 总大小B
 */
- (float ) folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
    {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        //        NSLog(@"fileName ==== %@",fileName);
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        //        NSLog(@"fileAbsolutePath ==== %@",fileAbsolutePath);
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    //    NSLog(@"folderSize ==== %lld",folderSize);
    return folderSize;
}


/**
 *  获取指定缓存文件路径
 *
 *  @param appendPath 指定子路径，为空或Nil时返回整个缓存文件夹大小
 *
 *  @return 指定缓存文件路径
 */
- (NSString *) getCachesPathWithAppendPath: (NSString *) appendPath
{
    // 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    
    NSString *filePath = cachesDir;
    if (![NSString isNilOrEmpty:appendPath ])
    {
        filePath = [cachesDir stringByAppendingPathComponent:appendPath];
    }
    
    return filePath;
}


//计算某个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        
        //        //取得一个目录下得所有文件名
        //        NSArray *files = [manager subpathsAtPath:filePath];
        //        NSLog(@"files1111111%@ == %ld",files,files.count);
        //
        //        // 从路径中获得完整的文件名（带后缀）
        //        NSString *exe = [filePath lastPathComponent];
        //        NSLog(@"exeexe ====%@",exe);
        //
        //        // 获得文件名（不带后缀）
        //        exe = [exe stringByDeletingPathExtension];
        //
        //        // 获得文件名（不带后缀）
        //        NSString *exestr = [[files objectAtIndex:1] stringByDeletingPathExtension];
        //        NSLog(@"files2222222%@  ==== %@",[files objectAtIndex:1],exestr);
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}


/**
 *  清理指定类型的指定路径文件(NSHomeDirectory 目录下)
 *
 *  @param fullPath 指定全路径，如果为空或者nil，表示整个NSDocumentDirectory
 *  @param extension  指定文件类型如 m4r,如果为空或者nil,表示删除所有文件
 */
- (void) clearFileWithPath: (NSString *) fullPath withExtension: (NSString *) extension
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *homePath = NSHomeDirectory();
    //    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = homePath;
    if (![NSString isNilOrEmpty:fullPath ])
    {
        filePath = fullPath;
    }
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:filePath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([NSString isNilOrEmpty:extension ])
        {
            [fileManager removeItemAtPath:[filePath stringByAppendingPathComponent:filename] error:NULL];
        }
        else if ([[filename pathExtension] isEqualToString:extension])
        {
            
            [fileManager removeItemAtPath:[filePath stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

#pragma mark ---------------- 版本相关 -----------------
/**
 *  获取当前App版本号
 *
 *  @return 返回版本号字符串
 */
- (NSString *) getAppNowVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    return app_Version;
}

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
- (CGSize)calculateWithStr:(NSString *)str andSize:(CGSize)size andFont:(UIFont *)font
{
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
}


/**
 *  设置行间距
 *
 *  @param spacing 行间距大小
 *  @param label   要设置的label
 */
- (void)setLineSpacing:(CGFloat)spacing withLabel:(UILabel *)label
{
    if (!label.text.length) return;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
    [label setAttributedText:attributedString];
    [label sizeToFit];
}

/**
 *  自定义一根线条
 *
 *  @param frame <#frame description#>
 *  @param color <#color description#>
 */
- (UIView *)createLineViewWitFrame:(CGRect)frame andColor:(UIColor *)color
{
    UIView *lineView = [[ UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = color;
    
    return lineView;
}
@end

