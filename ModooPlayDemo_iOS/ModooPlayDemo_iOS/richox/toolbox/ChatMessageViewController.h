//
//  ChatMessageViewController.h
//  ModooPlayDemo
//
//  Created by moodoo on 2021/7/27.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RichOXToolBox/RichOXChatMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatMessageViewController : UIViewController

@property (nonatomic, strong) NSMutableArray <RichOXChatMessage *>*messages;

@property (nonatomic, strong) NSString *groupId;

@end

NS_ASSUME_NONNULL_END
