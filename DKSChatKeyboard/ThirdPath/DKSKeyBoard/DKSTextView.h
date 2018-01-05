//
//  DKSTextView.h
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextHeightChangedBlock)(NSString *text, CGFloat textHeight);
@interface DKSTextView : UITextView

/**
 *  占位文字
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 *  占位文字颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**
 *  占位符字体大小
 */
@property (nonatomic,strong) UIFont *placeholderFont;

/**
 *  textView最大行数
 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;

/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, strong) TextHeightChangedBlock textChangedBlock;

/**
 *  设置圆角
 */
@property (nonatomic, assign) NSUInteger cornerRadius;

/**
 文字大小
 */
@property (nonatomic, strong) UIFont *textFont;

- (void)textValueDidChanged:(TextHeightChangedBlock)block;

@end
