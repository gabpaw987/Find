//
//  TabBarViewController.h
//  Tonite
//
//  Created by Julie Murakami on 3/30/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelDelegate.h"

@interface TabBarViewController : UITabBarController

@property (nonatomic, assign) id<PanelDelegate> profileDelegate;

-(void) reloadInputViews;
@end
