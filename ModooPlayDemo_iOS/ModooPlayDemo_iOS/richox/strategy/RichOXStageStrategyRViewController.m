//
//  RichOXStageStrategyViewController.m
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/14.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import "RichOXStageStrategyRViewController.h"
#import "StrategyRProgessTableViewCell.h"
@import RichOXBase;
@import RichOXStageStrategy_R;
#import <Masonry/Masonry.h>
#import "macro.h"
#import "UIView+Toast.h"

@interface RichOXStageStrategyRViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<RichOXStageStrategyItemR *> * strategyList;
@property (nonatomic, strong) NSArray <RichOXStageStrategyTask *>* taskList;

@property (nonatomic, strong) UITableView *progressTab;
@property (nonatomic, strong) UIView *buttonContainer;

@property (nonatomic) NSUInteger currentAmount;

@property (nonatomic, strong) UITextField *stragegyIdText;
@property (nonatomic, strong) NSString *lastId;

@property (nonatomic, strong) RichOXStageStrategyInstanceR *stragegyInstance;

@end

#define TEST_STAGESTRATEGY_R_ID @"46"

@implementation RichOXStageStrategyRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    titleLab.text = @"阶梯策略测试";
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
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(header.mas_bottom).offset(1);
        make.height.equalTo(@1);
    }];
    
    UILabel *stagelab = [[UILabel alloc] init];
    stagelab.text = @"阶梯策略 id: ";
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
        make.top.equalTo(syncBtn.mas_bottom).offset(5);
        make.height.equalTo(@100);
    }];
    
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

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
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
            self.stragegyInstance = [RichOXStageStrategyInstanceR getStageStrategy:self.stragegyIdText.text];
        }
        self.lastId = self.stragegyIdText.text;
        [self.stragegyInstance syncList:^(RichOXStageStrategySetting *strategySetting) {
            self.strategyList = strategySetting.withdrawSetting;
            self.taskList = strategySetting.tasks;
            [self.stragegyInstance syncCurrentPrize:^(int progressValue) {
                self.currentAmount = progressValue;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addButtonToContainer];
                    [self.progressTab reloadData];
                });
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"sync stage strategy failed: %@", error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addButtonToContainer];
                    [self.progressTab reloadData];
                });
            }];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"sync stage strategy failed: %@", error);
        }];
    } else {
        [self.view makeToast:@"请输入策略ID" duration:3.0 position:CSToastPositionCenter];
    }
}

- (void)addButtonToContainer {
    NSUInteger count = [self.taskList count];
    float width = (ScreenWidth - (count + 1) *30)/count;
    for (int i = 0; i < count; i++) {
        RichOXStageStrategyTask *task = self.taskList[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i;
        btn.frame = CGRectMake(30 + (30 + width)*i, 20, width, 60);
        btn.backgroundColor = [UIColor greenColor];
        [btn setTitle:[NSString stringWithFormat:@"%d", task.prizeAmount] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doTask:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonContainer addSubview:btn];
    }
}

- (void)doTask:(UIButton *)btn {
    RichOXStageStrategyTask *task = self.taskList[btn.tag];
    int amount = task.prizeAmount;
    if (task.prizeType == RICHOX_SS_R_PRIZE_TYPE_MAX) {
        amount = amount * 0.5;
    }
    
    [self.stragegyInstance doMission:task.taskId prizeAmount:amount success:^{
        self.currentAmount += amount;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressTab reloadData];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"doMission failed: %@", error);
    }];
}

#pragma mark <UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.strategyList == nil) {
        return 0;
    }
    return [self.strategyList count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"pregressCellIdentifier";
    StrategyRProgessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[StrategyRProgessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    RichOXStageStrategyItemR *item = self.strategyList[indexPath.row];
    
    [cell setName:item.packageId progress:(double)(self.currentAmount)/item.needPrize packetId:item.packageId block:^() {
            RichOXWithdrawInfo *info = [[RichOXWithdrawInfo alloc] initWithPayremark:@"阶梯红包提现"];
            [self.stragegyInstance withdraw:item.packageId info:info success:^{
                
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"withdraw failed: %@", error);
            }];
        }];
    
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
