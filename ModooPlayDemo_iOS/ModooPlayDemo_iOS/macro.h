//
//  macro.h
//  AdLime_iOS_TestApp
//
//  Created by TaurusXAd on 2019/9/25.
//  Copyright © 2019 TGCenter. All rights reserved.
//

#ifndef macro_h
#define macro_h


#define ScreenWidth             UIScreen.mainScreen.bounds.size.width
#define ScreenHeight            UIScreen.mainScreen.bounds.size.height

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONEX [[UIScreen mainScreen] bounds].size.width >=375.0f && [[UIScreen mainScreen] bounds].size.height >=812.0f && IS_IPHONE

// 顶部安全区域远离高度
#define kTopBarSafeHeight   (CGFloat)(IS_IPHONEX?(64):(20))
// 底部安全区域远离高度
#define kBottomSafeHeight   (CGFloat)(IS_IPHONEX?(34):(0))

// 是否使用 TXADAdLoader 加载广告
#define useAdLoader 0

#endif /* macro_h */
