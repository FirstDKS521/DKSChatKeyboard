//
//  DKSKeyboard.h
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKSTextView.h"

@protocol DKSTextViewDelegate <NSObject>

- (void)changeFrame:(CGFloat)height;

@end

@interface DKSKeyboard : UIView

@property (nonatomic, weak) id <DKSTextViewDelegate>delegate;

@property (nonatomic, strong) DKSTextView *textView;

@end
