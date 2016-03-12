//
//  ArticleCell.h
//  XProject
//
//  Created by Jerry.Yao on 16/3/3.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *avatarName;

+ (ArticleCell *)cellWithTableView:(UITableView *)tableView;
@end
