//
//  FadeImageView.h
//  Tonite
//
//  Created by Julie Murakami on 5/7/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FadeImageView : UIImageView{
    NSArray* arrayPhotos;
    int count;
    
}
@property (nonatomic, weak) NSTimer* timer;
-(NSArray*)arrayPhotos;
-(void) setArrayPhotos:(NSArray*) array;
-(void)startAnimating:(NSInteger) interval;
@end
