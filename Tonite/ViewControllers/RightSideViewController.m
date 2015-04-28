//
//  RightSideViewController.m
//  StoreFinder
//
//  Created by Julie Murakami on 3/2/15.
//  Copyright (c) 2015 Client. All rights reserved.

//Also is the Profile Menu Controller : get called by ECSlidingViewController


#import "RightSideViewController.h"
#import "AppDelegate.h"
#import "SettingsController.h"
#import "AboutToniteViewController.h"

@interface RightSideViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, retain) UserSession* user;
@property (nonatomic, retain) NSArray* titles;
@property (nonatomic, retain) UIImageView* userProfilePicture;
@end

@implementation RightSideViewController

@synthesize userProfilePicture;
@synthesize tableSideView;

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadInputViews];
}

-(void) viewWillDisappear:(BOOL)animated    {
    [super viewWillDisappear:animated];
    //If we want to clear the side menu after opening settings/my wallet/etc. 
    //  [self.slidingViewController resetTopViewAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    // Do any additional setup after loading the view
    
    //Set up table
    tableSideView.delegate = self;
    tableSideView.dataSource = self;
    [tableSideView setFrame:CGRectMake(5.0,2*self.view.frame.size.height/5, self.view.frame.size.width, self.view.frame.size.height)];
    [tableSideView setBackgroundColor:[UIColor blackColor]];
    self.titles =@[
                   @"Settings",
                   @"Friends",
                   @"My Wallet"
                   ];
    
    //peekAmount is the LeftPeekAmount or how much the top view is still visible
    CGFloat peekAmount = self.view.frame.size.width/4;

    //Set the background image
    UIImageView* imgBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HEADHEAD.jpg"]];
    [imgBackground setFrame: CGRectMake(peekAmount, 0.0, self.view.frame.size.width - peekAmount,2*self.view.frame.size.height/5)];
    [imgBackground setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:imgBackground];
    
    //Place the line between image and table
    UIImageView * divider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar.png"]];
    [divider setFrame:CGRectMake(0, 2* self.view.frame.size.height/5-25, self.view.frame.size.width, 3)];
    [divider setAlpha:0.4];
    [self.view addSubview:divider];
    
    //Place profile picture
    self.userProfilePicture = [[UIImageView alloc]initWithFrame:CGRectMake(peekAmount + ((self.view.frame.size.width-peekAmount)/2) - self.view.frame.size.height/20, 2*self.view.frame.size.height/5 - 50, self.view.frame.size.height/10, self.view.frame.size.height/10)];
    [self setImage:self.user.thumbPhotoUrl imageView:userProfilePicture withBorder:YES isThumb:YES];
    [self.userProfilePicture.layer setCornerRadius:self.view.frame.size.height/20];
    [self.userProfilePicture setClipsToBounds:YES];
    [self.userProfilePicture.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.userProfilePicture.layer setShadowOpacity:0.7];
    [MGUtilities createBorders:self.userProfilePicture borderColor:[UIColor lightGrayColor] shadowColor:[UIColor grayColor] borderWidth:2.5];
    [self.view addSubview:userProfilePicture];
    
    
    //Add gesture to slide back to menu
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    swipeGesture.cancelsTouchesInView = YES; //So the user can still interact with controls in the modal view
    
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:@"RightSideViewCell"];
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir Light" size:16.0]];
    [cell.selectedBackgroundView setBackgroundColor:[UIColor grayColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        //SETTINGS
        UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsNavigator"];
        [self.slidingViewController presentViewController:vc animated:YES completion:nil];
    }
    if(indexPath.row == 1){
        //MY FRIENDS
        [self.slidingViewController resetTopViewAnimated:YES];
    }
    if(indexPath.row == 2){
     //MY WALLET
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView withBorder:(BOOL)border isThumb:(BOOL)isThumb{
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    
    NSString* thumbPlaceholder = isThumb ? PROFILE_THUMB_PLACEHOLDER_IMAGE : PROFILE_PLACEHOLDER_IMAGE;
    UIImage* imgPlaceholder = [UIImage imageNamed:thumbPlaceholder];
    
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
                                
                                if(border) {
                                    [MGUtilities createBorders:weakImgRef
                                                   borderColor:[UIColor blackColor]
                                                   shadowColor:[UIColor clearColor]
                                                   borderWidth:CELL_BORDER_WIDTH];
                                }
                                
                                
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
    }];
}

-(void) reloadInputViews{
    self.user = [UserAccessSession getUserSession];
    //[self setImage:self.user.thumbPhotoUrl imageView:userProfilePicture withBorder:YES isThumb:YES];
    [tableSideView reloadData];

}
 
@end

