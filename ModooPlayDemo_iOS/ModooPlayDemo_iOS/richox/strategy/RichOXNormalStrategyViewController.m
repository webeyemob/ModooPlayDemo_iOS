//
//  RichOXNormalStrategyViewController.m
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/14.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import "RichOXNormalStrategyViewController.h"
#import "StrategyProgessTableViewCell.h"
@import RichOXBase;
@import RichOXNormalStrategy;
#import <Masonry/Masonry.h>
#import "macro.h"
#import "UIView+Toast.h"

@interface RichOXNormalStrategyViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSArray<RichOXNormalStrategyItem *> * strategyList;
@property (nonatomic, strong) NSArray <RichOXNormalStrategyTask *>* taskList;

@property (nonatomic, strong) UITableView *progressTab;
@property (nonatomic, strong) UIView *buttonContainer;

@property (nonatomic) NSUInteger currentAmount;

@property (nonatomic, strong) UITextField *stragegyIdText;
@property (nonatomic, strong) NSString *lastId;

@property (nonatomic, strong) RichOXNormalStrategyInstance *stragegyInstance;

@property (nonatomic, strong) UIView *exchangeContainer;

@property (nonatomic, strong) NSArray <RichOXNormalStrategyAssetStatus *>* currentAssets;

@property (nonatomic, strong) NSArray <RichOXNormalStrategyAssetExchangeInfo *> *exchangeInfo;

@property (nonatomic, strong) UIView *popView;
@property (nonatomic, strong) UITextField *assetExchangeAmountText;
@property (nonatomic, strong) UIButton *exchangeBtn;

@property (nonatomic, strong) UILabel *exchangeLab;


@end


@implementation RichOXNormalStrategyViewController

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
    titleLab.text = @"通用策略测试";
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
        make.width.equalTo(@(100));
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
        make.top.equalTo(header.mas_bottom).offset(1);
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
            self.stragegyInstance = [RichOXNormalStrategyInstance getNormalStrategy:self.stragegyIdText.text];
        }

        [self.stragegyInstance syncList:^(RichOXNormalStrategySetting *setting) {
                self.strategyList = setting.withdrawSetting;
                self.taskList = setting.taskInfo.tasks;
                self.exchangeInfo = setting.taskInfo.exchangeInfos;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addButtonToContainer];
                    [self addExchangeView];
                });
                [self.stragegyInstance syncCurrentPrize:^(RichOXNormalStrategyStatus *status) {
                    self.currentAssets = status.assetInfos;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.progressTab reloadData];
                    });
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"sync stage strategy failed: %@", error);
                    dispatch_async(dispatch_get_main_queue(), ^{
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
    if (count > 5) {
        count = 5;
    }
    float width = (ScreenWidth - (count + 1) *30)/count;
    for (int i = 0; i < count; i++) {
        RichOXNormalStrategyTask *task = self.taskList[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i;
        btn.frame = CGRectMake(30 + (30 + width)*i, 20, width, 60);
        btn.backgroundColor = [UIColor greenColor];
        [btn setTitle:[NSString stringWithFormat:@"%.2f", task.prizeAmount] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doTask:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonContainer addSubview:btn];
    }
}

- (void)addExchangeView {
    NSUInteger count = [self.exchangeInfo count];
    
    if (count > 3) {
        count = 3;
    }
    
    float height = 120/count;
    for (int i = 0; i < count; i++) {
        RichOXNormalStrategyAssetExchangeInfo *exchangeInfo = self.exchangeInfo[i];
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, i*height, ScreenWidth, height-1)];
        [self.exchangeContainer addSubview:tempView];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (i+1)*height, ScreenWidth, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.exchangeContainer addSubview:line];
        
        UILabel *fromLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3, height-1)];
        [fromLab setText:[NSString stringWithFormat:@"%.2f %@", exchangeInfo.fromPrizeAmount, exchangeInfo.fromAssetName]];
        fromLab.textAlignment = NSTextAlignmentCenter;
        [tempView addSubview:fromLab];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i;
        btn.frame = CGRectMake(ScreenWidth/3, 0, ScreenWidth/3, height-1);
        btn.backgroundColor = [UIColor blueColor];
        [btn setTitle:@"兑换" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doExchange:) forControlEvents:UIControlEventTouchUpInside];
        [tempView addSubview:btn];
        
        UILabel *toLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*2/3, 0, ScreenWidth/3, height-1)];
        [toLab setText:[NSString stringWithFormat:@"%.2f %@", exchangeInfo.toPrizeAmount, exchangeInfo.toAssetName]];
        toLab.textAlignment = NSTextAlignmentCenter;
        [tempView addSubview:toLab];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (void)doExchange:(UIButton *)btn {
    if (self.popView == nil) {
        self.popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
        self.popView.backgroundColor = [UIColor lightGrayColor];
        self.popView.center = self.view.center;
        self.popView.layer.cornerRadius = 13;
        [self.view addSubview:self.popView];
        
        self.exchangeLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 60, 40)];
        [self.popView addSubview:self.exchangeLab];
        
        self.assetExchangeAmountText = [[UITextField alloc] initWithFrame:CGRectMake(80, 40, 200, 40)];
        self.assetExchangeAmountText.layer.cornerRadius = 10;
        self.assetExchangeAmountText.borderStyle = UITextBorderStyleRoundedRect;
        self.assetExchangeAmountText.delegate = self;
        [self.popView addSubview:self.assetExchangeAmountText];
        
        self.exchangeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.exchangeBtn.frame = CGRectMake(0, 100, 150, 40);
        [self.popView addSubview:self.exchangeBtn];
        [self.exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
        [self.exchangeBtn addTarget:self action:@selector(toExchange) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(150, 100, 150, 40);
        [self.popView addSubview:closeBtn];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closePopView) forControlEvents:UIControlEventTouchUpInside];
    }
    self.popView.hidden = NO;
    
    RichOXNormalStrategyAssetExchangeInfo *exchangeInfo = self.exchangeInfo[btn.tag];
    
    self.exchangeLab.text = exchangeInfo.fromAssetName;
    
    int maxAmount = 0;
    
    for (RichOXNormalStrategyAssetStatus *assetInfo in self.currentAssets) {
        if ([assetInfo.name isEqualToString:exchangeInfo.fromAssetName]) {
            maxAmount = assetInfo.amount;
            break;
        }
    }
    
    self.exchangeBtn.tag = btn.tag;
    
    self.assetExchangeAmountText.text = [NSString stringWithFormat:@"%d", maxAmount];
}

