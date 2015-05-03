//
//  EventPageViewController.h
//  Tonite
//
//  Created by Julie Murakami on 5/2/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventPageViewController : UIViewController

@property ( nonatomic, strong) NSString* eventId;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
