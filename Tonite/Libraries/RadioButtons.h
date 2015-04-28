//
//  RadioButtons.h
//  Tonite
//
//  Created by Julie Murakami on 4/26/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioButtons : UIView
-(NSString* ) selectedButton;
- (id)initWithFrame:(CGRect)frame andOptions:(NSArray *)options andColumns:(int)columns;
@end
