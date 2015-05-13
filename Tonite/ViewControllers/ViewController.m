//
//  ViewController.m
//  VideoLogin
//
//  Created by Lakshay Rastogi on 4/3/15.
//  Copyright (c) 2015 Lakshay Rastogi. All rights reserved.
//
#import "AppDelegate.h"
#import "ViewController.h"
#import "backgroundLabel.h"
#import "OptionLabelButton.h"

@interface ViewController ()<UITextFieldDelegate>{
    UIView* firstView;
    UITextField* emailText;
    UITextField* passwordText;
    UITextField* confirmText;
    UIView* additionalView;
    UIView* addLoginView;
    UIView* otherSocialView;
    UIView* navBar;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.playerLayer setFrame:self.view.bounds];
    [self.view.layer addSublayer:self.playerLayer];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:0.8]];
    
    // loop movie
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(replayMovie:)
                                                 name: AVPlayerItemDidPlayToEndTimeNotification
                                               object: self.playerLayer];
    
    UIView *filter = [[UIView alloc] initWithFrame:self.view.frame];
    filter.backgroundColor = [UIColor whiteColor];
    filter.alpha = 0.05;
    [self.view addSubview:filter];
    
    //FIRST VIEW = the main view with Tonite Logo
    firstView = [[UIView alloc]initWithFrame:self.view.frame];
    //Tonite Image
    UIImageView *welcomeLabel = [[UIImageView alloc] initWithImage: [UIImage imageNamed:TONITE_LOGO]];
    [welcomeLabel setContentMode:UIViewContentModeScaleAspectFit];
    [welcomeLabel setFrame:CGRectMake(0, self.view.bounds.size.height/9, 3*self.view.bounds.size.width/7, self.view.bounds.size.height/7)];
    [welcomeLabel setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/8*1.5)];
    [firstView addSubview:welcomeLabel];
    
    //Stay in the k(now) label
    UILabel* sloganLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, self.view.bounds.size.height/6, self.view.bounds.size.width/2, self.view.bounds.size.height/8)];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"stay in the k(now)."];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir Light" size:18.0] range:NSMakeRange(0, 18)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,14)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(14,3)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(17,2)];
    [sloganLabel setAttributedText:string];
    [sloganLabel setTextAlignment:NSTextAlignmentCenter];
    [sloganLabel setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/6 *1.5)];
    [firstView addSubview:sloganLabel];
    
    //Sign In UIButton
    UIButton *signInButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/7, 7.8*self.view.bounds.size.height/10, 5*self.view.bounds.size.width/7, self.view.bounds.size.height/20)];
    UIImageView* icon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0, 5.0, signInButton.frame.size.height-3, signInButton.frame.size.height - 10)];
    [icon setImage: [UIImage imageNamed:@"emailIcon.png"]];
    [signInButton addSubview: icon];
    [signInButton setAlpha:1.0];
    signInButton.clipsToBounds = YES;
    [signInButton setTitle:@"Sign up With Email" forState:UIControlStateNormal];
    [signInButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [signInButton.titleLabel setFont:[UIFont fontWithName:@"Avenir Light" size:14.0]];
    [signInButton.layer setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.6].CGColor];
    [signInButton addTarget:self action:@selector(didSelectSignUp:) forControlEvents:UIControlEventTouchUpInside];
    [signInButton setShowsTouchWhenHighlighted: YES];
    [firstView addSubview:signInButton];
    
    
    //Facebook UIButton
    UIButton *fbButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/7, 34*self.view.bounds.size.height/40, 5*self.view.bounds.size.width/7, self.view.bounds.size.height/20)];
    fbButton.clipsToBounds = YES;
    UIImageView* fbicon = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 5.0, signInButton.frame.size.height -10, signInButton.frame.size.height - 10)];
    [fbicon setImage: [UIImage imageNamed:@"facebook-icon.png"]];
    [fbButton addSubview:fbicon];
    [fbButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    [fbButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [fbButton.titleLabel setFont:[UIFont fontWithName:@"Avenir Light" size:14.0]];
    [fbButton.layer setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.6].CGColor];
    [fbButton setShowsTouchWhenHighlighted: YES];
    [fbButton addTarget:self action:@selector(didClickLoginToFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [firstView addSubview:fbButton];
    
    OptionLabelButton * otherLogin = [[OptionLabelButton alloc]initWithFrame:CGRectMake(2*self.view.bounds.size.width/7, 36*self.view.bounds.size.height/40, 3*self.view.bounds.size.width/7, 2*self.view.bounds.size.height/38)];
    [otherLogin setTitle:@"or other social media" forState:UIControlStateNormal ];
    [otherLogin addTarget:self action:@selector(didSelectOtherLogin:) forControlEvents:UIControlEventTouchUpInside];
   [firstView addSubview: otherLogin];
    
    OptionLabelButton * loginLabel = [[OptionLabelButton alloc]initWithFrame:CGRectMake(3*self.view.bounds.size.width/18, 37.6*self.view.bounds.size.height/40, 3*self.view.bounds.size.width/7, 2*self.view.bounds.size.height/38)];
    [loginLabel setTitle:@"Already signed up?" forState:UIControlStateDisabled];
    [loginLabel setEnabled:NO];
    [firstView addSubview: loginLabel];
 
     OptionLabelButton * loginUser = [[OptionLabelButton alloc]initWithFrame:CGRectMake(4.7*self.view.bounds.size.width/9, 37.6*self.view.bounds.size.height/40, 2*self.view.bounds.size.width/7, 2*self.view.bounds.size.height/38)];
    [loginUser.titleLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:12.5]];
    [loginUser setTitle:@"Log in here." forState:UIControlStateNormal ];
    [loginUser addTarget:self action:@selector(didSelectLogin:) forControlEvents:UIControlEventTouchUpInside];
    [firstView addSubview: loginUser];
    [self.view addSubview: firstView];
    
    
    
    addLoginView = [[UIView alloc] init];
    
    //Email TextField
    backgroundLabel* emailLabel = [[backgroundLabel alloc] initWithFrame:CGRectMake(0.0, 7.5*self.view.bounds.size.height/20, self.view.bounds.size.width, 2.8*self.view.bounds.size.height/40)];
    [emailLabel setText:@"    Email"];
    [addLoginView addSubview:emailLabel];
    
    emailText = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, 7.5*self.view.bounds.size.height/20, 5*self.view.bounds.size.width/7, 3*self.view.bounds.size.height/40)];
    [emailText setTextAlignment:NSTextAlignmentRight];
    [emailText setClipsToBounds:YES];
    [emailText setTextColor:[UIColor blackColor]];
    [emailText setFont:[UIFont fontWithName:@"Avenir Light" size:14.0]];
    emailText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"example@123.com" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:12.0] }];
    [emailText.layer setOpacity:1.0];
    emailText.delegate = self;
  
    //Password TextField
    backgroundLabel* passwordLabel = [[backgroundLabel alloc] initWithFrame:CGRectMake(0.0, 9*self.view.bounds.size.height/20, self.view.bounds.size.width, 2.8*self.view.bounds.size.height/40)];
    [passwordLabel setText:@"    Password"];
    [addLoginView addSubview:passwordLabel];
    
    passwordText = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, 9.1*self.view.bounds.size.height/20, 5*self.view.frame.size.width/7, 3*self.view.bounds.size.height/40)];
    [passwordText setClipsToBounds:YES];
    [passwordText setSecureTextEntry:YES];
    [passwordText setTextColor:[UIColor blackColor]];
    [passwordText setTextAlignment:NSTextAlignmentRight];
    [passwordText setExclusiveTouch:YES];
    passwordText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"at least 7 characters" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:12.0] }];
    passwordText.delegate = self;
    [addLoginView addSubview:passwordText];
 
    navBar = [[UIView alloc]initWithFrame:CGRectMake(0, -self.view.frame.size.height/6, self.view.frame.size.width, self.view.frame.size.height/6)];
    [navBar.layer setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:0.5].CGColor];
    UILabel* topBar = [[UILabel alloc]initWithFrame:CGRectMake(0.0, self.view.frame.size.height/14, self.view.frame.size.width, 40)];
    [topBar setText: @"Log In"];
    [topBar setFont:[UIFont fontWithName:@"Avenir Light"size:30.0]];
    [topBar setTextAlignment:NSTextAlignmentCenter];
    [topBar setTextColor:[UIColor whiteColor]];
    [navBar addSubview: topBar];
    
    UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneButton setFrame:CGRectMake(4*self.view.frame.size.width/5, self.view.frame.size.height/11, self.view.frame.size.width/7, 25)];
    [doneButton.layer setCornerRadius:5.0];
    [doneButton setClipsToBounds:YES];
    [doneButton.layer setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.8].CGColor];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(didSelectDone:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:doneButton];
 
    UIButton* backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/12, 30.0,30.0)];
    //[backButton.layer setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0].CGColor];
    [backButton addTarget:self action:@selector(didSelectBack:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"backTriangle.png"] forState:UIControlStateNormal];
    [navBar addSubview: backButton];
    [self.view addSubview:navBar];
}

