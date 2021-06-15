//
//  RichOXViewController.m
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/28.
//  Copyright © 2021 moodoo. All rights reserved.
//

#import "RichOXViewController.h"
#import "macro.h"
#import "UIView+Toast.h"
#import "RichOXActivityViewController.h"
#import "RichOXShareViewController.h"
#import "RichOXStageStrategyViewController.h"
#import "RichOXStageStrategyRViewController.h"
#import "RichOXNormalStrategyViewController.h"

#import "RichOXShareViewController.h"
#import "ApprenticeViewController.h"
//#import "InviteAwardViewController.h"
#import "RichOXMissionViewController.h"
#import "ReportAppEventViewController.h"
@import RichOXBase;
@import RichOXFission_Moblink;
@import RichOXSect;
#import <Masonry/Masonry.h>
#import "WXLoginViewController.h"
#import "NewLoginViewController.h"

#define WITHDRAW_TEST_MISSION_ID @""
#define WXWITHDRAW_TEST_MISSION_ID @""


@interface RichOXViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *sortedArray;


@property (nonatomic, strong) NSString *recordId;
@property (nonatomic, strong) NSString *missionId;

@property (nonatomic, strong) NSString *inviteMissionId;

@end

@implementation RichOXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [RichOXBaseManager setOverSea];
    [RichOXBaseManager initWithAppId:@""];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view
    _sortedArray = @[@{
                         @"H5活动": @[@"活动测试页面"]},
                     @{@"基础功能":@[@"游客注册",@"绑定社交账号",@"微信用户注册", @"获取激励任务",@"激励任务记录查询",@"今日金币获取信息查询",@"获取提现信息",@"提现请求",@"提现微信"]},
                     @{@"海外用户":@[@"游客注册",@"绑定社交账号",@"获取用户信息",@"获取邀请人基本信息",@"用户注销"]},
                     @{@"分享":@[@"打开分享页面"]},
                     @{@"宗门":@[@"获取弟子信息",@"产生贡献", @"获取宗门设置", @"获取邀请弟子排行"]},
                     @{@"策略": @[@"阶梯策略测试页面(F)", @"阶梯策略测试页面(R)", @"通用策略测试页面"]},
                     @{@"应用内事件": @[@"发送应用内事件"]}
    ];
    
    UIView *header = [[UIView alloc] init];
    
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kTopBarSafeHeight);
        make.bottom.equalTo(self.view.mas_top).offset(kTopBarSafeHeight+20);
    }];
    
    UILabel *titleLab =  [[UILabel alloc]init];
    titleLab.text = @"RichOX测试";
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
    
    [RichOXFission showShare];
}

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark <UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sortedArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *testItem = [_sortedArray[section] allValues][0];
    return testItem.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
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
    headerLabel.text = [_sortedArray[section] allKeys][0];
    
    [view addSubview:headerLabel];
   
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"apiCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    NSArray *name = [_sortedArray[indexPath.section] allValues][0];
    
    cell.textLabel.text = name[indexPath.row];
    [cell.textLabel setTextColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *names = [_sortedArray[indexPath.section] allValues][0];
    
    NSString *testItem = names[indexPath.row];
    switch (indexPath.section) {
        case 0://活动测试
            [self activityTest:testItem];
            break;
            
        case 1://基础测试
            [self baseTest:testItem];
            break;
            
        case 2://海外用户测试
            [self userNewAPITest:testItem];
            break;
        
        case 3://分享测试
            [self shareTest:testItem];
            break;
            
        case 4://宗门测试
            [self sectTest:testItem];
            break;
            
        case 5://策略测试
            [self strageTest:testItem];
            break;
            
        case 6://应用内事件上报测试
            [self reportAppEventTest:testItem];
            break;
            
        default:
            break;
    }
}

