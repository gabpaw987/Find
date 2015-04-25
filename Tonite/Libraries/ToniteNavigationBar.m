//
//  ToniteNavigationBar.m
//  Tonite
//
//  Created by Julie Murakami on 4/23/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "ToniteNavigationBar.h"

@implementation ToniteNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGSize)sizeThatFits:(CGSize)size {
    
    CGSize newSize = CGSizeMake(self.frame.size.width, 25.0);
    return newSize;
}
- (void)initialize {
    
    [self setTransform:CGAffineTransformMakeTranslation(0, -38.0)];
    [[UINavigationBar appearance] setAlpha:0.6];
}



+(UIView*)createLogo:(NSString*)logoFileName {
    
    UIImage* image = [UIImage imageNamed:logoFileName];
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(-3.0, 4.0, 75, 38)];
    [view setClipsToBounds:YES];
    [view setContentMode:UIViewContentModeScaleAspectFit];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = view.frame;
    
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:image forState:UIControlStateSelected];
    [btn setUserInteractionEnabled:NO];
    [view setBackgroundColor:[UIColor  clearColor]];
    [view addSubview:btn];
    view.layer.zPosition = 9999;
    
    return view;
}


@end
