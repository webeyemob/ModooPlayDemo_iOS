//
//  ApprenticeTableViewCell.h
//  ModooPlayDemo
//
//  Created by moodoo on 2021/1/18.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApprenticeTableViewCell : UITableViewCell

- (void)setName:(NSString *)name totalContribution: (int)totalContribution contribution:(int)contribution;

@end

NS_ASSUME_NONNULL_END
