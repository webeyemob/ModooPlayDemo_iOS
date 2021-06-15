//
//  StrategyFProgessTableViewCell.m
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/14.
//  Copyright © 2021 TaurusXAds. All rights reserved.
//

#import "StrategyFProgessTableViewCell.h"


@interface StrategyFProgessTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *doMissionBtn;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) NSString *packetId;

@property (nonatomic, strong) StrategyFProgessDoMission block;

@end


@implementation StrategyFProgessTableViewCell

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
        doMissionBtn.frame = CGRectMake(self.contentView.bounds.size.width-20-80, 10, 80, 40);
        doMissionBtn.backgroundColor = [UIColor blueColor];
        [doMissionBtn addTarget:self action:@selector(doMission) forControlEvents:UIControlEventTouchUpInside];
        
        [doMissionBtn setTitle:@"完成任务" forState:UIControlStateNormal];
        [doMissionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:doMissionBtn];
        self.doMissionBtn = doMissionBtn;
 
        UIProgressView *progress =  [[UIProgressView alloc] initWithFrame:CGRectMake(20, 60, self.contentView.bounds.size.width - 40, 30)];
        progress.progressViewStyle = UIProgressViewStyleBar;
        progress.progressTintColor = [UIColor redColor];
        progress.trackTintColor = [UIColor yellowColor];
        self.progress = progress;

       [self.contentView addSubview:progress];
    }
    return self;
}
 

- (void)doMission {
    self.block(self.packetId);
}

- (void)setName:(NSString *)name progress: (double)progress packetId:(NSString *)packetId block:(StrategyFProgessDoMission)block {
    self.nameLabel.text = name;
    self.progress.progress = progress;
    self.packetId = packetId;
    if (progress >= 1.0) {
        [self.doMissionBtn setTitle:@"提现" forState:UIControlStateNormal];
    }
    self.block = block;
}

@end
