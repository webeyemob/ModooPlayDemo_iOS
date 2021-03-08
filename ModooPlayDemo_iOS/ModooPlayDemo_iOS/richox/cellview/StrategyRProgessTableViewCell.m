//
//  StrategyRProgessTableViewCell.m
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/14.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import "StrategyRProgessTableViewCell.h"
#import "macro.h"


@interface StrategyRProgessTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *doMissionBtn;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) NSString *packetId;

@property (nonatomic, strong) StrategyRProgessDoWithdraw block;

@end


@implementation StrategyRProgessTableViewCell

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
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 40)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;

        UIButton *doMissionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        doMissionBtn.frame = CGRectMake(ScreenWidth-20-100, 10, 100, 40);
        doMissionBtn.backgroundColor = [UIColor blueColor];
        [doMissionBtn addTarget:self action:@selector(doMission) forControlEvents:UIControlEventTouchUpInside];
        
        [doMissionBtn setTitle:@"提现" forState:UIControlStateNormal];
        [doMissionBtn setTitle:@"继续努力" forState:UIControlStateDisabled];
        [doMissionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doMissionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self.contentView addSubview:doMissionBtn];
        self.doMissionBtn = doMissionBtn;
        self.doMissionBtn.enabled = NO;
 
        UIProgressView *progress =  [[UIProgressView alloc] initWithFrame:CGRectMake(20, 60, ScreenWidth - 40, 30)];
        progress.progressViewStyle = UIProgressViewStyleBar;
        progress.progressTintColor = [UIColor redColor];
        progress.trackTintColor = [UIColor yellowColor];
        self.progress = progress;

       [self.contentView addSubview:progress];
    }
    return self;
}
 

- (void)doMission {
    self.block();
}

- (void)setName:(NSString *)name progress: (double)progress packetId:(NSString *)packetId  block:(StrategyRProgessDoWithdraw)block {
    self.nameLabel.text = name;
    self.progress.progress = progress;
    self.packetId = packetId;
    if (progress >= 1.0) {
        self.doMissionBtn.enabled = YES;
    } else {
        self.doMissionBtn.enabled = NO;
    }
    self.block = block;
}

@end