- (void)activityTest:(NSString *)testItem {
    RichOXActivityViewController *vc = [[RichOXActivityViewController alloc] init];
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)toastFailureInfo:(NSString *)functionName error:(NSError *)error {
    NSLog(@"******* %@ ******* 测试失败: errorCode: %zd, message:%@",functionName, error.code, error.localizedDescription);
    NSString *message = [NSString stringWithFormat:@"%@ 测试失败，errorCode: %zd, message: %@", functionName, error.code, error.localizedDescription];
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.view makeToast:message duration:5.0 position:CSToastPositionCenter];
    });
}


- (void)baseTest:(NSString *)testItem {
    if ([testItem isEqualToString:@"游客注册"]) {
        [RichOXUser registerUserId:nil initInfo: nil success:^(RichOXUserData *userData) {
            NSLog(@"*******registerUserId测试成功: userData: %@", [userData description]);
        } failure:^(NSError *error) {
            [self toastFailureInfo:@"registerUserId" error:error];
        }];
    } else if ([testItem isEqualToString:@"绑定社交账号"] || [testItem isEqualToString:@"社交账号绑定检查"]) {
        //todo 进入下一个页面登录社交账号
        WXLoginViewController *loginVC = [[WXLoginViewController alloc] init];
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
    } else if ([testItem isEqualToString:@"获取用户信息"]) {
        [RichOXUser getUserInfo:^(RichOXUserData *userData) {
            NSLog(@"*******getUserInfo测试成功: userData: %@", [userData description]);
        } failure:^(NSError *error) {
            [self toastFailureInfo:@"getUserInfo" error:error];
        }];
    }
    else if ([testItem isEqualToString:@"获取激励任务"]) {
        RichOXMissionViewController *vc = [[RichOXMissionViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    } else if ([testItem isEqualToString:@"激励任务记录查询"]) {
        [RichOXMission getMissionRecord:nil days:1 pageSize:0 pageIndex:0 success:^(RichOXMissionQueryResult *result) {
             NSLog(@"*******missionQuary测试成功:  result:%@", [result description]);
        } failure:^(NSError *error){
             [self toastFailureInfo:@"missionQuary" error:error];
         }];
    } else if ([testItem isEqualToString:@"今日金币获取信息查询"]) {
        [RichOXMission getTodayCoins:^(RichOXMissionTodayCoinsResult *result) {
            //今日金币获取信息
            NSLog(@"*******getTodayCoins测试成功:  result:%@", [result description]);
        } failure:^(NSError *error){
            [self toastFailureInfo:@"getTodayCoins" error:error];
        }];
    } else if ([testItem isEqualToString:@"获取提现信息"]) {
        [RichOXWithdraw getWithdrawInfo:^(RichOXWithdrawData *data) {
            NSLog(@"*******getWithdrawInfo测试成功: data: %@", [data description]);
        } failure:^(NSError *error){
             [self toastFailureInfo:@"getWithdrawInfo" error:error];
        }];
    } else if ([testItem isEqualToString:@"提现请求"]) {
        RichOXWithdrawInfo *info = [[RichOXWithdrawInfo alloc] initWithPayremark:@"测试提现请求"];
        info.realName = @"张三";
        info.idCard = @"320XXXXX";
        info.phoneNo = @"1334566777";
        
        [RichOXWithdraw requestWithdraw:WITHDRAW_TEST_MISSION_ID info:info success:^(RichOXWithdrawResult *result) {
             //返回签到记录
            NSLog(@"*******requestWithdraw测试成功: result: %@", [result description]);
        }  failure:^(NSError *error){
             [self toastFailureInfo:@"requestWithdraw" error:error];
        }];
    } else if ([testItem isEqualToString:@"微信提现"]) {
        [RichOXWithdraw requestWeChatPay:WXWITHDRAW_TEST_MISSION_ID payRemark:@"测试微信提现请求" comment:nil  success:^(RichOXWithdrawResult *result) {
             NSLog(@"*******requestWXPay测试成功: result: %@", [result description]);
        } failure:^(NSError *error){
             [self toastFailureInfo:@"requestWXPay" error:error];
        }];
    }
}

- (void)userNewAPITest:(NSString *)testItem {
    if ([testItem isEqualToString:@"游客注册"]) {
        [RichOXUserManager registerUserId:^(RichOXUserObject *userData) {
            NSLog(@"*******new registerUserId测试成功: userData: %@", [userData description]);
        } failure:^(NSError *error) {
            NSLog(@"*******registerUserId测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    } else if ([testItem isEqualToString:@"绑定社交账号"]) {
        //todo 进入下一个页面登录社交账号
        NewLoginViewController *loginVC = [[NewLoginViewController alloc] init];
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
    } else if ([testItem isEqualToString:@"获取用户信息"]) {
        [RichOXUserManager getUserInfo:^(RichOXUserObject *userData) {
            NSLog(@"*******new getUserInfo测试成功: userData: %@", [userData description]);
            if (userData != nil) {
                NSString *invitationCode = userData.invitationCode;
                NSLog(@"*******当前用户的邀请码是====: %@ :", invitationCode);
            }
        } failure:^(NSError *error) {
            NSLog(@"*******getUserInfo测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    } else if ([testItem isEqualToString:@"获取邀请人基本信息"]) {
        [RichOXUserManager getInviter: ^(RichOXUserBaseObject *userData) {
            NSLog(@"*******getInviter测试成功: userData: %@", userData);
        } failure:^(NSError *error) {
            NSLog(@"*******getUserBaseInfo测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    } else if ([testItem isEqualToString:@"用户注销"]) {
        [RichOXUserManager logOutUser:^{
            NSLog(@"*******logOutUser 测试成功");
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******logOutUser测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    }
}

- (void)shareTest:(NSString *)testItem {
    RichOXShareViewController *vc = [[RichOXShareViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [RichOXFission openSharePage];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)sectTest:(NSString *)testItem {
    if ([testItem isEqualToString:@"获取弟子信息"]) {
        ApprenticeViewController *vc = [[ApprenticeViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    } else if ([testItem isEqualToString:@"产生贡献"]) {
        [RichOXSectInfo genContribution:0 success:^(int star) {
            NSLog(@"*******genContribution测试成功: star :%d", star);
        } failure:^(NSError * _Nonnull error) {
            [self toastFailureInfo:@"genContribution" error:error];
        }];
    } else if ([testItem isEqualToString:@"获取宗门设置"]) {
        [RichOXSectInfo getSetting:^(RichOXSectSettingData * _Nonnull data) {
            NSLog(@"*******getSetting测试成功: data: %@", [data description]);
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******getSetting测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    } else if ([testItem isEqualToString:@"获取邀请弟子排行"]) {
        [RichOXSectInfo getRankingList:^(NSArray <RichOXSectRankingObject *>*rankingList) {
            NSMutableString *desc = [NSMutableString new];
            for (RichOXSectRankingObject *item in rankingList){
                [desc appendString:[item description]];
                [desc appendString:@";"];
            }
            NSLog(@"*******getRankingList 测试成功: data: %@", desc);
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******getRankingList 测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    }
}

- (void)strageTest:(NSString *)testItem {
    if ([testItem isEqualToString:@"阶梯策略测试页面(F)"]) {
        RichOXStageStrategyViewController *testPage = [[RichOXStageStrategyViewController alloc] init];
        testPage.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:testPage animated:YES completion:nil];
    } else if ([testItem isEqualToString:@"阶梯策略测试页面(R)"]) {
        RichOXStageStrategyRViewController *testPage = [[RichOXStageStrategyRViewController alloc] init];
        testPage.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:testPage animated:YES completion:nil];
    } else if ([testItem isEqualToString:@"通用策略测试页面"]) {
        RichOXNormalStrategyViewController *testPage = [[RichOXNormalStrategyViewController alloc] init];
        testPage.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:testPage animated:YES completion:nil];
    }
}

- (void)reportAppEventTest:(NSString *)testItem {
    ReportAppEventViewController *testPage = [[ReportAppEventViewController alloc] init];
    
    [self presentViewController:testPage animated:YES completion:nil];
}

@end
