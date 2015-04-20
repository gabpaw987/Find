//
//  AboutUsViewController.h
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelDescription;
- (IBAction)contactUs:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *toniteLabel;
@property (strong, nonatomic) IBOutlet UIImageView *divider;

@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *slideShow;

@end
