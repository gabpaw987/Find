//
//  ViewController.m
//  VideoLogin
//
//  Created by Lakshay Rastogi on 4/3/15.
//  Copyright (c) 2015 Lakshay Rastogi. All rights reserved.
//
#import "AppDelegate.h"
#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.playerLayer setFrame:self.view.bounds];
    [self.view.layer addSublayer:self.playerLayer];
    
    // loop movie
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(replayMovie:)
                                                 name: AVPlayerItemDidPlayToEndTimeNotification
                                               object: self.playerLayer];
    
    UIView *filter = [[UIView alloc] initWithFrame:self.view.frame];
    filter.backgroundColor = [UIColor blackColor];
    filter.alpha = 0.05;
    [self.view addSubview:filter];
    
    
    //Tonite Image
    UIImageView *welcomeLabel = [[UIImageView alloc] initWithImage: [UIImage imageNamed:TONITE_LOGO]];
    [welcomeLabel setFrame:CGRectMake(0, self.view.bounds.size.height/8, 3*self.view.bounds.size.width/5, self.view.bounds.size.height/6)];
    [welcomeLabel setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/8*1.5)];
    [self.view addSubview:welcomeLabel];
    
    //Email TextField
    UITextField *emailText = [[UITextField alloc] initWithFrame:CGRectMake(3*self.view.bounds.size.width/24, 26*self.view.bounds.size.height/40, 49*self.view.bounds.size.width/64, 2.5*self.view.bounds.size.height/40)];
    emailText.layer.borderColor = [[UIColor whiteColor] CGColor];
    emailText.layer.borderWidth = 1.0;
    [emailText.layer setCornerRadius:5.0];
    [emailText setClipsToBounds:YES];
    emailText.placeholder = @" Email";
    [emailText setTextColor:[UIColor whiteColor]];
    emailText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:16.0] }];
    [emailText setTintColor:[UIColor whiteColor]];
    emailText.delegate = self;
    [self.view addSubview:emailText];
    
    //Password TextField
    UITextField *passwordText = [[UITextField alloc] initWithFrame:CGRectMake(3*self.view.bounds.size.width/24, 29*self.view.bounds.size.height/40, 49*self.view.bounds.size.width/64, 2.5*self.view.bounds.size.height/40)];
    passwordText.layer.borderColor = [[UIColor whiteColor] CGColor];
    passwordText.layer.borderWidth = 1.0;
    [passwordText.layer setCornerRadius:5.0];
    [passwordText setClipsToBounds:YES];
    [passwordText setSecureTextEntry:YES];
    [passwordText setTextColor:[UIColor whiteColor]];
    passwordText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:16.0] }];
    [passwordText setTintColor:[UIColor whiteColor]];
    passwordText.delegate = self;
    [self.view addSubview:passwordText];
    
    //Sign In UIButton
    UIButton *signInButton = [[UIButton alloc] initWithFrame:CGRectMake(3*self.view.bounds.size.width/24, 8*self.view.bounds.size.height/10, 49*self.view.bounds.size.width/64, 2.5*self.view.bounds.size.height/40)];
    signInButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    signInButton.layer.borderWidth = 1.0;
    signInButton.layer.cornerRadius = 5.0;
    signInButton.clipsToBounds = YES;
    signInButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [signInButton setTintColor:[UIColor whiteColor]];
    [signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [signInButton.titleLabel setFont:[UIFont fontWithName:@"Avenir Light" size:18.0]];
    [signInButton.layer setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6].CGColor];
    [signInButton addTarget:self action:@selector(didSelectLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInButton];
    
    
    //Facebook UIButton
    UIButton *fbButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/8, 35*self.view.bounds.size.height/40, 3*self.view.bounds.size.width/8, 2.5*self.view.bounds.size.height/40)];
    fbButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    fbButton.layer.borderWidth = 1.0;
    fbButton.layer.cornerRadius = 5.0;
    fbButton.clipsToBounds = YES;
    fbButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [fbButton setTintColor:[UIColor whiteColor]];
    [fbButton setTitle:@"Facebook" forState:UIControlStateNormal];
    [fbButton.titleLabel setFont:[UIFont fontWithName:@"Avenir Light" size:18.0]];
    [fbButton.layer setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6].CGColor];
    [self.view addSubview:fbButton];
    
    //Twitter UIButton
    UIButton *twitterButton = [[UIButton alloc] initWithFrame:CGRectMake(33*self.view.bounds.size.width/64, 35*self.view.bounds.size.height/40, 3*self.view.bounds.size.width/8, 2.5*self.view.bounds.size.height/40)];
    twitterButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    twitterButton.layer.borderWidth = 1.0f;
    twitterButton.layer.cornerRadius = 5.0;
    twitterButton.clipsToBounds = YES;
    twitterButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [twitterButton setTintColor:[UIColor whiteColor]];
    [twitterButton setTitle:@"Twitter" forState:UIControlStateNormal];
    [twitterButton.titleLabel setFont:[UIFont fontWithName:@"Avenir Light" size:18.0]];
    [twitterButton.layer setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6].CGColor];
    [self.view addSubview:twitterButton];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
        _playerLayer.player.play;
    }
    return _playerLayer;
}

-(void) didSelectLogin:(id) sender{
    AppDelegate* delegate = [[UIApplication sharedApplication]delegate];
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

@end
