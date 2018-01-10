#iOS开发：聊天输入框的实现

>经常使用微信聊天，没事儿就会想输入框的实现过程，所以抽空，也实现了一个输入框的功能；

![效果图.jpeg](http://upload-images.jianshu.io/upload_images/1840399-6ec799943a9a72f2.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)![效果GIF.gif](http://upload-images.jianshu.io/upload_images/1840399-4273a1c1c52dcab2.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


经过封装，使用就非常的简单了，在需要的VC中，实现方法如下：

```
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
    
    self.keyView = [[DKSKeyboardView alloc] initWithFrame:CGRectMake(0, K_Height - 51, K_Width, 51)];
    //设置代理方法
    self.keyView.delegate = self;
    [self.view addSubview:_keyView];
}
```
主要就是上面的添加，此时输入框就已经添加到当前的VC中；稍后会讲到里面的代理方法的作用；

####工程结构如下图

![结构图.png](http://upload-images.jianshu.io/upload_images/1840399-253b6486b7edc58b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

主要是红色线标出的两个类，结构比较简单

类名 		  | 		作用
----------- | ----------- 
DKSKeyboardView | 布局表情按钮、更多按钮、输入框
DKSTextView | 设置输入行数，输入框内容变化时改变输入款高度
####DKSKeyboardView.h中的代码如下：
```
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
```
关于上面的两个代理方法，目前只是简单的实现了一下，具体的实现，还需自行处理，我这里只是给出了一个大概方向；`（关键是我也没考虑清楚，如何更好的实现键盘弹起，当前的VC视图上移，我后续还会继续完善，如果哪位大侠有好的想法，欢迎留言讨论`

####在DKSKeyboardView.m中，以下列出少量重要代码，主要是改变frame
###1、点击输入框，键盘出现
```
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
```
###2、点击更多按钮
```
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
```
###3、改变输入框大小
```
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
```

以上就是聊天输入框的简单实现，只是提供一个实现思路，如果在聊天界面中接入，还需要处理以下问题：
>1、键盘弹起，判断当前的UITableView的最后一行cell和当前输入框视图最小的Y值进行对比，处理当前VC是否上移；
>
>2、输入框文案较多时，输入框的高度变化，同样要做第一条的判断；
>
>3、键盘收起，改变当前VC的view的frame；

demo中如果有任何问题，欢迎各位留言拍砖，小弟一定更正，共同学习；

###[简书地址](https://www.jianshu.com/p/dd04910023a0)

