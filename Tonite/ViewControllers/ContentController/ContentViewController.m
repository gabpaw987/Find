

#import "ContentViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "TabBarViewController.h"
#import "LBHamburgerButton.h"
#import "NSDate+Helper.h"

@interface ContentViewController () <MGSliderDelegate, MGListViewDelegate>

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
   
  //  NSLog(@"Number of Events is .. %lu", (unsigned long)[self.listViewEvents.arrayData count]);
}


-(void) viewDidAppear:(BOOL)animated   {
    [super viewDidAppear:animated];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    listViewEvents.delegate = self;
    listViewEvents.cellHeight = (self.view.frame.size.height-45)/2;
    [listViewEvents registerNibName:@"SliderCell" cellIndentifier:@"SliderCell"];
    [listViewEvents baseInit];
    [self beginParsing];

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
        [listViewEvents reloadData];
    }];
    
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
    vc.event = event;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {

    if(cell!= nil){
    for(UIView* view in cell.subviews)
        [view removeFromSuperview];
    Event* event = [self.listViewEvents.arrayData objectAtIndex:indexPath.row];
    Venue* venue = [CoreDataController getVenueByVenueId:event.venue_id];
    NSArray* photos = [CoreDataController getEventPhotosByEventId:event.event_id ];
    cell.slideShow.imageArray = photos;
    [cell.slideShow setNumberOfItems:[cell.slideShow.imageArray count]];
    
    
        if([cell.slideShow.imageArray count] ==0){
//            cell.slideShow = nil;
//            Photo* p = photos[0];
//            UIImageView * image = [[UIImageView alloc]initWithFrame:cell.frame  ];
//            [self setImage:p.photo_url imageView:image];
//            [cell.contentView addSubview: image];
            
        }
        else{
            CGRect frame = cell.frame;
            frame.size.width = self.view.frame.size.width;
            frame.size.height = listViewEvents.cellHeight-2 ;
            [cell.slideShow setNeedsReLayoutWithViewSize:frame.size];
    
    //*** Timing of the sliding photos **********//
        // NSInteger randomNumber = arc4random() % 9;
        //float x = (float) (randomNumber/ 9) + 2;
    
    [cell.slideShow startAnimationWithDuration:3.0];
    [cell addSubview:cell.slideShow.scrollView];
    //[cell.contentView addSubview: cell.slideShow.scrollView];
        }
 
    
   // [cell.labelExtraInfo setText: event_price????];
        cell.labelTitle.text =event.event_name;
        cell.labelSubtitle.text=  venue.venue_name;
    if(event.event_name == venue.venue_name){
        [cell.labelSubtitle setText:event.event_address];
    }
    NSString* date = [self formatDateWithStart:event.event_date_starttime withEndTime:event.event_endtime];
        [cell.labelDetails setText:date];
        [cell.labelSubtitle setClipsToBounds:YES];
        [cell addSubview: cell.fade ];
        [cell addSubview:cell.labelTitle];
        [cell addSubview:cell.labelSubtitle];
        [cell addSubview:cell.labelExtraInfo];
        [cell addSubview: cell.divider];
        [cell addSubview: cell.labelDetails];
        [cell addSubview: cell.locationIcon];
        [cell setUserInteractionEnabled:YES];
    }
    return cell;
}



-(NSString*)formatDateWithStart:(NSString*)dateAndStart withEndTime:(NSString*)endTime{
    
    NSDate * myDate = [NSDate dateFromString:dateAndStart withFormat:[NSDate dbFormatString]];
    NSString* date = [NSDate stringForDisplayFromFutureDate:myDate prefixed:YES alwaysDisplayTime:YES ];
    // NSString* entireDate = [date stringByAppendingString:[NSDate stringForDisplayFromDate:myDate]];
    return date;
  //  return entireDate;
}


-(void) MGListView:(MGListView *)listView scrollViewDidScroll:(UIScrollView *)scrollView   {
     if(scrollView.contentOffset.y < 15.0)
    {
        [self.tabBarController.navigationController setNavigationBarHidden:NO];
    }
    else if([scrollView.panGestureRecognizer translationInView:self.view].y < 0)
    {
        [self.tabBarController.navigationController setNavigationBarHidden:YES];
    }
    else
    {
        [self.tabBarController.navigationController setNavigationBarHidden:NO];
    }
}




@end