//
//  RichOXNormalStrategyCustomRuleViewController.m
//  ModooPlayDemo
//
//  Created by Modoo on 2021/1/14.
//  Copyright © 2021 Modoo play. All rights reserved.
//

#import "RichOXNormalStrategyCustomRuleViewController.h"
#import "StrategyProgessTableViewCell.h"
@import RichOXBase;
@import RichOXNormalStrategy;
@import TaurusXAds;
#import <Masonry/Masonry.h>
#import "macro.h"
#import "UIView+Toast.h"

@interface RichOXNormalStrategyCustomRuleViewController () <UITableViewDelegate, UITableViewDataSource, TXADRewardedVideoAdDelegate>

@property (nonatomic, strong) NSArray<RichOXNormalStrategyItem *> * strategyList;
@property (nonatomic, strong) NSArray <RichOXNormalStrategyTask *>* taskList;

@property (nonatomic, strong) UITableView *progressTab;
@property (nonatomic, strong) UIView *buttonContainer;

@property (nonatomic, strong) UITextField *stragegyIdText;
@property (nonatomic, strong) NSString *lastId;

@property (nonatomic, strong) NSArray <RichOXNormalStrategyAssetStatus *>* currentAssets;

@property (nonatomic, strong) RichOXNormalStrategyInstance *stragegyInstance;


@property (nonatomic, strong) TXADRewardedVideoAd *rewardedAd;

@property (nonatomic, strong) UIButton *showRewardBtn;

@property (nonatomic) BOOL canBeRewarded;

@end

#define TEST_NORMALSTRATEGY_CUSTOMRULE_APPID @""
#define TEST_NORMALSTRATEGY_CUSTOMRULE_ADID @""


@implementation RichOXNormalStrategyCustomRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAds];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kTopBarSafeHeight);
        make.bottom.equalTo(self.view.mas_top).offset(kTopBarSafeHeight+20);
    }];
    
    UILabel *titleLab =  [[UILabel alloc]init];
    titleLab.text = @"自定义规则测试";
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [header addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(header);
        make.width.equalTo(@(250));
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [header addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(closePage) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"back" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header).offset(-20);
        make.centerY.equalTo(header);
        make.width.equalTo(@(50));
    }];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [header addSubview:infoBtn];
    
    [infoBtn addTarget:self action:@selector(getTaskProcess) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn setTitle:@"TaskInfo" forState:UIControlStateNormal];
    [infoBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(10);
        make.centerY.equalTo(header);
        make.width.equalTo(@(80));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(header.mas_bottom).offset(1);
        make.height.equalTo(@1);
    }];
    UILabel *stagelab = [[UILabel alloc] init];
    stagelab.text = @"通用策略 id: ";
    [self.view addSubview:stagelab];
    
    [stagelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(140));
        make.height.equalTo(@(30));
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    [self.view addSubview:textField];
    textField.borderStyle = UITextBorderStyleRoundedRect;

    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stagelab);
        make.left.equalTo(stagelab.mas_right).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(30));
    }];
    
    self.stragegyIdText = textField;
    
    UIButton *syncBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:syncBtn];
    [syncBtn setTitle:@"Sync strage" forState:UIControlStateNormal];
    [syncBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [syncBtn addTarget:self action:@selector(prepareData) forControlEvents:UIControlEventTouchUpInside];
    
    [syncBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(200));
        make.height.equalTo(@(30));
    }];
    
    self.buttonContainer = [[UIView alloc] init];
    [self.view addSubview:self.buttonContainer];
    [self.buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(syncBtn.mas_bottom).offset(10);
        make.height.equalTo(@50);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"Load Ad" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loadReward) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonContainer addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buttonContainer).offset(30);
        make.centerY.equalTo(self.buttonContainer);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    
    self.showRewardBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.showRewardBtn.backgroundColor = [UIColor greenColor];
    [self.showRewardBtn setTitle:@"Show Ad" forState:UIControlStateNormal];
    [self.showRewardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.showRewardBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(showReward) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonContainer addSubview:self.showRewardBtn];
    [self.showRewardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.buttonContainer).offset(-30);
        make.centerY.equalTo(self.buttonContainer);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    self.showRewardBtn.enabled = NO;
    
    [self.view addSubview:self.progressTab];
    [self.progressTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.buttonContainer.mas_bottom).offset(5);
    }];

}

