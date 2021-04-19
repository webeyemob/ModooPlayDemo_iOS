//
//  RichOXMissionViewController.m
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/21.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import "RichOXMissionViewController.h"
#import "macro.h"
#import "Masonry.h"
@import RichOXBase;
#import "MissionTableViewCell.h"
#import "UIView+Toast.h"

@interface RichOXMissionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *missionTab;
@property (nonatomic, strong) UITextField *missionIdText;
@property (nonatomic, strong) NSArray <RichOXMissionData *>*missions;

@end

@implementation RichOXMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    titleLab.text = @"激励任务";
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
    
    UILabel *missionIdlab = [[UILabel alloc] init];
    missionIdlab.text = @"任务ID: ";
    [self.view addSubview:missionIdlab];
    
    [missionIdlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(100));
        make.height.equalTo(@(30));
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.text = @"IOS_Demo_Mission_Test";
    [self.view addSubview:textField];
    textField.borderStyle = UITextBorderStyleRoundedRect;

    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(missionIdlab);
        make.left.equalTo(missionIdlab.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(30));
    }];
    
    self.missionIdText = textField;
    
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:getBtn];
    [getBtn setTitle:@"获取任务列表" forState:UIControlStateNormal];
    getBtn.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0];
    [getBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [getBtn addTarget:self action:@selector(getMissionInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(150));
        make.height.equalTo(@(30));
    }];
    
    UITableView *missionTab = [[UITableView alloc] init];
    missionTab.delegate = self;
    missionTab.dataSource = self;
    missionTab.userInteractionEnabled = YES;
           
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [missionTab setTableFooterView:view];

    [self.view addSubview:missionTab];
        
    [missionTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(getBtn.mas_bottom).offset(1);
    }];
            
    self.missionTab = missionTab;
}

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toastFailureInfo:(NSString *)functionName error:(NSError *)error {
    NSLog(@"******* %@ ******* 测试失败: errorCode: %ld, message:%@",functionName, error.code, error.localizedDescription);
    NSString *message = [NSString stringWithFormat:@"%@ 测试失败，errorCode: %ld, message: %@", functionName, error.code, error.localizedDescription];
     dispatch_async(dispatch_get_main_queue(), ^{
    [self.view makeToast:message duration:5.0 position:CSToastPositionCenter];
     });
}

- (void)getMissionInfo {
    [RichOXMission getMissionInfo:^(NSArray <RichOXMissionData *>*datas) {
        if (datas == nil || [datas count] <= 0) {
            NSLog(@"******* getMissionInfo ********测试成功，没有任务");
        } else {
            self.missions = datas;
            
            NSMutableString *result = [NSMutableString new];
            for (RichOXMissionData *data in datas){
                [result appendString:[data description]];
                [result appendString:@";"];
            }
            
            NSLog(@"*******getMissionInfo ********测试成功，datas is [%@]", result);
            
             dispatch_async(dispatch_get_main_queue(), ^{
            [self.missionTab reloadData];
             });
        }
    } failure:^(NSError *error) {
         [self toastFailureInfo:@"getMissionInfo" error:error];
    }];
}

#pragma mark <UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.missions != nil ? [self.missions count] : 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"missionCellIdentifier";
    MissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MissionTableViewCell alloc] init];
    }
    RichOXMissionData *data = self.missions[indexPath.row];
        
    [cell setItem:data];
        
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
