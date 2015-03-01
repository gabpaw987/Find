//
//  EventListingCell.m
//  StoreFinder
//
//  Created by Julie Murakami on 2/28/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "EventListingCell.h"
#import "DetailViewController.h"



@implementation EventListingCell
@synthesize eventPhotosSlider;
@synthesize arrayPhotos;
@synthesize titleEvent;
@synthesize subtitle;

- (void)awakeFromNib {
    // Initialization code

    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
    if(screen){
        CGRect frame = eventPhotosSlider.frame;
        frame.size.width = self.frame.size.width;
        frame.size.height = 300;
        self.frame = frame;
    }
  
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
    
    
    
}




@end

