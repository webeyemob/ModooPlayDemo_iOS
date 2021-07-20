//
//  inviteAwardObject.h
//  ModooPlayDemo
//
//  Created by moodoo on 2021/1/18.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface inviteAwardObject : NSObject

@property (nonatomic, readonly) int count;
@property (nonatomic, readonly) int awardType;
@property (nonatomic, readonly) float value;

@property (nonatomic) BOOL hasFetch;        //已领取

- (instancetype)initWithCount:(int)count awardType:(int)awardType value:(float)value;

@end

NS_ASSUME_NONNULL_END
