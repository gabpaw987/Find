//
//  AboutUsViewController.m
//  Tonite



#import "AboutToniteViewController.h"
#import "AppDelegate.h"

@interface AboutToniteViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView * mainView;
@property (nonatomic, strong) UIScrollView* slideShow;
@end

@implementation AboutToniteViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mainView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.view.backgroundColor = [UIColor whiteColor];

    //Setup rotating images
    NSArray* aboutUsPics = @[ABOUT_PIC1 , ABOUT_PIC2, ABOUT_PIC3];
    NSArray* aboutUsText = @[@"a better life, a better world - two taps away", @" three students with a vision ", @" better education "];
    UIScrollView *  slider = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height/2 - 20)];
    self.slideShow = slider;
    int posX = 0;
    for(int x = 0; x < [aboutUsPics count]; x++) {
        UIImageView* sliderView = [[UIImageView alloc] initWithFrame:
        CGRectMake(posX, 0.0, self.view.frame.size.width, self.slideShow.frame.size.height)];
        [sliderView setImage:[UIImage imageNamed:aboutUsPics[x]]];
        UILabel * labeltext = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.width/2-20, self.view.frame.size.width, 50.0)];
        [labeltext setTextAlignment:NSTextAlignmentCenter];
        [labeltext setFont:[UIFont fontWithName:@"Avenir Light" size:14.0]];
        [labeltext setTextColor:[UIColor whiteColor]];
        [labeltext setShadowColor:[UIColor lightGrayColor]];
        [labeltext setOpaque:YES];
        [labeltext setText:aboutUsText[x]];
        [sliderView addSubview: labeltext];
        [self.slideShow addSubview:sliderView];
        posX += self.view.frame.size.width;
    }
    self.slideShow.showsHorizontalScrollIndicator = NO;
    self.slideShow.scrollEnabled= NO;
    self.slideShow.pagingEnabled = YES;
    self.slideShow.bounces = NO;
    self.slideShow.contentSize = CGSizeMake(posX, self.slideShow.frame.size.height);
    [self.slideShow setUserInteractionEnabled:YES];
 
 
    //Add gestures to the rotating images
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    [self.slideShow addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    swipe.cancelsTouchesInView = YES;
    [self.slideShow addGestureRecognizer:swipe];
    [self.mainView addSubview: self.slideShow];
    [self startAnimationWithDuration:4.0];
    
    //Add divider between images and description.
    UIImageView *divider = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"divider.png"]];
    [divider setFrame:CGRectMake(0.0, self.view.frame.size.height/2-20, self.view.frame.size.width, 5)];
    [self.mainView addSubview: divider];
  
    //Adds the Tonite logo in "About tonite"
    UIImageView * toniteLabel = [[UIImageView alloc]initWithImage:[UIImage imageNamed:TONITE_LOGO ]];
    [toniteLabel setFrame:CGRectMake(45.5, divider.frame.origin.y+12, 68.0, 36.0)];
    [self.mainView addSubview: toniteLabel];
    
    UILabel * aboutLabel = [[UILabel alloc]initWithFrame:CGRectMake(8.0, divider.frame.origin.y+14, 60.0, 30.0)];
    [aboutLabel setText:@"About"];
    [aboutLabel setTextColor:[UIColor blackColor]];
    [aboutLabel setFont:[ UIFont fontWithName:@"Avenir Light" size:16.0]];
    [self.mainView addSubview:aboutLabel];
    
    
    //Setup Description
    //The text is stored in Localized string file.
    UILabel * descriptionLabel = [[UILabel alloc]initWithFrame: CGRectMake(8.0, aboutLabel.frame.origin.y, self.view.frame.size.width-16 , self.view.frame.size.height/2 - 30)];
    descriptionLabel.numberOfLines = 0;
    [descriptionLabel setTextAlignment:NSTextAlignmentJustified];
    [descriptionLabel setText:NSLocalizedString(@"ABOUT_US_DETAIL", @"Hello there!")];
    [descriptionLabel sizeToFit];
    [descriptionLabel setTextColor:[UIColor blackColor]];
    [descriptionLabel setFont: [UIFont fontWithName:@"Avenir Light" size:13.0]];
    [descriptionLabel setOpaque: YES];
    [self.mainView addSubview: descriptionLabel];
    
    
    //Setup contact up button
    UIButton * contactUs = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactUs setFrame: CGRectMake(85.0, descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height -25, self.view.frame.size.width-170,30.0)];
    [contactUs setTitle:@"Contact Us" forState:UIControlStateSelected];
    [contactUs setTitle:@"Contact Us" forState:UIControlStateNormal];
    [contactUs setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [contactUs setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [contactUs addTarget:self action:@selector(didSelectContact) forControlEvents:UIControlEventTouchUpInside];
    [contactUs.layer setCornerRadius:5.0];
    [contactUs setBackgroundColor:[UIColor lightGrayColor]];
    [contactUs.layer setBorderColor:[UIColor blackColor].CGColor];
    [contactUs.layer setBorderWidth:0.4];
    [contactUs.layer setShadowColor:[UIColor blackColor].CGColor];
    contactUs.layer.shadowOpacity = 0.8;
    contactUs.layer.shadowRadius = 12;
     contactUs.layer.shadowOffset = CGSizeMake(8.0f, 8.0f);
    [contactUs.titleLabel setFont:[UIFont fontWithName:@"Avenir Light" size:16.0] ];
    [self.mainView addSubview: contactUs];
 
    //resize scroll view
    CGRect frame = self.view.frame;
    frame.size.height = contactUs.frame.origin.y + 50;
    [self.mainView setContentSize: frame.size];
    self.mainView.scrollEnabled = YES;
    self.mainView.bounces = NO;
    self.mainView.userInteractionEnabled = YES;
    [self.view addSubview: self.mainView];

    
    
//    UIButton* itemMenu = [UIButton buttonWithType:UIButtonTypeCustom  ];
//    [itemMenu addTarget:self action:@selector(didClickBarButtonMenu:) forControlEvents:UIControlEventTouchUpInside  ];
//    [itemMenu setBackgroundImage: [UIImage imageNamed:BUTTON_CLOSE] forState:UIControlStateNormal];
//    [itemMenu setBackgroundImage:[UIImage imageNamed:BUTTON_CLOSE ]forState:UIControlStateSelected];
//    [itemMenu setFrame: CGRectMake(18, 20, 20, 20) ];
//    [self.view addSubview:itemMenu];
//    
//
//    UIBarButtonItem* buttonCancel = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(didClickCancel)];
//    [buttonCancel setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:13.0]} forState:UIControlStateNormal];
//    [buttonCancel setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:13.0]} forState:UIControlStateSelected];
//    [self.navigationItem setLeftBarButtonItem:buttonCancel];
    
}
                                              
-(void)didClickCancel{
    [self.navigationController popViewControllerAnimated:YES];
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
                                        [UIColor whiteColor], NSForegroundColorAttributeName, nil];
            
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

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if([scrollView.panGestureRecognizer translationInView:self.view].y < 0)
    {
      //  [self.navigationController setNavigationBarHidden:YES];
     //  [self.navigationItem setHidesBackButton:YES animated:NO];
       // [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else
    {
        //[self.navigationController setNavigationBarHidden:NO];
     //   [self.navigationItem setHidesBackButton:NO animated:YES];
    }
    
}

@end
