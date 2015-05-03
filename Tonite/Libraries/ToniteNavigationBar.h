//
//  ToniteNavigationBar.h
//  Tonite
//
//  Created by Julie Murakami on 4/23/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToniteNavigationBar : UINavigationBar
+(UIView*)createLogo:(NSString*)logoFileName;
+(UIView*)createTitle:(NSString* )title;
@end
