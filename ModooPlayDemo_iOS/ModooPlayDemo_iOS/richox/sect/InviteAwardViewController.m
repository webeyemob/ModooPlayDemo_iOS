//
//  InviteAwardViewController.m
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/18.
//  Copyright © 2021 fissionsdk. All rights reserved.
//

#import "InviteAwardViewController.h"
#import "macro.h"
#import "Masonry.h"
@import RichOXSect;
#import "inviteAwardObject.h"
#import "InviteAwardTableViewCell.h"

@interface InviteAwardViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *inviteAwardTab;
@property (nonatomic, strong) NSMutableArray <inviteAwardObject *>*inviteAwardList;

@end

@implementation InviteAwardViewController

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
    titleLab.text = @"招募奖励";
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
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(header.mas_bottom).offset(1);
        make.height.equalTo(@1);
    }];
    
    UITableView *inviteAwardTab = [[UITableView alloc] init];
    inviteAwardTab.delegate = self;
    inviteAwardTab.dataSource = self;
    inviteAwardTab.userInteractionEnabled = YES;
       
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [inviteAwardTab setTableFooterView:view];

    [self.view addSubview:inviteAwardTab];
    
    [inviteAwardTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(line.mas_bottom).offset(1);
    }];
        
    self.inviteAwardTab = inviteAwardTab;
    
    [self getInviteAwardSetting];
    self.inviteAwardList = [NSMutableArray new];
}

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getInviteAwardSetting {
    [RichOXSectInvite getInviteAwardSetting:^(NSArray<RichOXSectInviteAwardsSettingData *> * _Nonnull list) {
        NSMutableString *resultdata = [NSMutableString new];
        if ([list count] > 0) {
            for (RichOXSectInviteAwardsSettingData *data in list) {
                inviteAwardObject *object = [[inviteAwardObject alloc] initWithCount:data.count awardType:data.awardType value:data.awardValue];
                [self.inviteAwardList addObject:object];
                
                [resultdata appendString:[data description]];
                [resultdata appendString:@";"];
            }
        }
        
        NSLog(@"******* getInviteAwardSetting ******* 测试成功: %@", resultdata);
        
        [RichOXSectAPI_F getSectInfo:^(RichOXSectData * _Nonnull data) {
            NSLog(@"******* getSectInfo ******* 测试成功: %@", [data description]);
            if (data.inviteAwardInfo != nil) {
                for (inviteAwardObject *object in self.inviteAwardList) {
                    NSString *key = [NSString stringWithFormat:@"%d", object.count];
                    BOOL hasFetch = [data.inviteAwardInfo[key] boolValue];
                    object.hasFetch = hasFetch;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.inviteAwardTab reloadData];
            });
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.inviteAwardTab reloadData];
            });
            NSLog(@"******* getSectInfo ******* 测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"******* getApprenticeList *******测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
    }];
}

#pragma mark <UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.inviteAwardList count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"iaCellIdentifier";
    InviteAwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[InviteAwardTableViewCell alloc] init];
    }
    inviteAwardObject *data = self.inviteAwardList[indexPath.row];
    
    NSString *awardStr = [NSString stringWithFormat:@"%.2f %@", data.value, data.awardType==0?@"贡献值":@"现金"];
    
    [cell setCount:data.count award:awardStr hasFetch:data.hasFetch];
    
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
