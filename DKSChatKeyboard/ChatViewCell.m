//
//  ChatViewCell.m
//  DKSChatKeyboard
//
//  Created by aDu on 2018/1/12.
//  Copyright © 2018年 DuKaiShun. All rights reserved.
//

#import "ChatViewCell.h"

@interface ChatViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ChatViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentText:(NSString *)textStr {
    self.contentLabel.text = textStr;
}

@end
