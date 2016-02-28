//
//  CycleScrollView.m
//
//  Created by Jerry.Yao on 16-01-30.
//  Copyright (c) 2016年 Jerry.Yao All rights reserved.
//

#import "CycleScrollView.h"

@interface CycleScrollView () <UIScrollViewDelegate>

@end

@implementation CycleScrollView
{
    UIPageControl *_pageControl;
    CGFloat       _scrollBannerW;
    CGFloat       _scrollBannerH;
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction images:(NSArray *)imagesArray andDelegate:(id)sDdelegate
{
    self = [super initWithFrame:frame];
    if(self) {
        self.delegate = sDdelegate;
        _scrollFrame = frame;
        scrollDirection = direction;
        totalPage = imagesArray.count != 0 ? imagesArray.count : 1;
        curPage = 1; // 显示的是图片数组里的第一张图片
        curImages = [[NSMutableArray alloc] init];
        _imagesArray = [[NSArray alloc] initWithArray:imagesArray];
        
        _scrollBannerW = frame.size.width;
        _scrollBannerH = frame.size.height - 30;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _scrollBannerW, _scrollBannerH)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
        // 在水平方向滚动
        if(scrollDirection == CycleDirectionLandscape) {
            if (_imagesArray.count < 2) {
                _scrollView.contentSize = CGSizeMake(_scrollBannerW, _scrollBannerH);
            }
            else{
                _scrollView.contentSize = CGSizeMake(_scrollBannerW * 3, _scrollBannerH);
            }
        }
        else if(scrollDirection == CycleDirectionPortait) { // 在垂直方向滚动
            _scrollView.contentSize = CGSizeMake(_scrollBannerW, _scrollBannerH * 3);
        }
        
        [self addSubview:_scrollView];
        
        [self refreshScrollView];
    }
    
    return self;
}

- (void)setPageControlFrame:(CGRect)pageControlFrame
{
    _pageControlFrame = pageControlFrame;
    _pageControl.frame = _pageControlFrame;
}

- (void)refreshScrollView {
    
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:curPage];
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_scrollFrame];
        imageView.userInteractionEnabled = YES;
    
        NSString *imageUrl = nil;
        if (curImages.count > i) {
            imageUrl = [curImages objectAtIndex:i];
        }
        
        if (![NSString isNilOrEmpty:imageUrl])
        {
            [[UIUtils shared] setURLImage:imageUrl placeholderImage:nil imageView:imageView orButton:nil];
        }
        else
        {
            imageView.image = [UIImage imageNamed:kDefaultPlaceholderImage];
        }
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [imageView addGestureRecognizer:singleTap];
        
        if(scrollDirection == CycleDirectionLandscape) {
            // 水平滚动
            imageView.frame = CGRectOffset(imageView.frame, _scrollBannerW * i, 0);
            
        } else if(scrollDirection == CycleDirectionPortait) {
            // 垂直滚动
            imageView.frame = CGRectOffset(imageView.frame, 0, _scrollBannerH * i);
        }
        
        [_scrollView addSubview:imageView];
    }
    if (scrollDirection == CycleDirectionLandscape) {
        [_scrollView setContentOffset:CGPointMake(_scrollFrame.size.width, 0)];
    } else if (scrollDirection == CycleDirectionPortait) {
        [_scrollView setContentOffset:CGPointMake(0, _scrollFrame.size.height)];
    }
    
    // PageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollBannerH, _scrollBannerW, 30)];
    _pageControl = pageControl;
    [self addSubview:pageControl];
    pageControl.numberOfPages = totalPage;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = kOrangeColor;
    pageControl.pageIndicatorTintColor = kLightGrayColor;
    pageControl.hidesForSinglePage = YES;
}

/**
 *  通过当前页取到前一页和后一页放到数组里面
 *
 *  @param page <#page description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)getDisplayImagesWithCurpage:(NSInteger)page {
    
    NSInteger pre = [self validPageValue:curPage - 1];
    NSInteger last = [self validPageValue:curPage + 1];
    
    if([curImages count] != 0) [curImages removeAllObjects];
    if (_imagesArray.count != 0) {
        [curImages addObject:[_imagesArray objectAtIndex:pre - 1]];
        [curImages addObject:[_imagesArray objectAtIndex:curPage - 1]];
        [curImages addObject:[_imagesArray objectAtIndex:last - 1]];
    }
    return curImages;
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == 0) value = totalPage;                   // value＝1为第一张，value = 0为前面一张
    if(value == totalPage + 1) value = 1;
    
    return value;
}

#pragma mark - ScrollView滚动代理方法
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int scrollX = aScrollView.contentOffset.x;
    int scrollY = aScrollView.contentOffset.y;
   
    // 水平滚动
    if(scrollDirection == CycleDirectionLandscape) {
        // 往下翻一张
        if(scrollX >= (2 * _scrollFrame.size.width)) {
            curPage = [self validPageValue:curPage + 1];
            [self refreshScrollView];
        }
        if(scrollX <= 0) {
            curPage = [self validPageValue:curPage - 1];
            [self refreshScrollView];
        }
        
    } else if(scrollDirection == CycleDirectionPortait) {  // 垂直滚动
        // 往下翻一张
        if(scrollY >= 2 * (_scrollFrame.size.height)) {
            curPage = [self validPageValue:curPage + 1];
            [self refreshScrollView];
        }
        if(scrollY <= 0) {
            curPage = [self validPageValue:curPage - 1];
            [self refreshScrollView];
        }
    }
    // 设置UIPageControl当前页
    NSInteger currentPage = curPage - 1;
    _pageControl.currentPage = currentPage;
    
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollImageView:)]) {
        [delegate cycleScrollViewDelegate:self didScrollImageView:currentPage];
    }
}

#pragma mark - ScrollView滚动减速时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    if (scrollDirection == CycleDirectionLandscape) {
        [_scrollView setContentOffset:CGPointMake(_scrollFrame.size.width, 0) animated:YES];
        if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didStopScrollImageView:)]) {
            [delegate cycleScrollViewDelegate:self didStopScrollImageView:curPage];
        }
    }
    if (scrollDirection == CycleDirectionPortait) {
        [_scrollView setContentOffset:CGPointMake(0, _scrollFrame.size.height) animated:YES];
    }
}

#pragma mark - 图片点击事件
- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didSelectImageView:)]) {
        [delegate cycleScrollViewDelegate:self didSelectImageView:curPage];
    }
}

@end
