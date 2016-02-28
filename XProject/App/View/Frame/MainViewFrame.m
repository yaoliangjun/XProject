//
//  MainViewFrame.m
//  XProject
//
//  Created by Jerry.Yao on 16/2/14.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "MainViewFrame.h"
#import "MainViewModel.h"

@implementation MainViewFrame

- (void)setMainViewModel:(MainViewModel *)mainViewModel
{
    _mainViewModel = mainViewModel;
    
    [self setupFrame];
}

#pragma mark - 设置数据Frame
- (void)setupFrame
{
    // 图片
    CGFloat imageWH = 60;
    CGFloat cellWidth = (kScreenWidth  - 30 ) / 2;
    _imageFrame = CGRectMake((cellWidth - imageWH ) / 2, 20, imageWH, imageWH);
    
    // 文字
    NSString *title = _mainViewModel.title;
    CGSize titleSize = [[UIUtils shared] calculateWithStr:title andSize:CGSizeMake(cellWidth, MAXFLOAT) andFont:kFont(16)];
    _titleFrame = CGRectMake((cellWidth - titleSize.width ) / 2, CGRectGetMaxY(_imageFrame) + 5, cellWidth, titleSize.height);
    
    // 高度
    _rowHeight = CGRectGetMaxY(_titleFrame) + 20;
}

@end
