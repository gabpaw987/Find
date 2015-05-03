

#import "EventViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MGSlider.h"
#import "LBHamburgerButton.h"
#import "NSDate+Helper.h"

@interface EventViewController () <MGSliderDelegate, MGListViewDelegate>

@end

@implementation EventViewController
@synthesize listViewMain;
@synthesize mainCategoryId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.navigationController setNavigationBarHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];

}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden: YES];
    [self.tabBarController.navigationController setNavigationBarHidden: YES];

}

- (UIBarButtonItem *)backButton
{
    LBHamburgerButton* button = [[LBHamburgerButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                                 lineWidth:18
                                                                lineHeight:1
                                                               lineSpacing:3.4
                                                                lineCenter:CGPointMake(10, 0)
                                                                     color:[UIColor grayColor]];
    [button setCenter:CGPointMake(120, 120)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(didClickBarButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.navigationController setNavigationBarHidden:NO];
   
    listViewMain.frame = self.view.frame;
    listViewMain.delegate = self;
    listViewMain.cellHeight = (self.view.frame.size.height-50)/2;
    
    [listViewMain registerNibName:@"SliderCell" cellIndentifier:@"SliderCell"];
    [listViewMain baseInit];
    [self beginParsing];
    
    //Creates the title label on the navigation bar. See ToniteNavigationBar
    [self.tabBarController.navigationItem setTitleView:[ToniteNavigationBar createTitle:[CoreDataController getCategoryByCategoryId:mainCategoryId].category]];

    [self.tabBarController.navigationItem setLeftBarButtonItem: [self backButton]];

    UIRefreshControl* refresher = [[UIRefreshControl alloc]init];
    [refresher addTarget: self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.listViewMain addSubviewRefreshControlWithTintColor:[UIColor whiteColor]];
    
}

-(void) refresh:(UIRefreshControl*)refresher{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // (...code to get new data here...)
        dispatch_async(dispatch_get_main_queue(), ^{
            //any UI refresh
            [refresher endRefreshing];
        });
    });
}

 
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didClickProfileMenuButton:(id) sender{
    if(self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredLeft){
        [self.slidingViewController resetTopViewAnimated:YES];
    }
    else{
        [self.slidingViewController anchorTopViewToLeftAnimated:YES];
    }
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
        [self setData];
        
        
    } completionBlock:^{
        
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        [listViewMain reloadData];
        
        if(listViewMain.arrayData == nil || listViewMain.arrayData.count == 0) {
            [self.listViewMain setUserInteractionEnabled:NO];
            UIColor* color = [[UIColor blackColor] colorWithAlphaComponent:0.70];
            [MGUtilities showStatusNotifier:LOCALIZED(@"NO_RESULTS")
                                  textColor:[UIColor whiteColor]
                             viewController:self
                                   duration:0.5f
                                    bgColor:color
                                        atY:64];
    }
    }];
}


-(void) setData {
    listViewMain.arrayData = [NSMutableArray arrayWithArray:[CoreDataController getEventsByCategoryId:mainCategoryId]];
}

-(void)didClickBarButtonMenu:(id)sender {
    LBHamburgerButton* btn = (LBHamburgerButton*)sender;
    [btn switchState];
    [btn removeTarget:self action:@selector(didClickBarButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self.tabBarController action:@selector(didClickBarButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.navigationItem setTitleView:[ToniteNavigationBar createLogo:@"TONITELOGO_new.png"]];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    Event* event= [listViewMain.arrayData objectAtIndex:indexPath.row];
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    vc.eventId = event.event_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    if(cell !=nil){

    for(UIView* view in cell.subviews)
        [view removeFromSuperview];
    Event* event = [listViewMain.arrayData objectAtIndex:indexPath.row];
    Venue* venue = [CoreDataController getVenueByVenueId:event.venue_id];
    [cell.slideShow setImageArray:[CoreDataController getEventPhotosByEventId:event.event_id] ];
    [cell.slideShow setNumberOfItems:[cell.slideShow.imageArray count]];
    
    
    if([cell.slideShow.imageArray count] != 0){
        CGRect frame = cell.frame;
        frame.size.width = self.view.frame.size.width;
        frame.size.height = listViewMain.cellHeight-2 ;
        [cell.slideShow setNeedsReLayoutWithViewSize:frame.size];
        
        //*** Timing of the sliding photos **********//
        // NSInteger randomNumber = arc4random() % 9;
        //float x = (float) (randomNumber/ 9) + 2;
        
        [cell.slideShow startAnimationWithDuration:2.5];
        [cell addSubview:cell.slideShow.scrollView];
    }
    
 //    [cell.labelExtraInfo setText: event_price????];
    cell.labelTitle.text =event.event_name;
    cell.labelSubtitle.text=  venue.venue_name;
    if(event.event_name == venue.venue_name){
      [cell.labelSubtitle setText:event.event_address1];
    }
        NSString* date = [self formatDateWithStart: event.event_date_starttime withEndTime: event.event_endtime];
    [cell.labelDetails setText:date];
    [cell.labelSubtitle setClipsToBounds:YES];
    [cell addSubview: cell.fade ];
    [cell addSubview:cell.labelTitle];
    [cell addSubview:cell.labelSubtitle];
    [cell addSubview:cell.labelExtraInfo];
    [cell addSubview: cell.divider];
    [cell addSubview: cell.labelDetails];
    [cell addSubview: cell.locationIcon];
   
    }
    return cell;
}

-(NSString*)formatDateWithStart:(NSString*)dateAndStart withEndTime:(NSString*)endTime{
    
    NSDate * myDate = [NSDate dateFromString:dateAndStart withFormat:[NSDate dbFormatString]];
    NSString* date = [NSDate stringForDisplayFromFutureDate:myDate prefixed:YES alwaysDisplayTime:YES ];
    return date;
}

-(void)MGListView:(MGListView *)listView scrollViewDidScroll:(UIScrollView *)scrollView {
    if(([scrollView.panGestureRecognizer translationInView:self.view].y < 0 ) && (scrollView.contentOffset.y > 10.0))
    {
        [self.tabBarController.navigationController setNavigationBarHidden:YES];
    }
    else
    {
        [self.tabBarController.navigationController setNavigationBarHidden:NO];
    }


}

@end