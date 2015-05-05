//
//  EventTableViewCell.m
//  Tonite
//
//  Created by Julie Murakami on 5/4/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.imgBackground setFrame: self.frame];
    [self.fade setFrame: self.frame];
    CGRect frame = CGRectMake(0.0, self.imgBackground.frame.size.height-3, self.frame.size.width, 3);
    [self.divider setFrame: frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
