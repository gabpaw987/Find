
//  EventTableViewCell.h
//  Tonite
//
//  Created by Julie Murakami on 5/4/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIImageView *fade;
@property (weak, nonatomic) IBOutlet UILabel *labelEvent;
@property (strong, nonatomic) IBOutlet UILabel *labelVenue;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;
@property (strong, nonatomic) IBOutlet UILabel *labelPrice;
@property (strong, nonatomic) IBOutlet UIImageView *locationIcon;
@property (strong, nonatomic) IBOutlet UIImageView *divider;

@end
