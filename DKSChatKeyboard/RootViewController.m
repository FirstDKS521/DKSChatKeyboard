//
//  RootViewController.m
//  DKSChatKeyboard
//
//  Created by aDu on 2018/1/12.
//  Copyright © 2018年 DuKaiShun. All rights reserved.
//

#import "RootViewController.h"
#import "ChatViewController.h"
#import "UIView+FrameTool.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微信";
    
    //控制导航栏的背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.19 green:0.18 blue:0.21 alpha:1.00];
    //控制导航栏返回按钮的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //控制导航栏标题的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //状态栏改为白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //控制导航栏的不透明
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addButton];
}

- (void)addButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, self.view.width - 200, 40);
    [button addTarget:self action:@selector(pushChatPage) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"进入聊天" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button];
}

- (void)pushChatPage {
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:YES];
}

@end
