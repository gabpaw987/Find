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
@property (nonatomic, retain) NSString* title1;

@end

@implementation RightSideViewController

@synthesize userProfilePicture;
@synthesize tableSideView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   self.user = [UserAccessSession getUserSession];
    self.title1 = @"Create An Account";
    
    if( self.user != nil && self.user.coverPhotoUrl != nil) {
        [self setImage:self.user.coverPhotoUrl imageView:userProfilePicture withBorder:YES isThumb:YES];
        self.title1 = @"My Account";
    }
    
    self.view.backgroundColor = SIDE_VIEW_BG_COLOR;
    
    tableSideView.delegate = self;
    tableSideView.dataSource = self;
    
    
    //DARKEN OUTSIDE MENU SCREEN
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    int x = self.view.frame.size.width -ANCHOR_RIGHT_PEEK-1;
    gradientLayer.frame = CGRectMake(-x, 0, x, self.view.frame.size.height);
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)THEME_BLACK_TINT_COLOR.CGColor,
                            (id)[UIColor clearColor].CGColor,
                            nil];
   
    gradientLayer.startPoint = CGPointMake(-2,0.5);
    gradientLayer.endPoint = CGPointMake(1,0.5);
    [self.view.layer addSublayer:gradientLayer];
    
    self.titles =@[
                  @"Settings",
                  @"About Tonite",
                  @"Terms and Condition", self.title1  ];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    
    [self.slidingViewController.view addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    swipeGesture.cancelsTouchesInView = YES; //So the user can still interact with controls in the modal view
    
    [self.slidingViewController.view addGestureRecognizer:swipeGesture];
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

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIView* view = sender.view;
        CGPoint loc = [sender locationInView:view];
        UIView* subview = [view hitTest:loc withEvent:nil];
        //NSLog(NSStringFromClass([subview class]));
        
        if (![NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellContentView"] &&
            [subview class] != [UIView class] &&
            [subview class] != [UINavigationItem class] &&
            subview != self.view) {
            [self.slidingViewController resetTopViewAnimated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
    int height = screen ? 40 : 44;
    
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ self.titles count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   UITableViewCell* cell = [[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RightSideViewCell"];

    cell.textLabel.text = self.titles[indexPath.row];
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
    
    if (indexPath.row == 0) {
        
    }
    if(indexPath.row == 1){
        UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardAboutUs"];
    [self showViewController:vc];
    [self.slidingViewController resetTopViewAnimated:YES];
        
    }
    if(indexPath.row == 2){
        UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardTC"];
        [self showViewController:vc ];
        [self.slidingViewController resetTopViewAnimated:YES];
        
    }
    if(indexPath.row == 3){
        UIStoryboard* story = [UIStoryboard storyboardWithName:@"User_iPhone" bundle:nil];
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
                                                   borderColor:THEME_MAIN_COLOR
                                                   shadowColor:[UIColor clearColor]
                                                   borderWidth:CELL_BORDER_WIDTH];
                                }
                                
                                
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
    }];
}

-(void) updateUI{
    [tableSideView reloadData];

}
 
@end

