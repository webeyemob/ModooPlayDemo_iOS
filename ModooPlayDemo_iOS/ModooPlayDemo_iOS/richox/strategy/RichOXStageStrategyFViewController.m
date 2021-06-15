//
//  TestStageStrategyFViewController.m
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/14.
//  Copyright © 2021 TaurusXAds. All rights reserved.
//

#import "RichOXStageStrategyFViewController.h"
@import RichOX;
#import "StrategyFProgessTableViewCell.h"
#import "UIView+Toast.h"
#import <Masonry/Masonry.h>
#import "macro.h"
@import RichOXStageStrategy_F;
@import RichOXBase;

@interface RichOXStageStrategyFViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<RichOXStageStrategyItemF *> * strategyList;
@property (nonatomic, strong) UITableView *progressTab;

@property (nonatomic, strong) RichOXStageStrategyInstanceF *stragegyInstance;

@property (nonatomic, strong) UITextField *stragegyIdText;
@property (nonatomic, strong) NSString *lastId;

@property (nonatomic, strong) UITextField *missionIdText;

@end

#define TEST_STAGESTRATEGY_ID @"richox_ios_test"
#define TEST_STAGESTRATEGY_MissionID_1 @"test_stagestrage"
#define TEST_STAGESTRATEGY_MissionID_2 @"test_stagestrage2"

@implementation RichOXStageStrategyFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *header = [[UIView alloc] init];
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kTopBarSafeHeight);
        make.bottom.equalTo(self.view.mas_top).offset(kTopBarSafeHeight+20);
    }];
    
    UILabel *titleLab =  [[UILabel alloc]init];
    titleLab.text = @"阶梯红包测试";
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
    
    // Do any additional setup after loading the view.
    UILabel *stagelab = [[UILabel alloc] init];
    stagelab.text = @"阶梯红包配置 id: ";
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
    [syncBtn setTitle:@"Sync stage strage" forState:UIControlStateNormal];
    [syncBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [syncBtn addTarget:self action:@selector(prepareData) forControlEvents:UIControlEventTouchUpInside];
    
    [syncBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(200));
        make.height.equalTo(@(30));
    }];
    
    
    UILabel *missionlab = [[UILabel alloc] init];
    missionlab.text = @"阶梯红包任务id: ";
    [self.view addSubview:missionlab];
    
    [missionlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(syncBtn.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(140));
        make.height.equalTo(@(30));
    }];
    
    UITextField *missionTextField = [[UITextField alloc]init];
    [self.view addSubview:missionTextField];
    missionTextField.borderStyle = UITextBorderStyleRoundedRect;

    [missionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(missionlab);
        make.left.equalTo(missionlab.mas_right).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(30));
    }];
    
    self.missionIdText = missionTextField;
    
    [self.view addSubview:self.progressTab];
    
    [self.progressTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.missionIdText.mas_bottom).offset(20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.stragegyInstance) {
        self.strategyList = [self.stragegyInstance getList];
        [self.progressTab reloadData];
    }
}

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (void)prepareData {
    NSString *userId = [RichOXBaseManager userId];
    
    if (userId == nil) {
        [RichOXUser registerUserId:nil initInfo: nil success:^(RichOXUserData * _Nonnull userData) {
            [self getStageStrategyList];
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"register user failed: %@", error);
        }];
    } else {
        [self getStageStrategyList];
    }
}

- (void) getStageStrategyList {
    if (self.stragegyInstance == nil  || ![self.lastId isEqualToString:self.stragegyIdText.text]) {
        if (self.stragegyIdText.text != nil && ![self.stragegyIdText.text isEqualToString:@""]) {
            self.stragegyInstance = [RichOXStageStrategyInstanceF getStageStrategy:self.stragegyIdText.text];
            self.lastId = self.stragegyIdText.text;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"please input stragegy id " duration:3.0 position:CSToastPositionCenter];
            });
            return;
        }
    }
    
    [self.stragegyInstance syncList:^(NSArray<RichOXStageStrategyItemF *> * _Nonnull strategyList) {
        self.strategyList = strategyList;
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressTab reloadData];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"sync stage strategy failed: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = [NSString stringWithFormat:@"sync stage strategy failed: %zd", error.code];
            [self.view makeToast:message duration:3.0 position:CSToastPositionCenter];
        });
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
    StrategyFProgessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[StrategyFProgessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    RichOXStageStrategyItemF *item = self.strategyList[indexPath.row];
    
    [cell setName:item.name progress:item.percent/100 packetId:item.packageId block:^(NSString * _Nonnull packetId) {
        if (item.percent < 100) {
            [self.stragegyInstance doMission:packetId missionId:self.missionIdText.text bonus:0 success:^(NSArray<RichOXStageStrategyItemF *> * _Nonnull strategyList) {
                self.strategyList = strategyList;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressTab reloadData];
                });
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"doMission failed: %@", error);
            }];
        } else {
            RichOXWithdrawInfo *info = [[RichOXWithdrawInfo alloc] initWithPayremark:@"阶梯红包提现"];
            
            [self.stragegyInstance withdraw:item.packageId userDegree:0 info:info success:^{
                
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"withdraw failed: %@", error);
            }];
        }
    }];
    
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
