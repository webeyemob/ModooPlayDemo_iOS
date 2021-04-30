//
//  ReportAppEventViewController.m
//  RichOXDemo
//
//  Created by zena.tang on 2021/4/30.
//  Copyright © 2021 richox. All rights reserved.
//

#import "ReportAppEventViewController.h"
@import RichOXBase;
#import "Masonry.h"
#import "macro.h"

@interface ReportAppEventViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UITextField *valueText;
@property (nonatomic, strong) UITextField *countText;

@end

@implementation ReportAppEventViewController

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
    titleLab.text = @"发送应用内事件";
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
    
    UILabel *eventNamelab = [[UILabel alloc] init];
    eventNamelab.text = @"事件名称: ";
    [self.view addSubview:eventNamelab];
        
    [eventNamelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(100));
        make.height.equalTo(@(30));
    }];
        
    UITextField *textField = [[UITextField alloc]init];
    [self.view addSubview:textField];
    textField.borderStyle = UITextBorderStyleRoundedRect;

    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(eventNamelab);
        make.left.equalTo(eventNamelab.mas_right).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(30));
    }];
        
    self.nameText = textField;
                
    UILabel *paramLab = [[UILabel alloc] init];
    paramLab.text = @"事件值: ";
    [self.view addSubview:paramLab];
        
    [paramLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(eventNamelab.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(100));
        make.height.equalTo(@(30));
    }];
        
    UITextField *paramTextField = [[UITextField alloc]init];
    [self.view addSubview:paramTextField];
    paramTextField.borderStyle = UITextBorderStyleRoundedRect;

    [paramTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paramLab);
        make.left.equalTo(paramLab.mas_right).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(30));
    }];
        
    self.valueText = paramTextField;
    
    UILabel *countLab = [[UILabel alloc] init];
    countLab.text = @"事件次数: ";
    [self.view addSubview:countLab];
        
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paramLab.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(100));
        make.height.equalTo(@(30));
    }];
        
    UITextField *countField = [[UITextField alloc]init];
    [self.view addSubview:countField];
    countField.borderStyle = UITextBorderStyleRoundedRect;
    countField.delegate = self;
    [countField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countLab);
        make.left.equalTo(countLab.mas_right).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(30));
    }];
        
    self.countText = countField;
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:sendBtn];
    [sendBtn setTitle:@"发送事件" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [sendBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [sendBtn addTarget:self action:@selector(sendEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countField.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(150));
        make.height.equalTo(@(30));
    }];
    
}

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.countText){
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11) return NO;//限制长度
        return YES;
    }else{
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if ( proposedNewLength > 20) return NO;//限制长度
        return YES;
    }
}

- (void)sendEvent {
    if (self.nameText.text == nil || [self.nameText.text isEqualToString:@""]) {
        return;
    }
    
    if (self.valueText.text != nil && ![self.valueText.text isEqualToString:@""]) {
        [RichOXBaseManager reportAppEvent:self.nameText.text eventValue:self.valueText.text];
    } else {
        if (self.countText.text != nil && ![self.countText.text isEqualToString:@""]) {
            int count = [self.countText.text intValue];
            
            for (int i=0; i< count; i++) {
                [RichOXBaseManager reportAppEvent:self.nameText.text eventValue:nil];
            }
        } else {
            [RichOXBaseManager reportAppEvent:self.nameText.text eventValue:nil];
        }
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
