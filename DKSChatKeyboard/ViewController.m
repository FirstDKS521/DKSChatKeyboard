//
//  ViewController.m
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "ViewController.h"
#import "DKSKeyboardView.h"
#import "DKSTextView.h"

#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<DKSKeyboardDelegate>

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) DKSKeyboardView *keyView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
    
    self.keyView = [[DKSKeyboardView alloc] initWithFrame:CGRectMake(0, K_Height - 51, K_Width, 51)];
    //设置代理方法
    self.keyView.delegate = self;
    [self.view addSubview:_keyView];
}

#pragma mark ====== DKSKeyboardDelegate ======
//在UITableView下，改变其frame
- (void)changeFrameWithMinY:(CGFloat)height {
    NSLog(@"%@", @(height));
}

- (void)textViewContentText:(NSString *)textStr {
    self.contentLabel.text = textStr;
}

#pragma mark ====== 回收键盘 ======
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];
    [self.view endEditing:YES];
}

@end
