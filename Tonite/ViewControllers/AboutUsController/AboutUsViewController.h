//
//  AboutUsViewController.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController <MFMailComposeViewControllerDelegate>{
    NSTimer* animateTimer;
}


@property (strong, nonatomic) IBOutlet UIScrollView *slideShow;

@end
