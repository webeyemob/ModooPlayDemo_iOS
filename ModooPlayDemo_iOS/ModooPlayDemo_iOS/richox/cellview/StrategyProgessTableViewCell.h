//
//  StrategyProgessTableViewCell.h
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/14.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^StrategyProgessDoWithdraw)(void);

@interface StrategyProgessTableViewCell : UITableViewCell

- (void)setName:(NSString *)name progress: (double)progress packetId:(NSString *)packetId status:(int)status block:(StrategyProgessDoWithdraw)block;

@end

NS_ASSUME_NONNULL_END
