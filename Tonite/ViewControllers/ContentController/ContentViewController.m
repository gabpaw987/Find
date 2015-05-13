
#import "ContentViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "TabBarViewController.h"
#import "LBHamburgerButton.h"
#import "NSDate+Helper.h"

@interface ContentViewController () <MGListViewDelegate>

@end

@implementation ContentViewController
@synthesize listViewEvents;


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
    [self.tabBarController.tabBar setHidden:YES];
    [self.tabBarController.navigationController setNavigationBarHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];
    //[self.listViewEvents scrollToTop];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.navigationController setNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
   }


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    // Do any additional setup after loading the view.
   
    listViewEvents.delegate = self;
    listViewEvents.cellHeight = (self.view.frame.size.height-45)/2;
    [listViewEvents registerNibName:@"SliderCell" cellIndentifier:@"SliderCell"];
    [listViewEvents baseInit];
    self.listViewEvents.frame = self.view.frame;
    [self beginParsing];
    
//Use MGList RefreshControl
    [self.listViewEvents addSubviewRefreshControlWithTintColor:[UIColor whiteColor]];
}

-(void) refresh:(UIRefreshControl*)refresher{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [refresher endRefreshing];
        });
    });
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
         [DataParser fetchServerData];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [hud showAnimated:YES whileExecutingBlock:^{
                [self setData];
            }completionBlock:^{
                [hud removeFromSuperview ];
                [listViewEvents reloadData];
                [self.view setUserInteractionEnabled:YES];
            }];
        });
    });
}


-(void) performParsing {
    [DataParser fetchServerData];
}


-(void) setData {
    listViewEvents.arrayData = [NSMutableArray arrayWithArray:[CoreDataController getAllEvents]];
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
    Event* event= [listViewEvents.arrayData objectAtIndex:indexPath.row];
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    vc.eventId = event.event_id;
    [self.navigationController pushViewController:vc animated:YES];
}


-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell!= nil){
        
        Event* event = [self.listViewEvents.arrayData objectAtIndex:indexPath.row];
        Venue* venue = [CoreDataController getVenueByVenueId:event.venue_id];
        [cell.imgView setArrayPhotos: [CoreDataController getEventPhotosByEventId:event.event_id ]];
        [cell.imgView startAnimating: 3.0];

        // Timing of the sliding photos **********//
        // NSInteger randomNumber = arc4random() % 9;
        //float x = (float) (randomNumber/ 9) + 2;
        
        TicketType* ticket = [CoreDataController getTicketTypeByEventId:event.event_id];
        [cell.labelExtraInfo setText:[ NSString stringWithFormat: @"$%@", ticket.ticket_price]];
                
        cell.labelTitle.text =event.event_name;
        if(event.event_name == venue.venue_name){
            [cell.labelSubtitle setText:event.event_address1];
        }
        else{
            [cell.labelSubtitle setText: venue.venue_name];
        }
        NSString* date = [self formatDateWithStart:event.event_date_starttime withEndTime:event.event_endtime];
        [cell.labelDetails setText:date];
        [cell setUserInteractionEnabled:YES];
    }
    
    return cell;
}



-(NSString*)formatDateWithStart:(NSString*)dateAndStart withEndTime:(NSString*)endTime{
    
    NSDate * myDate = [NSDate dateFromString:dateAndStart withFormat:[NSDate dbFormatString]];
    NSString* date = [NSDate stringForDisplayFromFutureDate:myDate prefixed:YES alwaysDisplayTime:YES ];
  return date;
}

-(void)MGListView:(MGListView *)listView scrollViewDidScroll:(UIScrollView *)scrollView {
   if([scrollView.panGestureRecognizer translationInView:self.view].y < 0 ){
        [self.tabBarController.navigationController setNavigationBarHidden:YES];
    }
    else{
        [self.tabBarController.navigationController setNavigationBarHidden:NO];
    }
}


@end