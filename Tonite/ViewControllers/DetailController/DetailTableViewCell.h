//
//  DetailTableViewCell.h
//  Tonite
//
//  Created by Julie Murakami on 5/2/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *eventDescription;
@property (strong, nonatomic) IBOutlet MKMapView *mapViewCell;
@property (strong, nonatomic) IBOutlet UILabel *labelVenue;
@property (strong, nonatomic) IBOutlet UILabel *venueDescription;

@end
