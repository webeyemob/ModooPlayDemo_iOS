//
//  ApprenticeTableViewCell.m
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/18.
//  Copyright © 2021 fissionsdk. All rights reserved.
//

#import "ApprenticeTableViewCell.h"
#import "macro.h"
@import RichOXSect;
@import RichOXBase;

@interface ApprenticeTableViewCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contribution;
@property (nonatomic, strong) UIButton *getStar;

@property (nonatomic, strong) NSString *apprenticeUid;


@end

@implementation ApprenticeTableViewCell

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
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 140, 40)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [nameLabel setTextColor:[UIColor greenColor]];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *contribution = [[UILabel alloc] initWithFrame:CGRectMake(160, 10, 80, 40)];
        contribution.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:contribution];
        self.contribution = contribution;

        UIButton *doGetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        doGetBtn.frame = CGRectMake(ScreenWidth-100, 10, 80, 40);
        doGetBtn.backgroundColor = [UIColor blueColor];
        [doGetBtn addTarget:self action:@selector(getStarAction) forControlEvents:UIControlEventTouchUpInside];
        
        [doGetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:doGetBtn];
        self.getStar = doGetBtn;
    }
    return self;
}

- (void)getStarAction {
    NSString *userId = [RichOXBaseManager userId];
    [RichOXSectContribution getContribution:userId apprenticeUid:self.apprenticeUid success:^(int star, int deltaContribution) {
        NSLog(@"******* genContribution *****测试成功: contribution :%d, deltaContribution： %d", star, deltaContribution);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contribution setText: [NSString stringWithFormat:@"总贡献%d", star]];
            [self.getStar setTitle:[NSString stringWithFormat:@"%d未领取", 0] forState:UIControlStateNormal];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"******* genContribution *****测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
    }];
}

- (void)setName:(NSString *)name totalContribution: (int)totalContribution contribution:(int)contribution {
    self.apprenticeUid = name;
    self.nameLabel.text = name;
    [self.contribution setText: [NSString stringWithFormat:@"总贡献%d", totalContribution]];
    
    [self.getStar setTitle:[NSString stringWithFormat:@"%d未领取", contribution] forState:UIControlStateNormal];
    self.getStar.hidden = NO;
    if (contribution == 0) {
        self.getStar.enabled = NO;
    } else {
        self.getStar.enabled = YES;
    }
}


@end
