//
//  CycleScrollView.h
//
//  Created by Jerry.Yao on 16-01-30.
//  Copyright (c) 2016年 Jerry.Yao All rights reserved.
//
//  滚动图片view

#import <UIKit/UIKit.h>

@class CycleScrollView;

@protocol CycleScrollViewDelegate <NSObject>

@optional
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(NSInteger)index;
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollImageView:(NSInteger)index;
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didStopScrollImageView:(NSInteger)index;

@end

typedef enum {
    CycleDirectionPortait,   // 垂直滚动
    CycleDirectionLandscape  // 水平滚动
}CycleDirection;


@interface CycleScrollView : UIView
{
    UIScrollView *_scrollView;
    UIImageView *curImageView;
    
    NSInteger totalPage;
    NSInteger curPage;
    CGRect _scrollFrame;
    
    CycleDirection scrollDirection;     // scrollView滚动的方向
    NSArray *_imagesArray;              // 存放所有需要滚动的图片 UIImage
    NSMutableArray *curImages;          // 存放当前滚动的三张图片
}

@property (nonatomic, assign) CGRect pageControlFrame;
@property (nonatomic, weak) id<CycleScrollViewDelegate> delegate;

- (NSInteger)validPageValue:(NSInteger)value;

- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction images:(NSArray *)imagesArray andDelegate:(id)delegate;

- (NSArray *)getDisplayImagesWithCurpage:(NSInteger)page;

- (void)refreshScrollView;

@end
