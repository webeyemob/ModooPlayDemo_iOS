//
//  PiggyBankViewController.m
//  ModooPlayDemo
//
//  Created by moodoo on 2021/6/25.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import "PiggyBankViewController.h"
#import "PiggyBankTableViewCell.h"
@import RichOXBase;
#import <Masonry/Masonry.h>
#import "macro.h"

@interface PiggyBankViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *progressTab;

@property (nonatomic, strong) NSArray<RichOXPiggyBankObject *> *piggyBanks;

@end

@implementation PiggyBankViewController

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
    titleLab.text = @"储蓄罐测试";
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
    [self prepareData];
    
    [self.view addSubview:self.progressTab];
    [self.progressTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(header.mas_bottom).offset(1);
    }];
}

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

- (void)prepareData {
    [RichOXPiggyBank queryPiggyBankList:^(NSArray<RichOXPiggyBankObject *> *piggyBanks) {
        self.piggyBanks = piggyBanks;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressTab reloadData];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"queryPiggyBankList error: %@", error);
    }];
}

#pragma mark <UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.piggyBanks == nil) {
        return 0;
    }
    return [self.piggyBanks count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"pregressCellIdentifier";
    PiggyBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PiggyBankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    RichOXPiggyBankObject *item = self.piggyBanks[indexPath.row];
    
    [cell setName:item.piggyBankName amount:item.prizeAmount assetName:item.toAssetName block:^{
        [RichOXPiggyBank piggyBankWithdraw:item.piggyBankId success:^() {
            [self prepareData];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"piggyBankWithdraw error: %@", error);
        }];
    }];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
