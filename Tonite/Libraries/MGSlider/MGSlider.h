

#import <UIKit/UIKit.h>
#import "MGRawView.h"
#import "Event.h"


#define SLIDER_OFFSET_Y 0
#define SLIDER_DOT_COUNT 5

@class MGSlider;
@class MGRawView;

@protocol MGSliderDelegate <NSObject>
@end

@interface MGSlider : UIView <UIScrollViewDelegate>
{
    NSInteger _numberOfItems;
    NSTimer *_scrollingTimer;
    int currentIndex;
    __weak id <MGSliderDelegate> _delegate;
}

@property (nonatomic, weak) __weak id <MGSliderDelegate> delegate;
@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, copy) NSString* nibName;
@property (nonatomic, retain) NSArray* imageArray;
@property (nonatomic, retain) Event* event;
@property (nonatomic) BOOL willAnimate;


-(void) setNeedsReLayoutWithViewSize:(CGSize)viewSize;
-(void) startAnimationWithDuration:(float)duration;
-(void)resumeAnimation;
-(void)stopAnimation;

@end