-(void) didSelectOtherLogin:(id) sender{
    otherSocialView = [[UIView alloc]initWithFrame: CGRectMake(0.0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) ];
    
    UIButton * gPlusButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 53, 53)];
    [gPlusButton setCenter:CGPointMake( self.view.frame.size.width/4, self.view.frame.size.height/6)];
    [gPlusButton setImage:[UIImage imageNamed:@"googlePlus.png"] forState:UIControlStateNormal ];
    [otherSocialView addSubview: gPlusButton];
    
    UIButton * twitterButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 68, 68)];
    [twitterButton setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/6)];
    [twitterButton setImage:[UIImage imageNamed:@"twitter1.png"] forState:UIControlStateNormal ];
    [otherSocialView addSubview: twitterButton];
    
    UIButton * instaButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 68, 68)];
    [instaButton setCenter:CGPointMake(3* self.view.frame.size.width/4, self.view.frame.size.height/6)];
    [instaButton setImage:[UIImage imageNamed:@"instagram-new.png"] forState:UIControlStateNormal ];
    [otherSocialView addSubview: instaButton];
    
    UIImageView *toniteLabel = [[UIImageView alloc] initWithImage: [UIImage imageNamed:TONITE_LOGO]];
    [toniteLabel setContentMode:UIViewContentModeScaleAspectFit];
    [toniteLabel setFrame:CGRectMake(0,0, 3*self.view.bounds.size.width/7, self.view.bounds.size.height/8)];
    [toniteLabel setCenter:CGPointMake(self.view.frame.size.width/2, 6*self.view.frame.size.height/7)];
    [otherSocialView addSubview:toniteLabel];
    
    OptionLabelButton * useEmail = [[OptionLabelButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4, 11*self.view.frame.size.height/12, self.view.frame.size.width/2, 20)];
    [useEmail setTitle:@"Sign in with Email" forState:UIControlStateNormal];
    [useEmail addTarget:self action:@selector(didSelectEmail:) forControlEvents:UIControlEventTouchUpInside];
    [otherSocialView addSubview:useEmail];
    [firstView removeFromSuperview];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect frame = self.view.frame;
        [otherSocialView setFrame: frame];
        [self.view addSubview:otherSocialView];
    }completion:nil];
}

