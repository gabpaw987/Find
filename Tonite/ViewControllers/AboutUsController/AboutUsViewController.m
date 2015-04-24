//
//  AboutUsViewController.m
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AppDelegate.h"

@interface AboutUsViewController ()<UIScrollViewDelegate>
@end

@implementation AboutUsViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.view.backgroundColor = [UIColor whiteColor];
   
    NSArray* aboutUsPics = @[@"aboutUs1.png", @"aboutUs2.png", @"aboutUs3.png"];
    NSArray* aboutUsText = @[@"a better life, a better world - two taps away", @" three students with a vision ", @" better education "];
    self.slideShow.frame =  CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height/2 - 20);
    int posX = 0;
    for(int x = 0; x < [aboutUsPics count]; x++) {
        UIImageView* sliderView = [[UIImageView alloc] initWithFrame:
        CGRectMake(posX, 0.0, self.view.frame.size.width, self.slideShow.frame.size.height)];
        [sliderView setImage:[UIImage imageNamed:aboutUsPics[x]]];
        UILabel * labeltext = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width/2 , self.view.frame.size.width, 50.0)];
        [labeltext setTextAlignment:NSTextAlignmentCenter];
        [labeltext setFont:[UIFont fontWithName:@"Avenir Light" size:14.0]];
        [labeltext setTextColor:[UIColor whiteColor]];
        [labeltext setShadowColor:[UIColor grayColor]];
        [labeltext setOpaque:YES];
        [labeltext setText:aboutUsText[x]];
        [sliderView addSubview: labeltext];
        [self.slideShow addSubview:sliderView];
        posX += self.view.frame.size.width;
    }
    self.slideShow.showsHorizontalScrollIndicator = NO;
    self.slideShow.pagingEnabled = YES;
    self.slideShow.bounces = NO;
    self.slideShow.contentSize = CGSizeMake(posX, self.slideShow.frame.size.height);
    [self.slideShow setUserInteractionEnabled:YES];
    [self.slideShow setBackgroundColor:[UIColor blackColor]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    [self.slideShow addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    swipe.cancelsTouchesInView = YES;
    [self.slideShow addGestureRecognizer:swipe];
    [self.view addSubview: self.slideShow];
    [self startAnimationWithDuration:4.0];
    
    
    UIImageView *divider = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"divider.png"]];
    [divider setFrame:CGRectMake(0.0, self.view.frame.size.height/2 -20, self.view.frame.size.width, 5)];
    [self.view addSubview: divider];
  
    UIImageView * toniteLabel = [[UIImageView alloc]initWithImage:[UIImage imageNamed:TONITE_LOGO ]];
    [toniteLabel setFrame:CGRectMake(57.0, divider.frame.origin.y+12.5, 78.0, 40.0)];
    [self.view addSubview: toniteLabel];
    
    UILabel * aboutLabel = [[UILabel alloc]initWithFrame:CGRectMake(8.0, divider.frame.origin.y+15, 60.0, 30.0)];
    [aboutLabel setText:@"About"];
    [aboutLabel setTextColor:[UIColor blackColor]];
    [aboutLabel setFont:[ UIFont fontWithName:@"Avenir Light" size:20.0]];
    [self.view addSubview:aboutLabel];
    
    UILabel * descriptionLabel = [[UILabel alloc]initWithFrame: CGRectMake(8.0, self.view.frame.size.height/2+ 8, self.view.frame.size.width-16 , self.view.frame.size.height/2 - 30)];
    descriptionLabel.numberOfLines = 0;
    [descriptionLabel setTextAlignment:NSTextAlignmentJustified];
    [descriptionLabel setText:NSLocalizedString(@"ABOUT_US_DETAIL", @"Hello there!")];
    [descriptionLabel sizeToFit];
    [descriptionLabel setTextColor:[UIColor blackColor]];
    [descriptionLabel setFont: [UIFont fontWithName:@"Avenir Light" size:14.0]];
    [descriptionLabel setOpaque: YES];
    [self.view addSubview: descriptionLabel];
    
    UIButton * contactUs = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactUs setFrame: CGRectMake(85.0, descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height - 3, self.view.frame.size.width-170,30.0)];
    [contactUs setTitle:@"Contact Us" forState:UIControlStateSelected];
    [contactUs setTitle:@"Contact Us" forState:UIControlStateNormal];
    [contactUs setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [contactUs setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [contactUs addTarget:self action:@selector(didSelectContact) forControlEvents:UIControlEventTouchUpInside];
    [contactUs.layer setCornerRadius:5.0];
    [contactUs setAlpha: 0.85];
    [contactUs setBackgroundColor:[UIColor lightGrayColor]];
    [contactUs.layer setBorderColor:[UIColor blackColor].CGColor];
    [contactUs.layer setBorderWidth:0.4];
    [contactUs.layer setShadowColor:[UIColor blackColor].CGColor];
    contactUs.layer.shadowOpacity = 0.8;
    contactUs.layer.shadowRadius = 12;
     contactUs.layer.shadowOffset = CGSizeMake(8.0f, 8.0f);
    [contactUs.titleLabel setFont:[UIFont fontWithName:@"Avenir Light" size:16.0] ];
    
    [self.view addSubview: contactUs];
    
 
    UIButton* itemMenu = [UIButton buttonWithType:UIButtonTypeCustom  ];
    [itemMenu addTarget:self action:@selector(didClickBarButtonMenu:) forControlEvents:UIControlEventTouchUpInside  ];
    [itemMenu setBackgroundImage: [UIImage imageNamed:BUTTON_CLOSE] forState:UIControlStateNormal];
    [itemMenu setBackgroundImage:[UIImage imageNamed:BUTTON_CLOSE ]forState:UIControlStateSelected];
    [itemMenu setFrame: CGRectMake(18, 20, 20, 20) ];
    [self.view addSubview:itemMenu];
}
                                              
-(void)didClickBarButtonMenu:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void) startAnimationWithDuration:(float)duration {

    animateTimer  = [NSTimer scheduledTimerWithTimeInterval:duration
                                                       target:self
                                                   selector:@selector(handleGesture:)
                                                     userInfo:nil
                                                  repeats:YES];
}

