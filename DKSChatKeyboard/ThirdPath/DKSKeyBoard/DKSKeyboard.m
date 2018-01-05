//
//  DKSKeyboard.m
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "DKSKeyboard.h"
#import "DKSMoreView.h"
#import "DKSEmojiView.h"
#import "UIView+FrameTool.h"

#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height [UIScreen mainScreen].bounds.size.height

static float bottomHeight = 200.0f; //底部视图高度
static float viewMargin = 8.0f; //按钮距离上边距
static float viewHeight = 35.0f; //按钮视图高度
@interface DKSKeyboard ()<UITextViewDelegate>

@property (nonatomic, strong) UIButton *emojiBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) DKSMoreView *moreView;
@property (nonatomic, strong) DKSEmojiView *emojiView;

@property (nonatomic, assign) float keyboardHeight; //键盘高度
@property (nonatomic, assign) double keyboardTime; //键盘动画时长
@property (nonatomic, assign) BOOL emojiClick; //点击表情按钮
@property (nonatomic, assign) BOOL moreClick; //点击更多按钮

@end

@implementation DKSKeyboard

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
        self.layer.borderWidth = 0.8;
        self.layer.borderColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.90 alpha:1.00].CGColor;
        [self creatView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        //此通知主要是为了获取点击空白处回收键盘的处理
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:@"keyboardHide" object:nil];
    }
    return self;
}

- (void)creatView {
    //表情按钮
    self.emojiBtn.frame = CGRectMake(viewMargin, viewMargin, viewHeight, viewHeight);
    
    //输入视图
    self.textView.frame = CGRectMake(CGRectGetMaxX(self.emojiBtn.frame) + viewMargin, viewMargin, K_Width - (CGRectGetMaxX(self.emojiBtn.frame) + viewMargin) * 2, viewHeight);
    
    //加号按钮
    self.moreBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) + viewMargin, self.height - viewMargin - viewHeight, viewHeight, viewHeight);
}

#pragma mark ====== 表情按钮 ======
- (void)emojiBtn:(UIButton *)btn {
    self.moreClick = NO;
    if (self.emojiClick == NO) {
        self.emojiClick = YES;
        [self.moreView removeFromSuperview];
        self.moreView = nil;
        [self addSubview:self.emojiView];
        [UIView animateWithDuration:0.25 animations:^{
            self.emojiView.frame = CGRectMake(0, self.textView.height + (viewMargin * 2), K_Width, bottomHeight);
            self.frame = CGRectMake(0, K_Height - self.textView.height - (viewMargin * 2) - bottomHeight, K_Width, self.textView.height + (viewMargin * 2) + bottomHeight);
        }];
        [self.textView resignFirstResponder];
    } else {
        self.emojiClick = NO;
        [self.emojiView removeFromSuperview];
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, K_Height - self.height, K_Width, self.height);
        }];
        [self.textView becomeFirstResponder];
    }
}

#pragma mark ====== 加号按钮 ======
- (void)moreBtn:(UIButton *)btn {
    self.emojiClick = NO;
    if (self.moreClick == NO) {
        self.moreClick = YES;
        [self.emojiView removeFromSuperview];
        self.emojiView = nil;
        [self addSubview:self.moreView];
        [UIView animateWithDuration:0.25 animations:^{
            self.moreView.frame = CGRectMake(0, self.textView.height + (viewMargin * 2), K_Width, bottomHeight);
            self.frame = CGRectMake(0, K_Height - self.textView.height - (viewMargin * 2) - bottomHeight, K_Width, self.textView.height + (viewMargin * 2) + bottomHeight);
        }];
        [self.textView resignFirstResponder];
    } else {
        self.moreClick = NO;
        [self.moreView removeFromSuperview];
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, K_Height - self.height, K_Width, self.height);
        }];
        [self.textView becomeFirstResponder];
    }
}

#pragma mark ====== 改变输入框大小 ======
- (void)changeFrame:(CGFloat)height {
    CGRect frame = self.textView.frame;
    frame.size.height = height;
    self.textView.frame = frame;
//    if ([self.delegate respondsToSelector:@selector(changeFrame:)]) {
//        [self.delegate changeFrame:height];
//    }    
    
    self.frame = CGRectMake(0, K_Height - height - (viewMargin * 2) - self.keyboardHeight, K_Width, height + (viewMargin * 2));
    self.emojiBtn.frame = CGRectMake(viewMargin, self.height - viewHeight - viewMargin, viewHeight, viewHeight);
    self.moreBtn.frame = CGRectMake(self.textView.maxX + viewMargin, self.height - viewHeight - viewMargin, viewHeight, viewHeight);
}

#pragma mark ====== 键盘监听 ======
- (void)keyboardHide {
    [self removeBottomViewFromSupview];
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, K_Height - self.textView.height - viewMargin * 2, K_Width, self.textView.height + viewMargin * 2);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (!self.emojiClick && !self.moreClick) {
        [self removeBottomViewFromSupview];
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, K_Height - self.textView.height - viewMargin * 2, K_Width, self.textView.height + viewMargin * 2);
        }];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [self removeBottomViewFromSupview];
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = endFrame.size.height;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        self.frame = CGRectMake(0, endFrame.origin.y - self.textView.height - viewMargin * 2, K_Width, self.textView.height + viewMargin * 2);
    } completion:nil];
}

#pragma mark ====== 移除视图 ======
- (void)removeBottomViewFromSupview {
    self.moreClick = NO;
    self.emojiClick = NO;
    [self.moreView removeFromSuperview];
    [self.emojiView removeFromSuperview];
    self.moreView = nil;
    self.emojiView = nil;
}

#pragma mark ====== init ======
//表情按钮
- (UIButton *)emojiBtn {
    if (!_emojiBtn) {
        _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiBtn setBackgroundImage:[UIImage imageNamed:@"emojiImg"] forState:UIControlStateNormal];
        [_emojiBtn addTarget:self action:@selector(emojiBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_emojiBtn];
    }
    return _emojiBtn;
}

//更多按钮
- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setBackgroundImage:[UIImage imageNamed:@"moreImg"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
    }
    return _moreBtn;
}

- (DKSTextView *)textView {
    if (!_textView) {
        _textView = [[DKSTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16];
        [_textView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
            [self changeFrame:textHeight];
        }];
        _textView.maxNumberOfLines = 5;
        _textView.layer.cornerRadius = 4;
        _textView.layer.borderWidth = 0.8;
        _textView.layer.borderColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.90 alpha:1.00].CGColor;
        [self addSubview:_textView];
    }
    return _textView;
}

//更多视图
- (DKSMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[DKSMoreView alloc] init];
        _moreView.frame = CGRectMake(0, K_Height, K_Width, bottomHeight);
    }
    return _moreView;
}

//表情视图
- (DKSEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[DKSEmojiView alloc] init];
        _emojiView.frame = CGRectMake(0, K_Height, K_Width, bottomHeight);
    }
    return _emojiView;
}

#pragma mark ====== 移除监听 ======
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