-(void) didSelectEmail: (id) sender{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            CGRect frame = otherSocialView.frame;
            frame.origin.y = self.view.frame.size.height/2;
            [otherSocialView setFrame: frame];
            [self.view addSubview: firstView];
        }completion:^(BOOL finished){
            [otherSocialView removeFromSuperview];
            otherSocialView = nil;
        }];
}

-(void) didSelectBack:(id) sender{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect frame = navBar.frame;
        frame.origin.y = -self.view.frame.size.height/6;
        [navBar setFrame: frame];
    }completion:nil];
    [emailText removeFromSuperview];
    [passwordText removeFromSuperview];
    [confirmText removeFromSuperview];
    [additionalView removeFromSuperview];
    additionalView = nil;
    [UIView transitionFromView:addLoginView toView:firstView duration:0.3 options:UIViewAnimationOptionCurveLinear completion:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == emailText){
        [passwordText becomeFirstResponder];
    }
    return YES;
}

-(AVPlayerLayer*)playerLayer
{
    if(!_playerLayer)
    {
        
        // find movie file
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"Yo" ofType:@"mov"];
        NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:[[AVPlayer alloc]initWithURL:movieURL]];
        _playerLayer.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
        [_playerLayer.player play];
    }
    return _playerLayer;
}

-(void) didSelectSignUp:(id) sender{
    
    //For Signup need confirmation of password.
    additionalView = [[UIView alloc]initWithFrame:addLoginView.frame];
    backgroundLabel* confirmLabel = [[backgroundLabel alloc] initWithFrame:CGRectMake(0.0, 10.5*self.view.bounds.size.height/20, self.view.bounds.size.width, 2.8*self.view.bounds.size.height/40)];
    [confirmLabel setText:@"    Confirm Password"];
    [additionalView addSubview:confirmLabel];
    confirmText = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, 10.5*self.view.bounds.size.height/20, 5*self.view.frame.size.width/7, 3*self.view.bounds.size.height/40)];
    [confirmText setClipsToBounds:YES];
    [confirmText setSecureTextEntry:YES];
    [confirmText setTextColor:[UIColor blackColor]];
    [confirmText setTextAlignment:NSTextAlignmentRight];
    confirmText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"re-enter password" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:12.0] }];
     confirmText.delegate = self;
    [self.view addSubview:confirmText];
    [self.view addSubview:passwordText];
    [self.view addSubview:emailText];
    
    [addLoginView addSubview:additionalView];
    [UIView transitionFromView:firstView toView:addLoginView duration:0.3 options:UIViewAnimationOptionCurveLinear completion:nil];
    [self.view addSubview: addLoginView];
    [emailText becomeFirstResponder];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect frame = navBar.frame;
        frame.origin.y = 0;
        [navBar setFrame: frame];
    }completion:^(BOOL finished){
        [self.view addSubview:navBar];
    }];
    
}