- (void)closePopView {
    self.popView.hidden = YES;
}

- (void)toExchange {
    RichOXNormalStrategyAssetExchangeInfo *exchangeInfo = self.exchangeInfo[self.exchangeBtn.tag];
    
    float maxAmount = 0;
    
    for (RichOXNormalStrategyAssetStatus *assetInfo in self.currentAssets) {
        if ([assetInfo.name isEqualToString:exchangeInfo.fromAssetName]) {
            maxAmount = assetInfo.amount;
            break;
        }
    }
    
    float amount = [self.assetExchangeAmountText.text floatValue];
    if (amount > maxAmount) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.view makeToast:@"asset not enought" duration:3.0 position:CSToastPositionCenter];
        });
    } else {
        [self.stragegyInstance exchangeAsset:exchangeInfo.exchangeId coin:amount success:^(RichOXNormalStrategyExchangeResult * _Nonnull result) {
            self.currentAssets = result.assetStatus;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressTab reloadData];
            });
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"exchange fail" duration:3.0 position:CSToastPositionCenter];
            });
        }];
        
        self.popView.hidden = YES;
    }
}



- (void)doTask:(UIButton *)btn {
    RichOXNormalStrategyTask *task = self.taskList[btn.tag];
    float amount = task.prizeAmount;
    if (task.prizeType == RICHOX_NR_PRIZE_TYPE_MAX) {
        int x=arc4random() % 5 +1;
        amount = amount * x / 5;
    }
        
    [self.stragegyInstance doMission:task.taskId prizeAmount:amount success:^(RichOXNormalStrategyTaskResult *result) {
        self.currentAssets = result.assetStatus;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressTab reloadData];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"doMission failed: %@", error);
    }];
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
            
        [cell setName:item.packageId progress:progress packetId:item.packageId status: 0 block:^() {
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
