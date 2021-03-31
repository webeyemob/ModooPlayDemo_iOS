//
//  RealNameView.h
//
//  Created by tgcenter on 2021/3/23.
//  Copyright © 2021 tgcenter. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^realNameOnClick)(NSString *name, NSString *idNumber);
typedef void (^closeBtnOnClick)();

@interface RealNameView : UIView

- (void)setCloseCallBack:(closeBtnOnClick)callback;
- (void)setClickCallBack:(realNameOnClick)callback;
@end

NS_ASSUME_NONNULL_END