- (void)viewWillAppear:(BOOL)animated {
//    if (self.stragegyInstance) {
//        self.strategyList = [self.stragegyInstance getList];
//        [self.progressTab reloadData];
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initAds {
    [TXAD setTestMode:YES];
    [TXAD initWithAppId:TEST_NORMALSTRATEGY_CUSTOMRULE_APPID];
}

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadReward {
    if (self.rewardedAd == nil) {
        self.rewardedAd = [[TXADRewardedVideoAd alloc] initWithAdUnitId:TEST_NORMALSTRATEGY_CUSTOMRULE_ADID];
        self.rewardedAd.delegate = self;
    }
    self.canBeRewarded = NO;
    [self.rewardedAd loadAd];
}

- (void)showReward {
    if (self.rewardedAd.isReady) {
        [self.rewardedAd showFromViewController:self];
    }
}

- (void)txAdRewardedVideo:(TXADRewardedVideoAd *)rewardedVideoAd didReceiveAd:(TXADILineItem *)lineItem {
    NSLog(@"txAdRewardedVideoDidReceiveAd, adUnitId is %@", rewardedVideoAd.adUnitId);
    self.showRewardBtn.enabled = YES;
}

- (void)txAdRewardedVideo:(TXADRewardedVideoAd *)rewardedVideoAd didFailToReceiveAdWithError:(TXADAdError *)adError {
    NSLog(@"didFailToReceiveAdWithError %d",(int)[adError getCode]);
    [self.view makeToast:@"load failed" duration:3.0 position:CSToastPositionCenter];
}

- (void)txAdRewardedVideo:(TXADRewardedVideoAd *)rewardedVideoAd didReward:(TXADILineItem *)lineItem item:(TXADRewardItem *)item {
    NSLog(@"txAdRewardedVideo didReward, adUnitId is %@, RewardItem is: %@, TId: %@", rewardedVideoAd.adUnitId, item, [lineItem getTId]);
    self.canBeRewarded = YES;
}


- (void)txAdRewardedVideo:(TXADRewardedVideoAd *)rewardedVideoAd didClose:(TXADILineItem *)lineItem {
    NSLog(@"txAdRewardedVideoDidClose, adUnitId is %@, TId:%@", rewardedVideoAd.adUnitId,[lineItem getTId]);
    
    self.showRewardBtn.enabled = NO;
    if (self.canBeRewarded) {
        [self doTask:[lineItem getTId]];
        self.canBeRewarded = NO;
    }
}

- (void)getTaskProcess {
    NSMutableArray *taskIds = [NSMutableArray new];
    for (RichOXNormalStrategyTask *task in self.taskList) {
        [taskIds addObject:task.taskId];
    }
    
    [self.stragegyInstance getTaskProcessInfo:taskIds success:^(RichOXNormalStrategyTaskProcessResult * _Nonnull result) {
        NSLog(@"getTaskProcess success: %@", [result description]);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"getTaskProcess error: %@", error);
    }];
}

- (UITableView *)progressTab {
    if (!_progressTab) {
        _progressTab = [[UITableView alloc] init];
        _progressTab.delegate = self;
        _progressTab.dataSource = self;
        _progressTab.userInteractionEnabled = YES;
       
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [_progressTab setTableFooterView:view];
    }
    
    return _progressTab;
}

- (void) prepareData {
    if (self.stragegyIdText.text != nil && ![self.stragegyIdText.text isEqualToString:@""]) {
        if (self.stragegyInstance == nil || ![self.stragegyIdText.text isEqualToString:self.lastId]) {
            self.stragegyInstance = [RichOXNormalStrategyInstance getNormalStrategy:[self.stragegyIdText.text intValue]];
        }

        [self.stragegyInstance syncList:^(RichOXNormalStrategySetting *setting) {
            self.strategyList = setting.withdrawSetting;
            self.taskList = setting.taskInfo.tasks;
            [self.stragegyInstance syncCurrentPrize:^(RichOXNormalStrategyStatus *status) {
                self.currentAssets = status.assetInfos;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressTab reloadData];
                });
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"sync normal strategy failed: %@", error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressTab reloadData];
                });
            }];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"sync normal strategy failed: %@", error);
        }];
    } else {
        [self.view makeToast:@"请输入策略ID" duration:3.0 position:CSToastPositionCenter];
    }
}

- (void)doTask:(NSString *)tId {
    if (self.taskList != nil && [self.taskList count] > 0) {
        for (int i=0; i<[self.taskList count]; i++) {
            RichOXNormalStrategyTask *task = self.taskList[i];
            if (task.prizeType == RICHOX_NR_PRIZE_TYPE_CUSTOMRULE && task.rewardType == RICHOX_NR_REWARD_TYPE_NEED_TID) {
                [self.stragegyInstance doMission:task.taskId prizeAmount:0 tid:tId success:^(RichOXNormalStrategyTaskResult *result) {
                    self.currentAssets = result.assetStatus;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.progressTab reloadData];
                    });
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"doMission failed: %@", error);
                }];
            }
        }
    }
}

#pragma mark <UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"资产数量";
    } else {
        return @"提现进度";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.currentAssets == nil) {
            return 0;
        } else {
            return [self.currentAssets count];
        }
    } else {
        if (self.strategyList == nil) {
            return 0;
        }
        return [self.strategyList count];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40;
    } else {
        return 100;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *assetIdentifier = @"assetCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:assetIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:assetIdentifier];
        }
        
        RichOXNormalStrategyAssetStatus *assetInfo = self.currentAssets[indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %.2f", assetInfo.name, assetInfo.amount ];
        return cell;
    } else {
        static NSString *cellIdentifier = @"pregressCellIdentifier";
        StrategyProgessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[StrategyProgessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        RichOXNormalStrategyItem *item = self.strategyList[indexPath.row];
        
        double progress = 0;
        
        for (RichOXNormalStrategyAssetStatus *assetInfo in self.currentAssets) {
            if ([assetInfo.name isEqualToString:item.assetName]) {
                progress = (double)assetInfo.amount / item.costAsset;
                break;
            }
        }
        
        [cell setName:item.packageId progress:progress packetId:item.packageId status:0 block:^() {
                RichOXWithdrawInfo *info = [[RichOXWithdrawInfo alloc] initWithPayremark:@"通用红包提现"];
                [self.stragegyInstance withdraw:item.packageId info:info success:^(RichOXNormalStrategyWithdrawResult *result){
                    self.currentAssets = result.assetStatus;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.progressTab reloadData];
                    });
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"withdraw failed: %@", error);
                }];
            }];
        
        return cell;
    }
}

@end
