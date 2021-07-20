//
//  ApprenticeViewController.m
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/18.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import "ApprenticeViewController.h"
#import "macro.h"
#import "Masonry.h"
#import "ApprenticeTableViewCell.h"
@import RichOXSect;
@import RichOXBase;

@interface ApprenticeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *apprenticeTab;
@property (nonatomic, strong) RichOXSectApprenticeList *apprentice1List;
@property (nonatomic, strong) RichOXSectApprenticeList *apprentice2List;

@property (nonatomic, strong) UILabel *masterIdLab;

@property (nonatomic, strong) UILabel *contriLab;
@property (nonatomic, strong) UILabel *countLab;

@end

@implementation ApprenticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    // Do any additional setup after loading the view.
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
    titleLab.text = @"弟子信息";
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
        make.left.equalTo(header).offset(20);
        make.centerY.equalTo(header);
        make.width.equalTo(@(50));
    }];
    
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [header addSubview:getBtn];
    
    [getBtn addTarget:self action:@selector(getAll) forControlEvents:UIControlEventTouchUpInside];
    [getBtn setTitle:@"一键领取" forState:UIControlStateNormal];
    [getBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header).offset(-20);
        make.centerY.equalTo(header);
        make.width.equalTo(@(70));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(header.mas_bottom).offset(1);
        make.height.equalTo(@1);
    }];
    
    UILabel *masterIdLab = [[UILabel alloc]init];
    [masterIdLab setTextAlignment:NSTextAlignmentLeft];
    masterIdLab.numberOfLines = -1;
    [self.view addSubview:masterIdLab];
    [masterIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(1);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(80));
    }];
    self.masterIdLab = masterIdLab;
    
    UILabel *countLab = [[UILabel alloc]init];
    countLab.text = @"当前邀请的总人数:";
    [countLab setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(masterIdLab.mas_bottom).offset(1);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(250));
        make.height.equalTo(@(40));
    }];
    self.countLab = countLab;
    
    UILabel *contriLab = [[UILabel alloc]init];
    contriLab.text = @"当前获得总贡献:";
    [contriLab setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:contriLab];
    [contriLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countLab.mas_bottom).offset(1);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(250));
        make.height.equalTo(@(40));
    }];
    self.contriLab = contriLab;
    
    UITableView *apprenticeTab = [[UITableView alloc] init];
    apprenticeTab.delegate = self;
    apprenticeTab.dataSource = self;
    apprenticeTab.userInteractionEnabled = YES;
       
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [apprenticeTab setTableFooterView:view];
    self.apprenticeTab = apprenticeTab;
       
    [self.view addSubview:apprenticeTab];
    
    [apprenticeTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(contriLab.mas_bottom).offset(10);
    }];
    
    [self getApprenticeList];
    
    if (self.overSea) {
        [self getInviteCount];
    }
    
    [self getSectInfo];
}

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getInviteCount {
    [RichOXSectAPI getInviteCount:0 onlyVerified:NO success:^(int inviteCount) {
         dispatch_async(dispatch_get_main_queue(), ^{
            self.countLab.text = [NSString stringWithFormat:@"当前邀请的总人数:%d", inviteCount];
        });
    } failure:^(NSError * _Nonnull error) {
            
    }];
}


- (void) getAll {
    if (self.overSea) {
        [RichOXSectAPI getContribution:nil success:^(int star, int deltaContribution) {
            NSLog(@"*******genContribution测试成功: contribution :%d, deltaContribution： %d", star, deltaContribution);
            [self getApprenticeList];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            self.contriLab.text = [NSString stringWithFormat:@"当前获得总贡献:%d",star];
            });
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******genContribution测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    } else {
        [RichOXSectAPI_F getContribution:nil success:^(int star, int deltaContribution) {
            NSLog(@"*******genContribution测试成功: contribution :%d, deltaContribution： %d", star, deltaContribution);
            [self getApprenticeList];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            self.contriLab.text = [NSString stringWithFormat:@"当前获得总贡献:%d",star];
            });
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******genContribution测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    }
}

