

#import "ContentViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"


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
    [self.tabBarController.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
    if(screen) {
        
        CGRect frame = listViewEvents.frame;
        frame.origin.y =65;
        frame.size.height = self.view.frame.size.height-65;
        listViewEvents.frame = frame;
    }
    
    listViewEvents.delegate = self;
    listViewEvents.cellHeight = self.view.frame.size.height/2;
    
    
    [listViewEvents registerNibName:@"SliderCell" cellIndentifier:@"SliderCell"];
    [listViewEvents baseInit];
    
    [self beginParsing];
    
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

-(void)didClickButtonGo:(id)sender {
    
    MGButton* button = (MGButton*)sender;
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    vc.event = button.object;
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
    
    Event* event= [listViewEvents.arrayData objectAtIndex:indexPath.row];
    
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    //vc.strUrl = news.news_url;
    vc.event = event;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    if(cell == nil){
        cell = [[MGListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SliderCell"];
    }
    for(UIView* view in cell.subviews)
        [view removeFromSuperview];
    //[cell setBackgroundColor:[UIColor clearColor]];
    
    Event* event = [listViewEvents.arrayData objectAtIndex:indexPath.row];
    
    [cell.slideShow setImageArray:[CoreDataController getEventPhotosByEventId:event.event_id] ];
    [cell.slideShow setNumberOfItems:[cell.slideShow.imageArray count]];
    
    CGRect frame = cell.frame;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = listViewEvents.cellHeight;
    
    if([cell.slideShow.imageArray count] == 0){
        //Default pic?
    }
    else{
        
    
    cell.slideShow.event  = event;
    [cell.slideShow setNeedsReLayoutWithViewSize:frame.size];
    
    //*** Timing of the sliding photos **********//
        // NSInteger randomNumber = arc4random() % 9;
        //float x = (float) (randomNumber/ 9) + 2;
    
    [cell.slideShow startAnimationWithDuration:2.5];
    [cell addSubview:cell.slideShow.scrollView];
    }
    
   // [cell setBackgroundView:cell.slideShow.scrollView];
    
    [cell.labelTitle setText:event.event_name   ];
    [cell.labelSubtitle setText: event.event_address];
    [cell addSubview: cell.labelTitle];
    [cell addSubview: cell.labelSubtitle];
    
 //   [cell.slideShow setDelegate: self];
    [cell setUserInteractionEnabled:YES];
    return cell;
}


-(void)MGListView:(MGListView *)listView scrollViewDidScroll:(UIScrollView *)scrollView {
}

@end