//
//  ContentViewController.m
//  ItemFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "ContentViewController.h"
#import "AppDelegate.h"
#import "NewsDetailViewController.h"
#import "DetailViewController.h"


@interface ContentViewController () <MGSliderDelegate, MGListViewDelegate>

@property (nonatomic, retain) NSArray* arrayFeatured;

@end

@implementation ContentViewController
@synthesize listViewNews;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for( RightSideViewController* vc in self.childViewControllers){
        [vc reloadInputViews];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
    if(screen) {

        CGRect frame = listViewNews.frame;
        frame.origin.y =65;
        frame.size.height = self.view.frame.size.height-65;
        listViewNews.frame = frame;
    }
    
    listViewNews.delegate = self;
    listViewNews.cellHeight = screen ? 300 : 305;
    
    [listViewNews registerNibName:@"NewsCell" cellIndentifier:@"SliderCell"];
    [listViewNews baseInit];
    
    [self beginParsing];
    
    UIBarButtonItem* itemMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_MENU]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(didClickBarButtonMenu:)];
    self.navigationItem.leftBarButtonItem = itemMenu;
    
    UIBarButtonItem* itemLoginMenu = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed: ICON_REGISTER] style:UIBarButtonItemStylePlain target:self action:@selector(didClickProfileMenuButton:)];
    
    self.navigationItem.rightBarButtonItem = itemLoginMenu;
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    swipeGesture.cancelsTouchesInView = YES; //So the user can still interact with controls in the modal view
    
    [self.slidingViewController.view addGestureRecognizer:swipeGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    
    [self.view addGestureRecognizer:tapGesture];
}


- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
       if (sender.state == UIGestureRecognizerStateEnded) {
     UIView* view = sender.view;
     CGPoint loc = [sender locationInView:view];
    //    UIView* subview = [view hitTest:loc withEvent:nil];
   //        NSLog(NSStringFromClass([subview class]));
     if(loc.x < 80 && ([self class] ==[ContentViewController class])){
         for(RightSideViewController* vc in self.childViewControllers){
             [ vc willMoveToParentViewController:nil];
             [ vc.view removeFromSuperview];
             [ vc removeFromParentViewController];
         }
        }
     }
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

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        for(RightSideViewController* vc in self.childViewControllers){
            [ vc willMoveToParentViewController:nil];
            [ vc.view removeFromSuperview];
            [ vc removeFromParentViewController];
        }
    }
}





-(void) didClickProfileMenuButton: (id) sender{
    if(self.childViewControllers.count  == 0){
        RightSideViewController * right = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardRightSide"];
        [self addChildViewController:right];
        [right didMoveToParentViewController:self];
        [self.view addSubview:right.view];
    }
    else{
        for( RightSideViewController* vc in self.childViewControllers){
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
    }
}


-(void)didClickBarButtonMenu:(id)sender {
    for( RightSideViewController* vc in self.childViewControllers){
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
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

-(void)beginParsing {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"LOADING");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
	[hud showAnimated:YES whileExecutingBlock:^{
        
		[self performParsing];
        
	} completionBlock:^{
        
		[hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        [self setData];
        [listViewNews reloadData];
	}];
    
}

-(void) performParsing {
    [DataParser fetchServerData];
}


-(void) setData {
    
    self.arrayFeatured = [CoreDataController getFeaturedStores];
  listViewNews.arrayData = [NSMutableArray arrayWithArray:[CoreDataController getFeaturedStores]];
    
}

-(void)didClickButtonGo:(id)sender {
    
    MGButton* button = (MGButton*)sender;
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    vc.store = button.object;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:SLIDER_PLACEHOLDER];
    
    [imgView setImageWithURLRequest:urlRequest
                   placeholderImage:imgPlaceholder
                            success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                
                                CGSize size = weakImgRef.frame.size;
                                
                                if([MGUtilities isRetinaDisplay]) {
                                    size.height *= 2;
                                    size.width *= 2;
                                }
                                
                                if(IS_IPHONE_6_PLUS_AND_ABOVE) {
                                    size.height *= 3;
                                    size.width *= 3;
                                }
                                
                                UIImage* croppedImage = [image imageByScalingAndCroppingForSize:size];
                                weakImgRef.image = croppedImage;
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
                            }];
}

-(void) MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {

    Store* event= [listViewNews.arrayData objectAtIndex:indexPath.row];
    
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    //vc.strUrl = news.news_url;
    vc.store = event;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell != nil) {
        Store* event = [listViewNews.arrayData objectAtIndex:indexPath.row];
  
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.labelTitle setText:event.store_name   ];
        [cell.labelSubtitle setText: event.store_address];

  
        cell.slideShow.event  = event;
        [cell.slideShow setNibName: @"SliderView"];
        [cell.slideShow setNeedsReLayoutWithViewSize:CGSizeMake(self.view.frame.size.width, cell.frame.size.height)];
        NSInteger randomNumber = arc4random() % 9;
        float x = (float) (randomNumber/ 9) + 2;
        [cell.slideShow startAnimationWithDuration:x];
    }
    return cell;
}



-(void)MGListView:(MGListView *)listView scrollViewDidScroll:(UIScrollView *)scrollView {
}


@end
