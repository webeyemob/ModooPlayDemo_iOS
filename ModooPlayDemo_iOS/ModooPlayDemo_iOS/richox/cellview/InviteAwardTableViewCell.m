//
//  InviteAwardTableViewCell.m
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/18.
//  Copyright © 2021 fissionsdk. All rights reserved.
//

#import "InviteAwardTableViewCell.h"
#import "macro.h"
@import RichOXSect;

@interface InviteAwardTableViewCell( )

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contribution;
@property (nonatomic, strong) UIButton *hasFetchBtn;

@property (nonatomic) int count;
@property (nonatomic, strong) NSString *apprenticeUid;

@end

@implementation InviteAwardTableViewCell

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
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 40)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *contribution = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 100, 40)];
        contribution.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:contribution];
        self.contribution = contribution;

        UIButton *hasFetchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        hasFetchBtn.frame = CGRectMake(ScreenWidth-20-80, 10, 80, 40);
//        [hasFetchBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//        [hasFetchBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
//        [hasFetchBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
        
        hasFetchBtn.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0];
        [hasFetchBtn addTarget:self action:@selector(fetchAward) forControlEvents:UIControlEventTouchUpInside];
        
        [hasFetchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [hasFetchBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
        [self.contentView addSubview:hasFetchBtn];
        self.hasFetchBtn = hasFetchBtn;
    }
    return self;
}

- (void)fetchAward {
    [RichOXSectInvite getInviteAward:self.count success:^(RichOXSectInviteAward * _Nonnull award) {
        NSLog(@"******* getInviteAward ******* 测试成功: %@",[award description]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hasFetchBtn setTitle:@"已领取" forState:UIControlStateDisabled];
            self.hasFetchBtn.enabled = NO;
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"******* getInviteAward ******* 测试失败: errorCode: %ld, message:%@",error.code, error.localizedDescription);
    }];
}

- (void)setCount:(int)count award: (NSString *)award hasFetch:(BOOL)hasFetch {
    self.count = count;
    self.nameLabel.text = [NSString stringWithFormat:@"邀请%d人", count];
    [self.contribution setText: award];
    
    if (hasFetch) {
        [self.hasFetchBtn setTitle:@"已领取" forState:UIControlStateDisabled];
        self.hasFetchBtn.enabled = NO;
    } else {
        [self.hasFetchBtn setTitle:@"未领取" forState:UIControlStateNormal];
        self.hasFetchBtn.enabled = YES;
    }
}

@end
