//
//  CustomPrivacyDialog.h
//  TestPolicy
//
//  Created by sherlock.chan on 2021/1/13.
//

#import <UIKit/UIKit.h>
@import PrivacyPolicy;


NS_ASSUME_NONNULL_BEGIN

// Dialog 中的文本不可以修改，只能调整 UI 样式
@interface CustomPrivacyDialog : BasePrivacyDialog

-(instancetype)initWithAgreeBlock:(PPButtonBlock)agreeBlock andDisagreeBlock:(PPButtonBlock)disagreeBlock;

-(void)showInParentView:(UIView *)parentView;

@end

NS_ASSUME_NONNULL_END
