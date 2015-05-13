//
//  LoginView.m
//  Tonite
//
//  Created by Julie Murakami on 5/8/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView
@synthesize emailText;
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
//        
//        
//        //Email TextField
//        UILabel* emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 7.5*self.bounds.size.height/20, self.bounds.size.width, 2.8*self.bounds.size.height/40)];
//        [emailLabel.layer setBackgroundColor:[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.9 alpha:0.8].CGColor];
//        [emailLabel setText:@"    Email"];
//        [emailLabel setTextAlignment:NSTextAlignmentNatural];
//        [emailLabel setTextColor:[UIColor blackColor]];
//        [emailLabel setFont:[UIFont fontWithName:@"Avenir Light" size:14.0]];
//        [self addSubview:emailLabel];
//        
//        emailText = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width/4, 7.5*self.bounds.size.height/20, 5*self.bounds.size.width/7, 3*self.bounds.size.height/40)];
//        [emailText setTextAlignment:NSTextAlignmentRight];
//        [emailText setClipsToBounds:YES];
//        [emailText setTextColor:[UIColor blackColor]];
//        [emailText setFont:[UIFont fontWithName:@"Avenir Light" size:14.0]];
//        emailText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"example@123.com" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:12.0] }];
//        [emailText.layer setOpacity:1.0];
//        emailText.delegate = self;
//        [self addSubview:emailText];

    }
    return self;
}




@end
