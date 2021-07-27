//
//  ChatGroupViewController.m
//  ModooPlayDemo
//
//  Created by moodoo on 2021/7/26.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import "ChatGroupViewController.h"
#import <Masonry/Masonry.h>
#import "macro.h"
@import RichOXToolBox;
#import "ChatGroupTableViewCell.h"
#import "ChatMessageViewController.h"

@interface ChatGroupViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *groupTab;
@property (nonatomic, strong) NSArray <RichOXGroupInfo *> *groups;

@end

@implementation ChatGroupViewController

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
    titleLab.text = @"聊天群";
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
    [RichOXChatGroup init];
    [self fetchGroup];
    
    [self.view addSubview:self.groupTab];
    [self.groupTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(line.mas_bottom).offset(5);
    }];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.backgroundColor = [UIColor greenColor];
    [refreshBtn setTitle:@"刷新群信息" forState:UIControlStateNormal];
    [refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(fetchGroup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(40));
        make.top.equalTo(self.groupTab.mas_bottom).offset(5);
        make.bottom.equalTo(self.view).offset(-kBottomSafeHeight-10);
    }];
}

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableView *)groupTab {
    if (!_groupTab) {
        _groupTab = [[UITableView alloc] init];
        _groupTab.delegate = self;
        _groupTab.dataSource = self;
        _groupTab.userInteractionEnabled = YES;
       
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [_groupTab setTableFooterView:view];
    }
    
    return _groupTab;
}

- (void)fetchGroup {
    [RichOXChatGroup getGroupInfo:^(NSArray<RichOXGroupInfo *> *groups) {
        self.groups = groups;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.groupTab reloadData];
        });
    } failure:^(NSError *err) {
        
    }];
}


#pragma mark <UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups != nil? [self.groups count] : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"chatgroupCellIdentifier";
    ChatGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ChatGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
        
    RichOXGroupInfo *item = self.groups[indexPath.row];
    [cell setGroupInfo:item];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RichOXGroupInfo *item = self.groups[indexPath.row];
    
    [RichOXChatGroup getChatMessage:item.groupId count:20 success:^(NSArray<RichOXChatMessage *> * _Nonnull messages) {
        if (messages != nil && [messages count] > 0) {
            ChatMessageViewController *vc = [[ChatMessageViewController alloc] init];
            vc.groupId = item.groupId;
            vc.messages = [[NSMutableArray alloc] initWithArray:messages];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
            
//            for (RichOXChatMessage *msg in messages) {
//                NSLog(@"===CHATGROUP===:  %@", [msg description]);
//            }
        } else {
            NSLog(@"===CHATGROUP===: no message");
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"get message failed: %@", error);
    }];
    
}

@end
