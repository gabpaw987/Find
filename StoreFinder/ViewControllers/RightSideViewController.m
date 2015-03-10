//
//  RightSideViewController.m
//  StoreFinder
//
//  Created by Julie Murakami on 3/2/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "RightSideViewController.h"
#import "AppDelegate.h"

@interface RightSideViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, retain) UserSession* user;
@property (nonatomic, retain) NSArray* titles;
@property (nonatomic, retain) NSArray* subtitles;

@end

@implementation RightSideViewController

@synthesize userProfilePicture;
@synthesize tableSideView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
   self.user = [UserAccessSession getUserSession];
    self.subtitles = @[ @"Create An Account",@"Sign In" ];
    [self setImage:self.user.thumbPhotoUrl imageView:userProfilePicture withBorder:YES isThumb:YES];
   
    if( self.user != nil) {
        self.subtitles = @[@"My Account", @"Sign Out"];
    }
    
  
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    tableSideView.delegate = self;
    tableSideView.dataSource = self;
    
  //  self.view.layer.bounds = CG
    
    [self.view bringSubviewToFront:self.view];
    
    //DARKEN OUTSIDE MENU SCREEN
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 80.0, self.view.frame.size.height);
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)THEME_BLACK_TINT_COLOR.CGColor,
                            (id)[UIColor clearColor].CGColor,
                            nil];
    gradientLayer.startPoint = CGPointMake(0.4,0.0);
    gradientLayer.endPoint = CGPointMake(0.0,0.9);
    [self.view.layer addSublayer:gradientLayer];
    
    
        self.titles =@[
                  @"Settings",
                  @"About Tonite",
                  @"Terms and Condition" ];
}
    
   

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
    int height = screen ? 40 : 44;
    
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([ self.titles count]+ [self.subtitles count]);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   UITableViewCell* cell = [[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RightSideViewCell"];
    NSInteger index = indexPath.row ;
    if(index < [self.titles count])
        cell.textLabel.text = self.titles[index];
    else
        cell.textLabel.text = self.subtitles[(index- [self.titles count])];
    return cell;
}

- (void) showViewController:(UIViewController*)viewController {
    
    UINavigationController* navController = (UINavigationController*)[self.slidingViewController topViewController];
    [navController popToRootViewControllerAnimated:NO];
    
    UIViewController* currentViewController = [[navController viewControllers] objectAtIndex:0];
    
    if([currentViewController isKindOfClass:[viewController class]])
        return;
    
    [navController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    //self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
  
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"User_iPhone" bundle:nil];

    
    if (indexPath.row == 0) {
        //PUSH NOTIFICATION SETTINGS
        
        //OTHER SETTINGS??
    }
    if(indexPath.row == 1){
    UIViewController* vc = [story instantiateViewControllerWithIdentifier:@"storyboardAboutUs"];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        AppDelegate* delegate = [AppDelegate instance];
        [[delegate.window rootViewController] presentViewController:vc animated:YES completion:nil];
        [self.slidingViewController resetTopViewAnimated:YES];
   // [self showViewController:vc];
    //[self.slidingViewController resetTopViewAnimated:YES];
        
    }
    if(indexPath.row == 2){
       UIViewController* vc = [story instantiateViewControllerWithIdentifier:@"storyboardTC"];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        AppDelegate* delegate = [AppDelegate instance];
        [[delegate.window rootViewController] presentViewController:vc animated:YES completion:nil];
        [self.slidingViewController resetTopViewAnimated:YES];
        
        //[self.navigationController presentViewController:vc animated:YES completion:nil];
        // [self showViewController:vc ];
       // [self.slidingViewController resetTopViewAnimated:YES];
        
    }
    if(indexPath.row == 3){
      //  UIStoryboard* story = [UIStoryboard storyboardWithName:@"User_iPhone" bundle:nil];
          NSString* nextView = @"storyboardRegister";
        if(self.user!= nil)
            nextView = @"storyboardProfile";
        UIViewController* vc = [story instantiateViewControllerWithIdentifier: nextView];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        AppDelegate* delegate = [AppDelegate instance];
        [[delegate.window rootViewController] presentViewController:vc animated:YES completion:nil];
        [self.slidingViewController resetTopViewAnimated:YES];
    }
    if(indexPath.row == 4){
        if(self.user ==nil){
         //   UIStoryboard* story = [UIStoryboard storyboardWithName:@"User_iPhone" bundle:nil];
            UIViewController* vc = [story instantiateViewControllerWithIdentifier: @"storyboardLogin"];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            AppDelegate* delegate = [AppDelegate instance];
            [[delegate.window rootViewController] presentViewController:vc animated:YES completion:nil];
            [self.slidingViewController resetTopViewAnimated:YES];
        }
        else{
            
            [UserAccessSession clearAllSession];
            [[FHSTwitterEngine sharedEngine] clearAccessToken];
            [FBSession.activeSession closeAndClearTokenInformation];
            [FBSession.activeSession close];
            [FBSession setActiveSession:nil];
            //[self.slidingViewController removeFromParentViewController];
            
        }
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    /*
    //Make sure your segue name in storyboard is the same as this line
        if ([[segue identifier] isEqualToString:@"modalTC"])
        {
            // Get reference to the destination view controller
            UIViewController* vc = [segue destinationViewController];
            
            // Pass any objects to the view controller here, like...
            
        }
    */
}


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
                                                   borderColor:THEME_MAIN_COLOR
                                                   shadowColor:[UIColor clearColor]
                                                   borderWidth:CELL_BORDER_WIDTH];
                                }
                                
                                
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
    }];
}

-(void) reloadInputViews {
    
    self.user = [UserAccessSession getUserSession];
    
    [self setImage:self.user.thumbPhotoUrl imageView:userProfilePicture withBorder:YES isThumb:YES];
    if( self.user != nil) {
        self.subtitles = @[@"My Account", @"Sign Out"];
    }
    else{
        self.subtitles = @[ @"Create An Account",@"Sign In" ];
    }
    [tableSideView reloadData];

}
 
@end

