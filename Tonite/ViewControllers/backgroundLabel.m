//
//  backgroundLabel.m
//  Tonite
//
//  Created by Julie Murakami on 5/12/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "backgroundLabel.h"

@implementation backgroundLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.layer setBackgroundColor:[UIColor colorWithHue:0.0 saturation:0.0 brightness:1.0 alpha:0.5].CGColor];
        [self setTextAlignment:NSTextAlignmentLeft];
        [self setTextColor:[UIColor blackColor]];
        [self setFont:[UIFont fontWithName:@"Avenir Light" size:14.0]];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        
        [self.layer setBackgroundColor:[UIColor colorWithHue:0.0 saturation:0.0 brightness:1.0 alpha:0.5].CGColor];
        [self setTextAlignment:NSTextAlignmentLeft];
        [self setTextColor:[UIColor blackColor]];
        [self setFont:[UIFont fontWithName:@"Avenir Light" size:14.0]];

    }
    return self;
}



@end
