//
//  EventListingCell.h
//  StoreFinder
//
//  Created by Julie Murakami on 2/28/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *eventPhotosSlider;

@property (strong, nonatomic) IBOutlet UILabel *titleEvent;
@property (strong, nonatomic) IBOutlet UILabel *subtitle;

@property (nonatomic, retain) NSArray* arrayPhotos;






@end
