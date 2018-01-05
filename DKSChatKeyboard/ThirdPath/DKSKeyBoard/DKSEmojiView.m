//
//  DKSEmojiView.m
//  DKSChatKeyboard
//
//  Created by aDu on 2018/1/4.
//  Copyright © 2018年 DuKaiShun. All rights reserved.
//

#import "DKSEmojiView.h"
#import "UIView+FrameTool.h"

@implementation DKSEmojiView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [UILabel new];
        label.text = @"😁";
        label.frame = CGRectMake(30, 20, 30, 30);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}

@end
