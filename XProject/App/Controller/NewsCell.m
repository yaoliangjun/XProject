//
//  NewsCell.m
//  XProject
//
//  Created by Jerry.Yao on 16/3/2.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "NewsCell.h"

@interface NewsCell ()

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatarView;

@end

@implementation NewsCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
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
