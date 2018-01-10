//
//  DKSKeyboardView.m
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "DKSKeyboardView.h"
#import "DKSTextView.h"
#import "DKSMoreView.h"
#import "DKSEmojiView.h"
#import "UIView+FrameTool.h"

#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height [UIScreen mainScreen].bounds.size.height

static float bottomHeight = 230.0f; //底部视图高度
static float viewMargin = 8.0f; //按钮距离上边距
static float viewHeight = 35.0f; //按钮视图高度
@interface DKSKeyboardView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *emojiBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) DKSTextView *textView;
@property (nonatomic, strong) DKSMoreView *moreView;
@property (nonatomic, strong) DKSEmojiView *emojiView;

@property (nonatomic, assign) float keyboardHeight; //键盘高度
@property (nonatomic, assign) double keyboardTime; //键盘动画时长
@property (nonatomic, assign) BOOL emojiClick; //点击表情按钮
@property (nonatomic, assign) BOOL moreClick; //点击更多按钮

@end

@implementation DKSKeyboardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        [self creatView];
        
        //监听键盘的弹起和消失
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        //此通知主要是为了获取点击空白处回收键盘的处理
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:@"keyboardHide" object:nil];
    }
    return self;
}

- (void)creatView {
    self.backView.frame = CGRectMake(0, 0, self.width, self.height);
    
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
            self.emojiView.frame = CGRectMake(0, self.backView.height, K_Width, bottomHeight);
            self.frame = CGRectMake(0, K_Height - self.backView.height - bottomHeight, K_Width, self.backView.height + bottomHeight);
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
    self.emojiClick = NO; //主要是设置表情按钮为未点击状态
    if (self.moreClick == NO) {
        self.moreClick = YES;
        [self.emojiView removeFromSuperview];
        self.emojiView = nil;
        [self addSubview:self.moreView];
        //改变更多、self的frame
        [UIView animateWithDuration:0.25 animations:^{
            self.moreView.frame = CGRectMake(0, self.backView.height, K_Width, bottomHeight);
            self.frame = CGRectMake(0, K_Height - self.backView.height - bottomHeight, K_Width, self.backView.height + bottomHeight);
        }];
        //回收键盘
        [self.textView resignFirstResponder];
    } else { //再次点击更多按钮
        self.moreClick = NO;
        [self.moreView removeFromSuperview];
        //先把当前视图的frame移至底部
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, K_Height - self.height, K_Width, self.height);
        }];
        //键盘弹起
        [self.textView becomeFirstResponder];
    }
}

#pragma mark ====== 改变输入框大小 ======
- (void)changeFrame:(CGFloat)height {
    CGRect frame = self.textView.frame;
    frame.size.height = height;
    self.textView.frame = frame; //改变输入框的frame
    //当输入框大小改变时，改变backView的frame
    self.backView.frame = CGRectMake(0, 0, K_Width, height + (viewMargin * 2));
    self.frame = CGRectMake(0, K_Height - self.backView.height - self.keyboardHeight, K_Width, self.backView.height);
    //改变更多按钮、表情按钮的位置
    self.emojiBtn.frame = CGRectMake(viewMargin, self.backView.height - viewHeight - viewMargin, viewHeight, viewHeight);
    self.moreBtn.frame = CGRectMake(self.textView.maxX + viewMargin, self.backView.height - viewHeight - viewMargin, viewHeight, viewHeight);
    //主要是为了改变VC的view的frame
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeFrameWithMinY:)]) {
        [self.delegate changeFrameWithMinY:self.minY];
    }
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

//键盘将要出现
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

#pragma mark ====== 点击发送按钮 ======
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //判断输入的字是否是回车，即按下return
    if ([text isEqualToString:@"\n"]){
        [self changeFrame:viewHeight];
        if (self.delegate && [self.delegate respondsToSelector:@selector(textViewContentText:)]) {
            [self.delegate textViewContentText:textView.text];
        }
        textView.text = @"";
        /*这里返回NO，就代表return键值失效，即页面上按下return，
         不会出现换行，如果为yes，则输入页面会换行*/
        return NO;
    }
    return YES;
}

#pragma mark ====== init ======
- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.layer.borderWidth = 1;
        _backView.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.89 alpha:1.00].CGColor;
        [self addSubview:_backView];
    }
    return _backView;
}

//表情按钮
- (UIButton *)emojiBtn {
    if (!_emojiBtn) {
        _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiBtn setBackgroundImage:[UIImage imageNamed:@"emojiImg"] forState:UIControlStateNormal];
        [_emojiBtn addTarget:self action:@selector(emojiBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_emojiBtn];
    }
    return _emojiBtn;
}

//更多按钮
- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setBackgroundImage:[UIImage imageNamed:@"moreImg"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_moreBtn];
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
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.89 alpha:1.00].CGColor;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        [self.backView addSubview:_textView];
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