-(void) didSelectLogin:(id) sender{

    //For Login need option for resetting password.
    additionalView = [[UIView alloc]initWithFrame:self.view.frame];
    OptionLabelButton * forgotPassword = [[OptionLabelButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/6, 32*self.view.bounds.size.height/60, 3*self.view.bounds.size.width/7, 2*self.view.bounds.size.height/38)];
    [forgotPassword setTitle:@"Forgot your password?" forState:UIControlStateDisabled];
    [forgotPassword setEnabled:NO];
    [additionalView addSubview: forgotPassword];
    
    OptionLabelButton * resetPassword = [[OptionLabelButton alloc]initWithFrame:CGRectMake(5*self.view.bounds.size.width/9, 32.1*self.view.bounds.size.height/60, 2*self.view.bounds.size.width/7, 2*self.view.bounds.size.height/38)];
    [resetPassword setTitle:@" Reset it here." forState:UIControlStateNormal ];
    [resetPassword.titleLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:12.5]];
    [additionalView addSubview: resetPassword];
    [addLoginView addSubview: additionalView];
    [self.view addSubview:passwordText];
    [self.view addSubview:emailText];
    [emailText becomeFirstResponder];

    [UIView transitionFromView:firstView toView:addLoginView duration:0.3 options:UIViewAnimationOptionCurveLinear completion:nil];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect frame = navBar.frame;
        frame.origin.y = 0;
        [navBar setFrame: frame];
    }completion:^(BOOL finished){
        [self.view addSubview:navBar];
    }];
    
}

