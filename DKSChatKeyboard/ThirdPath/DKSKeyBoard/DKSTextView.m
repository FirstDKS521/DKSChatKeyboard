//
//  DKSTextView.m
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "DKSTextView.h"
#import "UIView+FrameTool.h"

static float textFont = 25; //文案字体大小
@interface DKSTextView ()

/**
 *  UITextView作为placeholderView，使placeholderView等于UITextView的大小，字体重叠显示，方便快捷，解决占位符问题.
 */
@property (nonatomic, weak) UITextView *placeholderView;

/**
 *  文字高度
 */
@property (nonatomic, assign) NSInteger textH;

/**
 *  文字最大高度
 */
@property (nonatomic, assign) NSInteger maxTextH;

@end

@implementation DKSTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (!self.textFont) {
            self.textFont = [UIFont systemFontOfSize:textFont];
        }
        [self setup];
    }
    return self;
}

- (void)setup {
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    //实时监听textView值得改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark ====== 计算高度 ======
//UITextViewDelegate代理, 在这里让textView高度自适应, 同时设置最大高度, 类似于QQ微信输入框的效果
- (void)textDidChange {
    self.placeholderView.hidden = self.text.length > 0;
    //计算高度
    CGFloat height = ceilf([self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)].height);
    if (height > _maxTextH) {
        self.scrollEnabled = YES;   //当textView大于最大高度的时候让其可以滚动
        height = _maxTextH;
    } else {
        self.scrollEnabled = NO;
    }
    
    if (_textChangedBlock && self.scrollEnabled == NO) {
        _textChangedBlock(self.text, height);
        self.placeholderView.frame = self.bounds;
    }
    [self layoutIfNeeded];
}

#pragma mark ====== 设置placeholder ======
- (void)textValueDidChanged:(TextHeightChangedBlock)block {
    _textChangedBlock = block;
}

- (UITextView *)placeholderView {
    if (!_placeholderView ) {
        UITextView *placeholderView = [[UITextView alloc] initWithFrame:self.bounds];
        _placeholderView = placeholderView;
        //防止textView输入时跳动问题
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.font = self.font;
        _placeholderView.textColor = [UIColor lightGrayColor];
        _placeholderView.backgroundColor = [UIColor clearColor];
        [self addSubview:placeholderView];
    }
    return _placeholderView;
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines {
    _maxNumberOfLines = maxNumberOfLines;
    
    /**
     *  根据最大的行数计算textView的最大高度
     *  计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
     */
    _maxTextH = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}

- (void)setCornerRadius:(NSUInteger)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

/**
 *  通过设置placeholder设置私有属性placeholderView中的textColor
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderView.textColor = placeholderColor;
}

/**
 *  通过设置placeholder设置私有属性placeholderView中的text
 */
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderView.text = placeholder;
}

/**
 *  通过设置_placeholderFont设置私有属性placeholderView中的Font
 */
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    self.placeholderView.font = placeholderFont;
}

#pragma mark ====== 移除监听 ======
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
