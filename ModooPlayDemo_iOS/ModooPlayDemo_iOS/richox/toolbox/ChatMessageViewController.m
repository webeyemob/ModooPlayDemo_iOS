//
//  ChatMessageViewController.m
//  ModooPlayDemo
//
//  Created by moodoo on 2021/7/27.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import "ChatMessageViewController.h"
#import <Masonry/Masonry.h>
#import "macro.h"
#import "ChatMessageTableViewCell.h"
@import RichOXToolBox;

@interface ChatMessageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *msgTab;

@end

@implementation ChatMessageViewController

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
    titleLab.text = @"群消息";
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"发消息" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(postMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.height.equalTo(@(40));
        make.top.equalTo(line.mas_bottom).offset(5);
    }];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.backgroundColor = [UIColor greenColor];
    [refreshBtn setTitle:@"刷新群信息" forState:UIControlStateNormal];
    [refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(fetchMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn);
        make.right.equalTo(self.view).offset(-20);
        make.width.equalTo(btn);
        make.left.equalTo(btn.mas_right).offset(40);
        make.bottom.equalTo(btn);
    }];
    
    [self.view addSubview:self.msgTab];
    [self.msgTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(btn.mas_bottom).offset(5);
        make.bottom.equalTo(self.view).offset(-kBottomSafeHeight);
    }];
}

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableView *)msgTab {
    if (!_msgTab) {
        _msgTab = [[UITableView alloc] init];
        _msgTab.delegate = self;
        _msgTab.dataSource = self;
        _msgTab.userInteractionEnabled = YES;
       
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [_msgTab setTableFooterView:view];
    }
    
    return _msgTab;
}

- (void)fetchMessage {
    [RichOXChatGroup getChatMessage:self.groupId count:20 success:^(NSArray<RichOXChatMessage *> * _Nonnull messages) {
        if (messages != nil && [messages count] > 0) {
            [self.messages addObjectsFromArray:messages];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.msgTab reloadData];
            });
        } else {
            NSLog(@"===CHATGROUP===: no message");
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"get message failed: %@", error);
    }];
}

#pragma mark <UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages != nil? [self.messages count] : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"chatgroupCellIdentifier";
    ChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ChatMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
        
    RichOXChatMessage *item = self.messages[indexPath.row];
    [cell setMessageInfo:item];
        
    return cell;
}

- (void)postMessage {
    [RichOXChatGroup sendChatMessage:self.groupId nickName:@"小小" avatar:nil type:@"10" content:@"今天天气真好" success:^(RichOXChatMessage * _Nonnull message) {
        NSLog(@"sendChatMessage success:  %@", [message description]);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"sendChatMessage failed: %@", error);
    }];
}

@end
