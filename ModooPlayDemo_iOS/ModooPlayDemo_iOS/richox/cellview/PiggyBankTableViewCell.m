//
//  PiggyBankTableViewCell.m
//  ModooPlayDemo
//
//  Created by moodoo on 2021/6/25.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import "PiggyBankTableViewCell.h"

@interface PiggyBankTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UIButton *doMissionBtn;

@property (nonatomic, strong) PiggyBankWithdrawOnClick block;

@end

@implementation PiggyBankTableViewCell

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
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 120, 40)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 10, 60, 40)];
        amountLabel.font = [UIFont systemFontOfSize:12];
        [amountLabel setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:amountLabel];
        self.amountLabel = amountLabel;

        UIButton *doMissionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doMissionBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width -20-80, 10, 80, 40);
        doMissionBtn.backgroundColor = [UIColor blueColor];
        [doMissionBtn addTarget:self action:@selector(doMission) forControlEvents:UIControlEventTouchUpInside];
        
        [doMissionBtn setTitle:@"提取" forState:UIControlStateNormal];
        [doMissionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doMissionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self.contentView addSubview:doMissionBtn];
        self.doMissionBtn = doMissionBtn;
        //self.doMissionBtn.enabled = NO;
    }
    return self;
}
 

- (void)doMission {
    self.block();
}

- (void)setName:(NSString *)name amount: (double)amount assetName: (NSString *)assetName block:(PiggyBankWithdrawOnClick)block {
    self.nameLabel.text = name;
    self.amountLabel.text = [NSString stringWithFormat:@"%.2f %@", amount, assetName ];
    if (amount > 0){
        self.doMissionBtn.enabled = YES;
    } else {
        self.doMissionBtn.enabled = NO;
    }
    self.block = block;
}

@end
