//
//  MainViewCell.m
//  XProject
//
//  Created by Jerry.Yao on 16/2/14.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "MainViewCell.h"
#import "MainViewFrame.h"
#import "MainViewModel.h"

@interface MainViewCell ()
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
}

@end

@implementation MainViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *selectedBgView = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, 10, 10)];
        selectedBgView.backgroundColor = kLightColor;
        self.selectedBackgroundView = selectedBgView;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        _imageView = imageView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = kFont(16);
        titleLabel.numberOfLines = 2;
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return self;
}

- (void)setMainViewFrame:(MainViewFrame *)mainViewFrame
{
    _mainViewFrame = mainViewFrame;
    
    [self setupDataAndFrame];
}

#pragma mark - 为cell设置数据和Frame
- (void)setupDataAndFrame
{
    if (!_mainViewFrame) return;
    _imageView.frame = _mainViewFrame.imageFrame;
    _titleLabel.frame = _mainViewFrame.titleFrame;
    
    MainViewModel *mainViewModel = _mainViewFrame.mainViewModel;
    if (!mainViewModel) return;

    _imageView.image = [UIImage imageNamed:mainViewModel.image];
    _titleLabel.text = mainViewModel.title;
}

@end
