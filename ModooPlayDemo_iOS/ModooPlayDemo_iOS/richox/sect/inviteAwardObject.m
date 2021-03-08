//
//  inviteAwardObject.m
//  FissionSdkDemo
//
//  Created by moodoo on 2021/1/18.
//  Copyright © 2021 fissionsdk. All rights reserved.
//

#import "inviteAwardObject.h"

@implementation inviteAwardObject

- (instancetype)initWithCount:(int)count awardType:(int)awardType value:(float)value {
    self = [super init];
    if (self) {
        _count = count;
        _awardType = awardType;
        _value = value;
    }
    return self;
}

@end
