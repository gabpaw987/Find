//
//  FadingImageView.h
//  Tonite
//
//  Created by Julie Murakami on 5/7/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FadingImageView : UIImageView{
    int count;
    NSTimer * timer;
}

@property (nonatomic, strong) NSMutableArray* images;

-(void) startAnimationWithDuration:(float)duration;


- (void)fadeImage;


@end
