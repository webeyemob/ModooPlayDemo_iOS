//
//  MissionTableViewCell.h
//  FissionSdkDemo
//
//  Created by moodoo on 2021/1/21.
//  Copyright © 2021 fissionsdk. All rights reserved.
//

#import <UIKit/UIKit.h>
@import RichOXBase;

NS_ASSUME_NONNULL_BEGIN

@interface MissionTableViewCell : UITableViewCell

- (void)setItem:(RichOXMissionData *)item;

@end

NS_ASSUME_NONNULL_END
