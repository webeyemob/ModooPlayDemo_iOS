//
//  CustomPrivacyDialog.m
//  TestPolicy
//
//  Created by sherlock.chan on 2021/1/13.
//

#import "CustomPrivacyDialog.h"

@interface CustomPrivacyDialog()
@property(nonatomic,strong)UIView *blackBgView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextView *contentLabel;
@property(nonatomic,strong)UIButton *confirmBtn;
@property(nonatomic,strong)UIButton *vetoBtn;
@property(nonatomic,copy)PPButtonBlock agreeBlock;
@property(nonatomic,copy)PPButtonBlock disagreeBlock;
@end

@implementation CustomPrivacyDialog


-(instancetype)initWithAgreeBlock:(PPButtonBlock)agreeBlock andDisagreeBlock:(PPButtonBlock)disagreeBlock {
    if (self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)]) {
        self.agreeBlock = agreeBlock;
        self.disagreeBlock = disagreeBlock;
        
        [self initView];
    }
    return self;
}

-(void)initView {
    [self addSubview:self.blackBgView];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.contentLabel];
    [self.bgView addSubview:self.vetoBtn];
    [self.bgView addSubview:self.confirmBtn];
    
}

#pragma mark - actions
-(void)vetoAction {
    if (self.disagreeBlock) {
        self.disagreeBlock();
    }
}

-(void)confirmAction {
    if (self.agreeBlock) {
        self.agreeBlock();
    }
    [self removeFromSuperview];
}

#pragma mark - getter
-(UIButton *)confirmBtn {
    if (!_confirmBtn) {
        CGFloat left = self.bgView.frame.size.width - 24 - self.vetoBtn.frame.size.width;

        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(left, self.vetoBtn.frame.origin.y, self.vetoBtn.frame.size.width, self.vetoBtn.frame.size.height)];
        [_confirmBtn setTitle:[self getAgreeText] forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:[UIColor colorWithRed:0x00/255.0f green:0xB8/255.0f blue:0xFF/255.0f alpha:1.0]];
        [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.layer.cornerRadius = 22;
        _confirmBtn.layer.borderWidth = 1;
        _confirmBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _confirmBtn;
}

-(UIButton *)vetoBtn {
    if (!_vetoBtn) {
        _vetoBtn = [[UIButton alloc] initWithFrame:CGRectMake(24, self.bgView.frame.size.height - 28 - 44, 120, 44)];
        [_vetoBtn setBackgroundColor:[UIColor whiteColor]];
        [_vetoBtn setTitleColor:[UIColor colorWithRed:0x00/255.0f green:0xB8/255.0f blue:0xFF/255.0f alpha:1.0] forState:UIControlStateNormal];
        [_vetoBtn setTitle:[self getDisagreeText] forState:UIControlStateNormal];
        [_vetoBtn addTarget:self action:@selector(vetoAction) forControlEvents:UIControlEventTouchUpInside];
        _vetoBtn.layer.cornerRadius = 22;
        _vetoBtn.layer.borderWidth = 1;
        _vetoBtn.layer.borderColor = [UIColor colorWithRed:0x00/255.0f green:0xB8/255.0f blue:0xFF/255.0f alpha:1.0].CGColor;
    }
    return _vetoBtn;
}

-(UITextView *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [self getCustomContentViewWith:[UIColor greenColor] textSize:15.0 textColor:[UIColor blueColor] andFrame:CGRectMake(22, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, self.bgView.frame.size.width - 21 * 2, 150)];
    }
    return _contentLabel;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, self.bgView.frame.size.width, 44)];
        _titleLabel.textColor = [UIColor colorWithRed:0x33/255.0f green:0x33/255.0f blue:0x33/255.0f alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        _titleLabel.text =  [self getTitle];
        
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 312 , 282)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 28;
        _bgView.center = CGPointMake([[UIScreen mainScreen]bounds].size.width / 2.0, [[UIScreen mainScreen]bounds].size.height / 2.0);
    }
    return _bgView;
}


-(UIView *)blackBgView {
    if (!_blackBgView) {
        _blackBgView = [[UIView alloc] initWithFrame:self.bounds];
        _blackBgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    }
    return _blackBgView;
}

-(void)showInParentView:(UIView *)parentView {
    if (parentView) {
        [parentView addSubview:self];
    }
}


@end
