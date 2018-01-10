//
//  DKSKeyboardView.h
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DKSKeyboardDelegate <NSObject>

@optional //非必实现的方法

/**
 输入框内容变化时，改变当前VC的view的frame

 @param height 最小Y值
 */
- (void)changeFrameWithMinY:(CGFloat)height;

/**
 点击发送时输入框内的文案

 @param textStr 文案
 */
- (void)textViewContentText:(NSString *)textStr;

@end

@interface DKSKeyboardView : UIView <UITextViewDelegate>

@property (nonatomic, weak) id <DKSKeyboardDelegate>delegate;

@end
