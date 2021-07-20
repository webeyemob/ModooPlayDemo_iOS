//
//  RichOXSectInViewController.m
//  ModooPlayDemo_iOS
//
//  Created by ModooPlay on 2021/7/20.
//  Copyright © 2021 ModooPlay. All rights reserved.
//

#import "RichOXSectInViewController.h"
#import "ApprenticeViewController.h"
#import <Masonry/Masonry.h>
#import "macro.h"
#import "UIView+Toast.h"
@import RichOXSect;
#import "InviteAwardViewController.h"

@interface RichOXSectInViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *sortedArray;

@end

@implementation RichOXSectInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view
    _sortedArray = @[@"获取宗门状态", @"获取弟子信息", @"产生贡献", @"获取宗门设置", @"获取贡献记录", @"现金兑换", @"获取红包记录", @"邀请奖励"];
    
    UIView *header = [[UIView alloc] init];
    
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kTopBarSafeHeight);
        make.bottom.equalTo(self.view.mas_top).offset(kTopBarSafeHeight+20);
    }];
    
    UILabel *titleLab =  [[UILabel alloc]init];
    titleLab.text = @"宗门模块测试（国内）";
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
    
    UITableView *apisTab = [[UITableView alloc] init];
    apisTab.delegate = self;
    apisTab.dataSource = self;
    apisTab.userInteractionEnabled = YES;
       
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [apisTab setTableFooterView:view];
    
       
    [self.view addSubview:apisTab];
    
    [apisTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(header.mas_bottom).offset(1);
    }];
}

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark <UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sortedArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"sectApiCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    cell.textLabel.text = _sortedArray[indexPath.row];
    [cell.textLabel setTextColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0]];
    return cell;
}

- (void)toastFailureInfo:(NSString *)functionName error:(NSError *)error {
    NSLog(@"******* %@ ******* 测试失败: errorCode: %zd, message:%@",functionName, error.code, error.localizedDescription);
    NSString *message = [NSString stringWithFormat:@"%@ 测试失败，errorCode: %zd, message: %@", functionName, error.code, error.localizedDescription];
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.view makeToast:message duration:5.0 position:CSToastPositionCenter];
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     NSString *testItem = _sortedArray[indexPath.row];
    if ([testItem isEqualToString:@"获取宗门状态"]) {
        [RichOXSectAPI_F getSectStatus:^(RICHOX_SECT_STATUS_TYPE status) {
            NSLog(@"*******getSectStatus测试成功: %d", status);
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******getSectStatus测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    } else if ([testItem isEqualToString:@"获取弟子信息"]) {
        ApprenticeViewController *vc = [[ApprenticeViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    } else if ([testItem isEqualToString:@"产生贡献"]) {
        [RichOXSectAPI_F genContribution:0 success:^(int star) {
            NSLog(@"*******genContribution测试成功: star :%d", star);
        } failure:^(NSError * _Nonnull error) {
            [self toastFailureInfo:@"genContribution" error:error];
        }];
    } else if ([testItem isEqualToString:@"获取宗门设置"]) {
        [RichOXSectAPI_F getSetting:^(RichOXSectSettingData * _Nonnull data) {
            NSLog(@"*******getSetting测试成功: data: %@", [data description]);
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******getSetting测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    } else if ([testItem isEqualToString:@"获取贡献记录"]) {
        [RichOXSectAPI_F getContributionDayRecord:2021 month:7 success:^(NSDictionary * _Nonnull record) {
            NSLog(@"*******getContributionDayRecord测试成功: record: %@", [record description]);
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******getContributionDayRecord测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    } else if ([testItem isEqualToString:@"现金兑换"]) {
        [RichOXSectAPI_F transform:^(RichOXSectTransformResult * _Nonnull result) {
            NSLog(@"*******transform测试成功: result: %@", [result description]);
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******transform测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    } else if ([testItem isEqualToString:@"获取红包记录"]) {
        [RichOXSectAPI_F getRedPacketRecord:0 curPage:0 success:^(RichOXSectRedPacketRecord * _Nonnull record) {
            NSLog(@"*******getRedPacketRecord测试成功: record: %@", [record description]);
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******getRedPacketRecord测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    }  else if ([testItem isEqualToString:@"邀请奖励"]) {
        InviteAwardViewController *vc = [[InviteAwardViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
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
