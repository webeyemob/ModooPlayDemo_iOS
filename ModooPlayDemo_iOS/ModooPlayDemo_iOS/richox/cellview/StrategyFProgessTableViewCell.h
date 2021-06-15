//
//  StrategyFProgessTableViewCell.h
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/14.
//  Copyright © 2021 TaurusXAds. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^StrategyFProgessDoMission)(NSString *packetId);

@interface StrategyFProgessTableViewCell : UITableViewCell

- (void)setName:(NSString *)name progress: (double)progress packetId:(NSString *)packetId block:(StrategyFProgessDoMission)block;

@end

NS_ASSUME_NONNULL_END
