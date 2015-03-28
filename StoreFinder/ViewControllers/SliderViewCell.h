//
//  SliderViewCell.h
//  StoreFinder
//
//  Created by Julie Murakami on 3/8/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, retain) NSTimer * scrollingTimer;
@property (nonatomic, strong) NSArray * imageArray;
@property BOOL willAnimate;
@property (nonatomic, strong) Store* event;


-(void) startAnimationWithDuration:(float)duration;

-(void)resumeAnimation;
-(void)stopAnimation;
-(void) setScrollView;

@end
