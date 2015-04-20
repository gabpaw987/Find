//
//  MenuTableViewCell.m
//  Tonite
//
//  Created by Julie Murakami on 4/6/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell
@synthesize scale;


- (void)awakeFromNib {
    // Initialization code
    [self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor blackColor]];
    [self.imgBackground setAlpha:0.65];
    [self.imgBackground setClipsToBounds:NO];
    [self.imgBackground setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgBackground setFrame: CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height*1.3)];
    [self.imgBackground setCenter:self.center];
    [self.divider setFrame:CGRectMake(0.0, self.frame.size.height-3, self.frame.size.width,3)];
    [self.divider setAlpha:0.5];
    [self.labelTitle setCenter:self.center];

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
