//
//  AboutUsViewController.h
//  Tonite
//

#import <UIKit/UIKit.h>

@interface AboutToniteViewController : UIViewController <MFMailComposeViewControllerDelegate>{
    NSTimer* animateTimer;
}


@property (strong, nonatomic) IBOutlet UIScrollView *scrollMain;

@end
