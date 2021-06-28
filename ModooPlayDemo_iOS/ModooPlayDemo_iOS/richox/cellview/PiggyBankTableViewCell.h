//
//  PiggyBankTableViewCell.h
//  ModooPlayDemo
//
//  Created by moodoo on 2021/6/25.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PiggyBankWithdrawOnClick)(void);

@interface PiggyBankTableViewCell : UITableViewCell

- (void)setName:(NSString *)name amount: (double)amount assetName: (NSString *)assetName canWithdraw:(BOOL)canWithdraw block:(PiggyBankWithdrawOnClick)block;

@end

NS_ASSUME_NONNULL_END
