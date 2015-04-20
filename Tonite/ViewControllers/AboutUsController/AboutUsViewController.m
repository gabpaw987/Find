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
   
    [self.labelDescription setText:NSLocalizedString(@"ABOUT_US_DETAIL", @"Hello there!")];

    NSArray* aboutUsPics = @[ABOUT_PIC1, ABOUT_PI2, ABOUT_PIC3 ];
    
    self.slideShow.delegate = self;
    int posX = 0;
    for(int x = 0; x < [aboutUsPics count]; x++) {
        UIImageView* sliderView = [[UIImageView alloc] initWithFrame:
        CGRectMake(posX, 0.0, self.view.frame.size.width, self.slideShow.frame.size.height)];
        [self setImage:aboutUsPics[x] imageView: sliderView];
        [self.slideShow addSubview:sliderView];
        posX += self.view.frame.size.width;
    }
    self.slideShow.showsHorizontalScrollIndicator = NO;
    self.slideShow.pagingEnabled = YES;
    self.slideShow.bounces = NO;
    self.slideShow.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.slideShow.frame.size.height);
    self.slideShow.contentSize = CGSizeMake(posX, self.slideShow.frame.size.height);
    [self.slideShow setUserInteractionEnabled:YES];
    [self.divider setFrame:CGRectMake(0.0, self.slideShow.frame.size.height, self.view.frame.size.width, 5)];
    [self.view addSubview: self.divider];
    [self.toniteLabel setFrame:CGRectMake(60.0, self.divider.frame.origin.y+12.5, 75.0, 38.0)];
    [self.view addSubview: self.toniteLabel];
    [self.aboutLabel setFrame:CGRectMake(8.0, self.divider.frame.origin.y+15, 60.0, 30.0)];
    [self.view addSubview: self.aboutLabel];
 
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
//  UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardContent"];
//
//    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
//    [self.navigationController setViewControllers:[NSArray arrayWithObject: vc]];
//    [self.slidingViewController resetTopViewAnimated:YES];



- (IBAction)contactUs:(id)sender    {
 
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