- (void)getSectInfo {
    if (self.overSea) {
        [RichOXSectAPI getSectInfo:^(RichOXSectData * _Nonnull data) {
            NSString *info = [NSString stringWithFormat:@"宗主ID: %@ %@验证 邀请弟子数: %d 已验证弟子数: %d 现金兑换次数: %d",data.masterUid, data.verified? @"已":@"未", data.inviteApprenticeCount, data.verifiedApprenticeCount, data.transformCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.masterIdLab.text = info;
                self.contriLab.text = [NSString stringWithFormat:@"当前获得总贡献:%d", data.contribution];
            });
            
        } failure:^(NSError * _Nonnull error) {
                
        }];
    } else {
        [RichOXSectAPI_F getSectInfo:^(RichOXSectData * _Nonnull data) {
            NSString *info = [NSString stringWithFormat:@"宗主ID: %@ %@验证 邀请弟子数: %d 已验证弟子数: %d 现金兑换次数: %d",data.masterUid, data.verified? @"已":@"未", data.inviteApprenticeCount, data.verifiedApprenticeCount, data.transformCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.masterIdLab.text = info;
                self.contriLab.text = [NSString stringWithFormat:@"当前获得总贡献:%d", data.contribution];
                self.countLab.text = [NSString stringWithFormat:@"当前邀请的总人数:%d", data.inviteApprenticeCount];
            });
            
        } failure:^(NSError * _Nonnull error) {
                
        }];
    }
}

- (void)getApprenticeList {
    if (self.overSea) {
        [RichOXSectAPI getApprenticeList:1 pageSize:0 currentPage:0 success:^(RichOXSectApprenticeList * _Nonnull data) {
            self.apprentice1List = data;
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******getApprenticeList测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
        
        [RichOXSectAPI getApprenticeList:2 pageSize:0 currentPage:0 success:^(RichOXSectApprenticeList * _Nonnull data) {
            self.apprentice2List = data;
            dispatch_async(dispatch_get_main_queue(), ^{
            [self.apprenticeTab reloadData];
            });
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******getApprenticeList测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    } else {
        [RichOXSectAPI_F getApprenticeList:1 pageSize:0 currentPage:0 success:^(RichOXSectApprenticeList * _Nonnull data) {
            self.apprentice1List = data;
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******getApprenticeList测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
        
        [RichOXSectAPI_F getApprenticeList:2 pageSize:0 currentPage:0 success:^(RichOXSectApprenticeList * _Nonnull data) {
            self.apprentice2List = data;
            dispatch_async(dispatch_get_main_queue(), ^{
            [self.apprenticeTab reloadData];
            });
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******getApprenticeList测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    }
}

#pragma mark <UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.apprentice1List != nil && self.apprentice1List.apprenticeList != nil? [self.apprentice1List.apprenticeList count] : 0;
            
        case 1:
            return self.apprentice1List != nil && self.apprentice2List.apprenticeList != nil? [self.apprentice2List.apprenticeList count] : 0;
            
        default:
            return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    view.backgroundColor = [UIColor grayColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.frame.size.width-20, 16)];
    
    headerLabel.font = [UIFont boldSystemFontOfSize:15.0];
    headerLabel.textColor = [UIColor whiteColor];
    if (section == 0) {
        headerLabel.text = [NSString stringWithFormat:@"一级弟子 人数%d", self.apprentice1List != nil ? self.apprentice1List.total:0];
    } else {
        headerLabel.text = [NSString stringWithFormat:@"二级弟子 人数%d", self.apprentice2List != nil ? self.apprentice2List.total:0];
    }
    
    [view addSubview:headerLabel];
   
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"apiCellIdentifier";
    ApprenticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ApprenticeTableViewCell alloc] init];
    }
    RichOXSectApprenticeData *data = nil;
    if (indexPath.section == 0) {
        data = self.apprentice1List.apprenticeList[indexPath.row];
    } else {
        data = self.apprentice2List.apprenticeList[indexPath.row];
    }
    [cell setName:data.apprenticeUid totalContribution:data.totalContribution contribution:data.contribution];
    
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
