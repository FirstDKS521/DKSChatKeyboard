//
//  UIView+FrameTool.m
//  DKSTextFieldMove
//
//  Created by aDu on 2017/7/13.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "UIView+FrameTool.h"

@implementation UIView (FrameTool)

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
//    self.origin = CGPointMake(origin.x, origin.y);
    self.frame = (CGRect){
        .origin = {.x = origin.x, .y = origin.y},
        .size = {.width = self.width, .height = self.height}
    };
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
//    self.size = CGSizeMake(size.width, size.height);
    self.frame = (CGRect){
        .origin = {.x = self.x, .y = self.y},
        .size = {.width = size.width, .height = size.height}
    };
}

- (CGFloat)maxX {
    return self.x + self.width;
}

- (CGFloat)minX {
    return self.x;
}

- (CGFloat)maxY {
    return self.y + self.height;
}

- (CGFloat)minY {
    return self.y;
}

@end

@implementation UIView (FindeFirstResponder)

- (UIView *)findFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *responder = [subView findFirstResponder];
        if (responder) {
            return responder;
        }
    }
    return nil;
}

@end


