//
//  ChatGroupTableViewCell.m
//  ModooPlayDemo
//
//  Created by moodoo on 2021/7/26.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import "ChatGroupTableViewCell.h"

@interface ChatGroupTableViewCell ()

@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *lastMessageLabel;

@end

@implementation ChatGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
        categoryLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:categoryLabel];
        self.categoryLabel = categoryLabel;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 100, 40)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;

       UILabel *lastMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 300, 30)];
       lastMessageLabel.font = [UIFont systemFontOfSize:12];
       [self.contentView addSubview:lastMessageLabel];
        self.lastMessageLabel = lastMessageLabel;
    }
    return self;
}
 


- (void)setGroupInfo:(RichOXGroupInfo *)group {
    self.categoryLabel.text = group.category;
    self.nameLabel.text = group.displayName;
    
    if (group.lastChatMessage != nil) {
        self.lastMessageLabel.text = group.lastChatMessage.content;
    }
}

@end
