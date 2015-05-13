//
//  FadeImageView.m
//  Tonite
//
//  Created by Julie Murakami on 5/7/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "FadeImageView.h"

@implementation FadeImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)fadeImage {
    if(count == [arrayPhotos count])
        count = 0;
    self.alpha = 0;
    [UIView transitionWithView:self duration:2.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.image = arrayPhotos[count];
        self.alpha = 1;
    }completion:^(BOOL finished){
        count++;
    }];
}

-(void) startAnimating:(NSInteger)interval{
    if(arrayPhotos.count <= 1)
        return;
    count = 1;
    _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(fadeImage) userInfo:nil repeats:YES];

}

-(void) setArrayPhotos:(NSArray*) array{
    NSMutableArray * images= [[NSMutableArray alloc]init];
    Photo * p = array == nil || array.count == 0 ? nil : array[0];
    if(p){
        UIImage * imageOne = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:p.photo_url]]];
        self.image = imageOne;
        [images addObject: imageOne];
        for(int i = 1; i< array.count; i++){
            Photo* photo = [array objectAtIndex:i];
            UIImage * im = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.photo_url]]];
            [images addObject: im];
        }
        arrayPhotos = images;
    }
    else
        arrayPhotos = array;
}

-(NSArray*) arrayPhotos{
    return arrayPhotos;
}




@end
