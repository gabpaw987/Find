//
//  OptionLabelButton.m
//  Tonite
//
//  Created by Julie Murakami on 5/12/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "OptionLabelButton.h"

@implementation OptionLabelButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithWhite:0.7 alpha:1.0] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor colorWithWhite:0.7 alpha:1.0] forState:UIControlStateHighlighted];
        [self.titleLabel setFont:[UIFont fontWithName:@"Avenir Light" size:12.0]];
        [self.layer setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.0].CGColor];

    }
    return self;
}

@end
