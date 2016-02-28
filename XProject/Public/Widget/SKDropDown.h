//
//  SKDropDown.h
//  DropDownExample
//
//  Created by Sukru on 01.10.2013.
//  Copyright (c) 2013 Sukru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DropDownAnimationDirection)
{
    DropDownAnimationDirectionUp,   // 向上动画
    DropDownAnimationDirectionDown  // 向下动画
};

FOUNDATION_EXPORT const CGFloat kDropDownCellHeight;

@class SKDropDown;

@protocol SKDropDownDelegate <NSObject>

@optional
- (void)skDropDownDelegateMethod:(SKDropDown *)sender withSelectedIndexPath:(NSIndexPath *)index;

@end



#pragma mark - 下拉菜单
@interface SKDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger animationDirection;
}

@property (nonatomic, weak)   id <SKDropDownDelegate> delegate; // 下拉菜单代理
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView      *btnSender;
@property (nonatomic, retain) NSArray *dropDownItems; //下拉菜单子项数组
@property (nonatomic, assign) CGFloat kDropDownItemHeight;


#pragma mark - 下拉菜单暴露的方法

/**
 *  隐藏菜单
 */
- (void)hideDropDown:(UIView *)b;



/**
 *  显示一个下拉菜单
 *
 *  @param b             要显示的空间
 *  @param itemheight    每一个菜单项的高度
 *  @param data           要显示的菜单数据
 *  @param direction     要显示的动画方向
 *
 */
- (id)showDropDown:(UIView *)b
        withItemHeight:(CGFloat)itemheight
          withData:(NSArray *)data
animationDirection:(DropDownAnimationDirection)direction;



/**
 *  显示一个下拉菜单
 *
 *  @param b             要显示的空间
 *  @param inView        要显示的父控件
 *  @param itemheight    每一个菜单项的高度
 *  @param data           要显示的菜单数据
 *  @param direction     要显示的动画方向
 *
 */
- (id)showDropDown:(UIView *)b
            inView:(UIView *)superView
        withItemHeight:(CGFloat )itemheight
          withData:(NSArray *)data
animationDirection:(DropDownAnimationDirection)direction;

@end
