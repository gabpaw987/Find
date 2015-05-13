//
//  FadingImageView.m
//  Tonite
//
//  Created by Julie Murakami on 5/7/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "FadingImageView.h"

@implementation FadingImageView

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
    }
    return self;
}



//- (void)fadeImage {
//    if(count == [self.images count])
//        count = 0;
//    else
//        count++;
//    self.alpha = 0;
//    
//    [UIView transitionWithView: self duration:2.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        self.image = self.images[count];
//        self.alpha = 1;
//    }completion:NULL];
//}


@end
