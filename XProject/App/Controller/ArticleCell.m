//
//  ArticleCell.m
//  XProject
//
//  Created by Jerry.Yao on 16/3/3.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "ArticleCell.h"
@interface ArticleCell ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ArticleCell

+ (ArticleCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"reuseIdentifier";
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 加载子view
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *avatarView = [[UIImageView alloc] init];
    avatarView.backgroundColor = kGreenColor;
    [self.contentView addSubview:avatarView];
    _avatarView = avatarView;
    
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@60);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 2;
    titleLabel.backgroundColor = kRedColor;
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_avatarView.mas_trailing).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.height.equalTo(@50);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-10);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.backgroundColor = kGrayColor;
    [self.contentView addSubview:contentLabel];
    _contentLabel = contentLabel;
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_titleLabel.mas_leading);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}


- (void)setAvatarName:(NSString *)avatarName
{
    _avatarName = avatarName;
    self.avatarView.image = [UIImage imageNamed:avatarName];
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    CGSize titleSize = [_title sizeWithAttributes:@{NSForegroundColorAttributeName : kBlackColor, NSFontAttributeName: kFont(18)}];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(titleSize.height));
    }];
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.contentLabel.text = content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
