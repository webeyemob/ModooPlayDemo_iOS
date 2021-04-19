//
//  InviteAwardTableViewCell.h
//  FissionSdkDemo
//
//  Created by moodoo on 2021/1/18.
//  Copyright © 2021 fissionsdk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteAwardTableViewCell : UITableViewCell

- (void)setCount:(int)count award: (NSString *)award hasFetch:(BOOL)hasFetch;

@end

NS_ASSUME_NONNULL_END
