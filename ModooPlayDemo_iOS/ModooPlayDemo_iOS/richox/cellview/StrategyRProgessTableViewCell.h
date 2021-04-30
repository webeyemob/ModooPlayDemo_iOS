//
//  StrategyRProgessTableViewCell.h
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/14.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^StrategyRProgessDoWithdraw)(void);

@interface StrategyRProgessTableViewCell : UITableViewCell

- (void)setName:(NSString *)name progress: (double)progress packetId:(NSString *)packetId status:(int)status block:(StrategyRProgessDoWithdraw)block;

@end

NS_ASSUME_NONNULL_END
