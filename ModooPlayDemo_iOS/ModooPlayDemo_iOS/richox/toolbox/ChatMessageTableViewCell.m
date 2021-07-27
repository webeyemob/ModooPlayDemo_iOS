//
//  ChatMessageTableViewCell.m
//  ModooPlayDemo
//
//  Created by moodoo on 2021/7/27.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import "ChatMessageTableViewCell.h"
#import "macro.h"

@interface ChatMessageTableViewCell()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *IdLabel;

@end

@implementation ChatMessageTableViewCell

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
        UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 50, 50)];
        [self.contentView addSubview:avatar];
        self.avatarView = avatar;
        
        UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 70, 30)];
        nickNameLabel.font = [UIFont systemFontOfSize:14];
        nickNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:nickNameLabel];
        self.nickNameLabel = nickNameLabel;
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, ScreenWidth-20-110, 60)];
        contentLabel.numberOfLines = 2;
        contentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 75, 40, 20)];
        typeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:typeLabel];
         self.typeLabel = typeLabel;

       UILabel *IdLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 75, ScreenWidth-20-160, 20)];
        IdLabel.font = [UIFont systemFontOfSize:12];
       [self.contentView addSubview:IdLabel];
        self.IdLabel = IdLabel;
    }
    return self;
}
 


- (void)setMessageInfo:(RichOXChatMessage *)message {
    if (message.senderImage != nil) {
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:message.senderImage]];
        [self.avatarView setImage:[UIImage imageWithData:data]];
    }
    self.nickNameLabel.text = message.senderName;
    self.contentLabel.text = message.content;
    
    self.typeLabel.text = message.messageType;
    self.IdLabel.text = [NSString stringWithFormat:@"%ld", message.messageId];
}

@end
