//
//  ChatGroupTableViewCell.h
//  ModooPlayDemo
//
//  Created by moodoo on 2021/7/26.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RichOXToolBox/RichOXGroupInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatGroupTableViewCell : UITableViewCell

- (void)setGroupInfo:(RichOXGroupInfo *)group;

@end

NS_ASSUME_NONNULL_END