- (void) didSelectContact{
 
    if ([MFMailComposeViewController canSendMail]) {
        
        // set the sendTo address
        NSMutableArray *recipients = [[NSMutableArray alloc] initWithCapacity:1];
        [recipients addObject:ABOUT_US_EMAIL];
        
        MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        
        [mailController setSubject:LOCALIZED(@"EMAIL_SUBJECT_ABOUT_US")];
        
        [mailController setMessageBody:LOCALIZED(@"EMAIL_SUBJECT_ABOUT_US_MSG") isHTML:NO];
        [mailController setToRecipients:recipients];
        
        if(DOES_SUPPORT_IOS7) {
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        WHITE_TEXT_COLOR, NSForegroundColorAttributeName, nil];
            
            [[mailController navigationBar] setTitleTextAttributes:attributes];
            [[mailController navigationBar ] setTintColor:[UIColor whiteColor]];
            
        }
        
        [self.view.window.rootViewController presentViewController:mailController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
    else {
        [MGUtilities showAlertTitle:LOCALIZED(@"EMAIL_SERVICE_ERROR")
                            message:LOCALIZED(@"EMAIL_SERVICE_ERROR_MSG")];
    }
}


-(void) handleGesture:(id) sender{
    
    if([sender isKindOfClass:[UIGestureRecognizer class]] || [sender isKindOfClass:[UITapGestureRecognizer class]]){
        [animateTimer invalidate];
    }
   
int nextPage = (int)(self.slideShow.contentOffset.x/self.slideShow.frame.size.width) + 1;
CGRect rect = CGRectZero;
    [self.slideShow setAlpha:0.0];
if( nextPage == 3) {
    rect = CGRectMake(0, 0, self.slideShow.frame.size.width, self.slideShow.frame.size.height);
    [UIView transitionWithView:self.slideShow
                      duration:1.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.slideShow scrollRectToVisible:rect animated:YES];
                        [self.slideShow setAlpha:1.0];
                    } completion:nil];
    
}
else{
    rect = CGRectMake(nextPage*self.slideShow.frame.size.width, 0, self.slideShow.frame.size.width, self.slideShow.frame.size.height);
    
    [UIView transitionWithView:self.slideShow
                      duration:1.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.slideShow scrollRectToVisible:rect animated:YES];
                        [self.slideShow setAlpha:1.0];
                    } completion:nil];
}
}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    
	[self becomeFirstResponder];
	[controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:LIST_EVENT_PLACEHOLDER];
    
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
