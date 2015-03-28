//
//  SliderViewCell.m
//  StoreFinder
//
//  Created by Julie Murakami on 3/8/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "SliderViewCell.h"
@interface SliderViewCell ()<UIScrollViewDelegate>
@end

@implementation SliderViewCell
@synthesize scrollView;
@synthesize event;


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:
            reuseIdentifier];
    
    if(self){
        if(scrollView == nil) {
            scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        }
        [scrollView setFrame: self.frame];
        for(UIView* view in scrollView.subviews)
                [view removeFromSuperview];
                scrollView.delegate = self;
        
        
    }
    return self;
}


-(void) setScrollView{
    
        if(_scrollingTimer != nil)
            [_scrollingTimer invalidate];
        
    if(_imageArray == nil || _numberOfItems == 0){
        return;
    }
        int posX = 0;
        for(int x = 0; x < _numberOfItems; x++) {
            CGRect rect =scrollView.frame;
            rect.origin = CGPointMake(posX, 0.0);
            UIImageView* view = [[UIImageView alloc] initWithFrame:rect];
            Photo* p = _imageArray[x];
            [self setImage: p.photo_url imageView:view];
            
            
            [scrollView addSubview:view];
            
            posX    += rect.size.width;
        }
        
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.contentSize = CGSizeMake(posX, scrollView.frame.size.height);
      return;
}

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:SLIDER_PLACEHOLDER];
    
    [imgView setImageWithURLRequest:urlRequest
                   placeholderImage:imgPlaceholder
                            success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                
                                CGSize size = weakImgRef.frame.size;
                                
                                if([MGUtilities isRetinaDisplay]) {
                                    size.height *= 2;
                                    size.width *= 2;
                                }
                                
                                if(IS_IPHONE_6_PLUS_AND_ABOVE) {
                                    size.height *= 3;
                                    size.width *= 3;
                                }
                                
                                UIImage* croppedImage = [image imageByScalingAndCroppingForSize:size];
                                weakImgRef.image = croppedImage;
                                
                                } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
                            }];
}







-(void) startAnimationWithDuration:(float)duration {
    _scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                       target:self
                                                     selector:@selector(scrollTimer)
                                                     userInfo:nil
                                                      repeats:YES];
    _willAnimate = YES;
    
}

-(void)scrollTimer {
    
    if(!_willAnimate)
        return;
    CGFloat contentOffset = scrollView.contentOffset.x;
    int nextPage = (int)(contentOffset/scrollView.frame.size.width) + 1;
    CGRect rect = CGRectZero;
    
    if( nextPage < _numberOfItems ) {
        rect = CGRectMake(nextPage*self.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView scrollRectToVisible:rect animated:YES];
        
    }
    else {
        rect = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView scrollRectToVisible:rect animated:YES];
    }
}





-(void)stopAnimation {
    _willAnimate = NO;
}

-(void)resumeAnimation {
    _willAnimate = YES;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
