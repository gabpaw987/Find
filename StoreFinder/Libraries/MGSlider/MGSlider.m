


#import "MGSlider.h"

@implementation MGSlider

@synthesize numberOfItems = _numberOfItems;
@synthesize scrollView;
@synthesize nibName;
@synthesize delegate = _delegate;
@synthesize event;
@synthesize willAnimate = _willAnimate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect rectScrollView = self.frame;
        rectScrollView.origin.y = 0;
        scrollView = [[UIScrollView alloc] initWithFrame:rectScrollView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

-(void) setNeedsReLayoutWithViewSize:(CGSize)viewSize {
    self.imageArray = [CoreDataController getStorePhotosByStoreId:event.store_id] ;
    self.numberOfItems = [self.imageArray count];
    if(self.numberOfItems == 0){
        _willAnimate = NO;
        //DEFAULT VIEW???
        return;
    }
    _willAnimate = YES;
    for(UIView* view in self.subviews)
        [view removeFromSuperview];
    
    if(_scrollingTimer != nil)
       [_scrollingTimer invalidate];
    
    CGRect rectScrollView = self.frame;
    rectScrollView.origin.y = 0;
    if(scrollView == nil) {
        scrollView = [[UIScrollView alloc] initWithFrame:rectScrollView];
    }
    scrollView.delegate = self;

    int posX = 0;
    for(int x = 0; x < _numberOfItems; x++) {
        UIImageView* sliderView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, 0.0, viewSize.width, viewSize.height)];
        [scrollView addSubview:sliderView];
        posX += viewSize.width;
    }
   
    currentIndex  = 1;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.frame = CGRectMake(0.0, 0.0, viewSize.width, viewSize.height);
    scrollView.contentSize = CGSizeMake(posX, scrollView.frame.size.height);
    [self addSubview:scrollView];
    
    UIImageView* vc =  scrollView.subviews[0] ;
    Photo* p = self.imageArray[0];
    [self setImage:p.photo_url imageView:vc];
    NSLog(@"%f, %f", vc.frame.size.width, vc.frame.size.height);
    //vc.frame = CGRectMake(0.0, 0.0, viewSize.width, viewSize.height);
}


-(void) startAnimationWithDuration:(float)duration {
    if(!_willAnimate)
        return;
    _scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                       target:self
                                                     selector:@selector(scrollingTimer)
                                                     userInfo:nil
                                                      repeats:YES];
    
}


 -(void)didCreateSliderViewAtIndex:(int)index {
     Photo*p = self.imageArray[index];
     UIImageView* view = scrollView.subviews[index];
     [self setImage:p.photo_url imageView:view];
     
 }


- (void)scrollingTimer {
    
    CGFloat contentOffset = scrollView.contentOffset.x;
    int nextPage = (int)(contentOffset/scrollView.frame.size.width) + 1;
    CGRect rect = CGRectZero;
    if(currentIndex == nextPage && nextPage < _numberOfItems){
        [self didCreateSliderViewAtIndex: nextPage];
         currentIndex ++;
    }
    if( nextPage == _numberOfItems ) {
           rect = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView scrollRectToVisible:rect animated:YES];
    }
    else{
        rect = CGRectMake(nextPage*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView scrollRectToVisible:rect animated:YES];
    }
}

-(void)stopAnimation {
    _willAnimate = NO;
}

-(void)resumeAnimation {
    _willAnimate = YES;
}


-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:LIST_STORE_PLACEHOLDER];
   
    [imgView setImageWithURLRequest:urlRequest
                   placeholderImage:imgPlaceholder
                            success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                
                                CGSize size = weakImgRef.frame.size;
                              
                                if([MGUtilities isRetinaDisplay]) {
                                    size.height *= 2;
                                    size.width *= 2;
                                }
                                
                                UIImage* croppedImage = [image imageByScalingAndCroppingForSize:size];
                                weakImgRef.image = croppedImage;
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
                            }];
}


@end
