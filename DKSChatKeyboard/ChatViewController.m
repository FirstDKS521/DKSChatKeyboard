//
//  ChatViewController.m
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "ChatViewController.h"
#import "UIView+FrameTool.h"
#import "DKSKeyboardView.h"
#import "ChatViewCell.h"
#import "DKSTextView.h"

//状态栏和导航栏的总高度
#define StatusNav_Height (isIphoneX ? 88 : 64)
//判断是否是iPhoneX
#define isIphoneX (K_Width == 375.f && K_Height == 812.f ? YES : NO)
#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height self.view.frame.size.height
@interface ChatViewController ()<DKSKeyboardDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DKSKeyboardView *keyView;

@property (nonatomic, strong) NSMutableArray *dataAry;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿杜";
    
    self.view.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
    [self.view addSubview:self.tableView];
    //给UITableView添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    tapGesture.delegate = self;
    [self.tableView addGestureRecognizer:tapGesture];
    
    //添加输入框
    self.keyView = [[DKSKeyboardView alloc] initWithFrame:CGRectMake(0, K_Height - StatusNav_Height - 52, K_Width, 52)];
    //设置代理方法
    self.keyView.delegate = self;
    [self.view addSubview:_keyView];
    
    self.dataAry = @[@"我是单行测试数据",
                     @"我是多行测试数据我是多行测试数据我是多行测试数据我"].mutableCopy;
}

#pragma mark ====== UITableViewDelegate ======
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setContentText:self.dataAry[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark ====== DKSKeyboardDelegate ======
//发送的文案
- (void)textViewContentText:(NSString *)textStr {
    [self.dataAry addObject:textStr];
    [self.tableView reloadData];
    [self scrollToBottom];
}

//keyboard的frame改变
- (void)keyboardChangeFrameWithMinY:(CGFloat)minY {
    [self scrollToBottom];
    // 获取对应cell的rect值（其值针对于UITableView而言）
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:self.dataAry.count - 1 inSection:0];
    CGRect rect = [self.tableView rectForRowAtIndexPath:lastIndex];
    CGFloat lastMaxY = rect.origin.y + rect.size.height;
    //如果最后一个cell的最大Y值大于tableView的高度
    if (lastMaxY <= self.tableView.height) {
        if (lastMaxY >= minY) {
            self.tableView.y = minY - lastMaxY;
        } else {
            self.tableView.y = 0;
        }
    } else {
        self.tableView.y += minY - self.tableView.maxY;
    }
}

#pragma mark ====== UITableView滚动到底部 ======
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollToBottom];
}

- (void)scrollToBottom {
    if (self.dataAry.count >= 1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:MAX(0, self.dataAry.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark ====== 点击UITableView ======
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //收回键盘
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];
    //若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark ====== init ======
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_Width, K_Height - StatusNav_Height - 52) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"ChatViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.separatorStyle = NO;
        _tableView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}

@end
