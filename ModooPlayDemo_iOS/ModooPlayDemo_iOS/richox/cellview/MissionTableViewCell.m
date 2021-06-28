//
//  MissionTableViewCell.m
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/21.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import "MissionTableViewCell.h"
#import "macro.h"
#import "UIView+Toast.h"

@interface MissionTableViewCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *bonusLabel;
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) UIButton *multiplyBtn;
@property (nonatomic, strong) RichOXMissionData *missionItem;

@property (nonatomic, strong) RichOXMissionSubmitResult *submitRes;

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation MissionTableViewCell

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
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, 30)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *bonusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 100, 30)];
        bonusLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:bonusLabel];
        self.bonusLabel = bonusLabel;
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 40, 60, 30)];
        countLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:countLabel];
        self.countLabel = countLabel;
        
        
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [submitBtn setTitle:@"提交任务" forState:UIControlStateNormal];
        submitBtn.frame = CGRectMake(ScreenWidth-20-80-90, 20, 80, 40);
//        [hasFetchBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//        [hasFetchBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
//        [hasFetchBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
        
        submitBtn.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0];
        [submitBtn addTarget:self action:@selector(submitMission) forControlEvents:UIControlEventTouchUpInside];
        
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
        [self.contentView addSubview:submitBtn];
        self.submitBtn = submitBtn;
        
        UIButton *multiplyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        multiplyBtn.frame = CGRectMake(ScreenWidth-20-70, 20, 70, 40);
        [multiplyBtn setTitle:@"翻倍" forState:UIControlStateNormal];
                
        multiplyBtn.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0];
        [multiplyBtn addTarget:self action:@selector(multiplyMission) forControlEvents:UIControlEventTouchUpInside];
                
        [multiplyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [multiplyBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
        [self.contentView addSubview:multiplyBtn];
        self.multiplyBtn = multiplyBtn;
        self.multiplyBtn.enabled = NO;
    }
    return self;
}


- (void)submitMission {
    [RichOXMission submitMissionInfo:_missionItem.id multiple:nil bouns:_missionItem.bonus cost:_missionItem.cost success:^(RichOXMissionSubmitResult *result) {
        NSLog(@"******* submitMissionInfo ********测试成功: %@", [result description]);
        [RichOXMission missionCount:self.missionItem.id days:1 success:^(RichOXMissionQueryCountResult *result) {
            //任务记录
            NSLog(@"******* missionCount *******测试成功:  result:%@", [result description]);
            dispatch_async(dispatch_get_main_queue(), ^{
            self.countLabel.text = [NSString stringWithFormat:@"数量%d", result.count];
            });
        } failure:^(NSError *error){
             NSLog(@"******* missionCount *******测试失败 error code: %zd, msg: %@",error.code, error.localizedDescription);
        }];
        
        if (self.missionItem.supportMultiply) {
            dispatch_async(dispatch_get_main_queue(), ^{
            self.multiplyBtn.enabled = YES;
            });
            self.submitRes = result;
        }
    } failure:^(NSError *error) {
        NSLog(@"******* missionMultiply ********测试失败: error code: %ld, msg: %@",error.code, error.localizedDescription);
        self.submitRes = nil;
    }];
}

- (void)multiplyMission {
    if(self.submitRes != nil && self.submitRes.record != nil) {
        RichOXMissionRecord *record = self.submitRes.record;
        [RichOXMission missionMultiply:record.missionId recordId: record.recordId multiple:@"2" success:^(RichOXMissionSubmitResult *result ) {
            NSLog(@"******* missionMultiply ********测试成功: %@", [result description]);
        } failure:^(NSError *error) {
            NSLog(@"******* missionMultiply ********测试失败: error code: %ld, msg: %@",error.code, error.localizedDescription);
        }];
    }
}

- (void)setItem:(RichOXMissionData *)item {
    self.missionItem = item;
    self.nameLabel.text = item.name;
    self.bonusLabel.text = [NSString stringWithFormat:@"奖励: %.2f %@", item.bonus, item.bonusType==1?@"现金":@"金币"];
    if (item.cost == 0) {
        self.submitBtn.enabled = YES;
    } else {
        self.submitBtn.enabled = NO;
    }
    
    [RichOXMission missionCount:item.id days:1 success:^(RichOXMissionQueryCountResult *result) {
        //任务记录
        NSLog(@"******* missionCount *******测试成功:  result:%@", [result description]);
        dispatch_async(dispatch_get_main_queue(), ^{
        self.countLabel.text = [NSString stringWithFormat:@"数量%d", result.count];
        });
    } failure:^(NSError *error){
         NSLog(@"******* missionCount *******测试失败 error code: %zd, msg: %@",error.code, error.localizedDescription);
    }];
}

@end
