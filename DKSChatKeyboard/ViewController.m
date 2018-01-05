//
//  ViewController.m
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "ViewController.h"
#import "DKSKeyboard.h"
#import "DKSTextView.h"

#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) DKSKeyboard *keyView;

@end

@implementation ViewController

{
    CGFloat masH;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
    
//    UILabel *label = [UILabel new];
//    label.backgroundColor = [UIColor orangeColor];
//    label.text = @"我是聊天内容";
//    label.frame = CGRectMake(50, K_Height - 150, K_Width - 100, 50);
//    label.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:label];
    
    self.keyView = [[DKSKeyboard alloc] initWithFrame:CGRectMake(0, K_Height - 51, K_Width, 51)];
    [self.view addSubview:_keyView];
}

#pragma mark ====== 回收键盘 ======
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];
    [self.view endEditing:YES];
}

@end