-(void) didSelectDone:(id) sender{
    
    //check if valid password and email.

    
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    [delegate.window setRootViewController:delegate.slidingViewController];
}

-(void)replayMovie:(NSNotification *)notification
{
    [self.playerLayer.player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}




-(void)didClickLoginToFacebook:(id)sender {
    
    if(![MGUtilities hasInternetConnection]) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
        return;
    }
    
    AppDelegate* appDelegate = [AppDelegate instance];
    //    [appDelegate.session closeAndClearTokenInformation];
    
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        NSArray *permissions = [NSArray arrayWithObjects:@"email", nil];
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session,
           FBSessionState state, NSError *error) {
             
             [self sessionStateChanged:session state:state error:error];
         }];
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error {
    
    switch (state) {
        case FBSessionStateOpen: {
            
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                 
                 if (!error) {
                     //error
                     NSString* facebookId = [user valueForKey:@"id"];
                     NSString* name = [user valueForKey:@"name"];
                     NSString* email = [user valueForKey:@"email"];
                     [self registerViaSocial:facebookId isFacebook:YES name:name email:email];
                 }
                 
             }];
        }
        case FBSessionStateClosed: { }
        case FBSessionStateClosedLoginFailed: { }
        case FBSessionStateCreatedOpening: { }
        case FBSessionStateCreatedTokenLoaded: { }
        case FBSessionStateOpenTokenExtended: { }
        case FBSessionStateCreated: { }
    }
}


-(void)registerViaSocial:(NSString*)anyId isFacebook:(BOOL)isFacebook name:(NSString*)name email:(NSString*)email{
    
    if(![MGUtilities hasInternetConnection]) {
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"REGISTERING_USER");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
    
    NSURL *url = [NSURL URLWithString:REGISTER_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = nil;
    
    if(isFacebook) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  anyId, @"facebook_id",
                  name, @"full_name",
                  email, @"email",
                  nil];
    }
    else {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  anyId, @"twitter_id",
                  name, @"full_name",
                  email, @"email",
                  nil];
    }
    
    [httpClient postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseStr = %@", responseStr);
        
        NSDictionary* dictUser = [json objectForKey:@"user_info"];
        NSDictionary* dictStatus = [json objectForKey:@"status"];
        
        if([[dictStatus valueForKey:@"status_code"] isEqualToString:STATUS_SUCCESS]) {
            
            if(dictUser != nil) {
                
                UserSession* session = [UserSession new];
                session.facebookId = [dictUser valueForKey:@"facebook_id"];
                session.fullName = [dictUser valueForKey:@"full_name"];
                session.loginHash = [dictUser valueForKey:@"login_hash"];
                session.twitterId = [dictUser valueForKey:@"twitter_id"];
                session.userId = [dictUser valueForKey:@"user_id"];
                session.userName = [dictUser valueForKey:@"username"];
                session.email = [dictUser valueForKey:@"email"];
                session.coverPhotoUrl = [dictUser valueForKey:@"photo_url"];
                session.thumbPhotoUrl = [dictUser valueForKey:@"thumb_url"];
                
                [UserAccessSession storeUserSession:session];
                
//                if(_photoPath != nil || _thumbPath != nil) {
//                    [self startSyncPhoto:hud];
               // }
               // else {
                    
                    [hud removeFromSuperview];
                    [self.view setUserInteractionEnabled:YES];
                    
                    [self performSelector:@selector(delaySocial:)
                               withObject:nil
                               afterDelay:0.5];
               // }
            }
        }
        else {
            
            [hud removeFromSuperview];
            [self.view setUserInteractionEnabled:YES];
            
            [MGUtilities showAlertTitle:LOCALIZED(@"LOGIN_ERROR")
                                message:[dictStatus valueForKey:@"status_text"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"SIGNUP_CONNECTING_ERROR")];
    }];
}

-(void)delaySocial:(id)sender {

    AppDelegate* delegate = [AppDelegate instance];
    [delegate.rightMenuController reloadInputViews];
    [delegate.window setRootViewController:delegate.slidingViewController];
  
}
@end
