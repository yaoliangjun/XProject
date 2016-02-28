//
//  SKDropDown.m
//  DropDownExample
//
//  Created by Sukru on 01.10.2013.
//  Copyright (c) 2013 Sukru. All rights reserved.
//

#import "SKDropDown.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

//static CGFloat kDropDownCellHeight = 44;

static CGFloat kAnimationDuration = 0.25;


@implementation SKDropDown


- (id)showDropDown:(UIView *)b
        withItemHeight:(CGFloat)itemHeight
          withData:(NSArray *)arr
animationDirection:(DropDownAnimationDirection)direction
{
    _btnSender = b;
    self.kDropDownItemHeight = itemHeight;
    CGFloat kAllHeight = 0;
    if (arr.count > 0) {
        kAllHeight = self.kDropDownItemHeight * arr.count;
    }
    animationDirection = direction;
    self.tableView = (UITableView *)[super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        // Initialization code
        CGRect btn = b.frame;
        self.dropDownItems = [NSArray arrayWithArray:arr];
        if (direction == DropDownAnimationDirectionUp) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }else if (direction == DropDownAnimationDirectionDown) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO; // 关闭弹簧效果
        _tableView.layer.cornerRadius = 5;
//        _table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor grayColor];
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kAnimationDuration];
        if (direction == DropDownAnimationDirectionUp) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-kAllHeight, btn.size.width, kAllHeight);
        } else if(direction == DropDownAnimationDirectionDown) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, kAllHeight);
        }
        _tableView.frame = CGRectMake(0, 0, btn.size.width, kAllHeight);
        [UIView commitAnimations];
        [b.superview addSubview:self];
        [self addSubview:_tableView];
    }
    return self;
}

- (id)showDropDown:(UIView *)b
            inView:(UIView *)superView
        withItemHeight:(CGFloat)itemHeight
          withData:(NSArray *)arr
animationDirection:(DropDownAnimationDirection)direction
{
    _btnSender = b;
    self.kDropDownItemHeight = itemHeight;
    CGFloat kAllHeight = 0;
    if (arr.count > 0) {
        kAllHeight = self.kDropDownItemHeight * arr.count;
    }
    animationDirection = direction;
    self.tableView = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect aRect = [b convertRect:b.bounds toView:superView];
        self.dropDownItems = [NSArray arrayWithArray:arr];
        
        if (direction == DropDownAnimationDirectionUp) {
            self.frame = CGRectMake(aRect.origin.x,
                                    aRect.origin.y,
                                    aRect.size.width,
                                    0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }
        else if (direction == DropDownAnimationDirectionDown) {
            self.frame = CGRectMake(aRect.origin.x,
                                    aRect.origin.y+aRect.size.height,
                                    aRect.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, aRect.size.width, 0)];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView.layer setCornerRadius:5];
        _tableView.bounces = NO; // 关闭弹簧效果
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView setSeparatorColor:kHexRGB(0xCCCCCC)];
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kAnimationDuration];
        if (direction == DropDownAnimationDirectionUp) {
            self.frame = CGRectMake(aRect.origin.x,
                                    aRect.origin.y - kAllHeight,
                                    aRect.size.width,
                                    kAllHeight);
        }
        else if(direction == DropDownAnimationDirectionDown) {
            self.frame = CGRectMake(aRect.origin.x,
                                    aRect.origin.y+aRect.size.height,
                                    aRect.size.width,
                                    kAllHeight);
        }
        _tableView.frame = CGRectMake(0, 0, aRect.size.width, kAllHeight);
        [UIView commitAnimations];
        [superView addSubview:self];
        if ([superView isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)superView setScrollEnabled:NO];
        }
        [self addSubview:_tableView];
    }
    return self;
}//

-(void)hideDropDown:(UIView *)b
{
    CGRect btn = [b convertRect:b.bounds toView:self.superview];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    if (animationDirection == DropDownAnimationDirectionUp) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }
    else if (animationDirection == DropDownAnimationDirectionDown) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    }
    _tableView.frame = CGRectMake(0, 0, btn.size.width, 0);
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)(self.superview) setScrollEnabled:YES];
    }
    [UIView commitAnimations];
}

#pragma mark - UITableViewDataSource 下拉菜单数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _kDropDownItemHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dropDownItems count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
                                         forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];  // must
    // 8.0+ OK
    [cell setLayoutMargins:UIEdgeInsetsZero];
}//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        if ([_btnSender isKindOfClass:[UITextField class]]) {
            [cell setIndentationWidth:40];
            [cell setIndentationLevel:1];
            [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        }
        else {
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        }
    }
    
    cell.textLabel.text =[_dropDownItems objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
    UIView * v = [[UIView alloc] init];
    [v setBackgroundColor:MAIN_BK_COLOR];
    [cell setSelectedBackgroundView:v];
    
    return cell;
}

#pragma mark - UITableViewDelegate 下拉菜单代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideDropDown:_btnSender];
    
//    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
//    [_btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    
    if (![_btnSender isKindOfClass:[UITextField class]]) {
        for (UIView *subview in _btnSender.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                [subview removeFromSuperview];
            }
        }
    }
    
    if ([_delegate respondsToSelector:@selector(skDropDownDelegateMethod:withSelectedIndexPath:)]) {
        [_delegate skDropDownDelegateMethod:self withSelectedIndexPath:indexPath];
    }
}

@end
