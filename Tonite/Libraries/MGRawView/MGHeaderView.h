//
//  MGHeaderView.h
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "MGRawView.h"
#import "RateView.h"

@interface MGHeaderView : MGRawView

@property (strong, nonatomic) IBOutlet UIScrollView *scrollMain;

@property (strong, nonatomic) IBOutlet UILabel *labelEventName;
@property (strong, nonatomic) IBOutlet UILabel *labelVenueName;
@property (strong, nonatomic) IBOutlet UILabel *labelPrice;

@end
