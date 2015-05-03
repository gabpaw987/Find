//
//  EventPageViewController.m
//  Tonite
//
//  Created by Julie Murakami on 5/2/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "EventPageViewController.h"
#import "ImageViewerController.h"
#import "ZoomAnimationController.h"
#import "QRTicketViewController.h"
#import "DetailTableViewCell.h"

@interface EventPageViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>{
    MGHeaderView* _headerView;
    MGFooterView* _footerView;
    NSArray* _arrayPhotos;
    float _headerHeight;
}

@property (nonatomic, strong) id<MGAnimationController> animationController;
@property (nonatomic, strong) Event* event;
@property (nonatomic, strong) Venue * venue;
@property (nonatomic, strong) Video * video;

@end

@implementation EventPageViewController
@synthesize eventId;


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.navigationController setNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self.slidingViewController.panGesture setEnabled:NO];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tabBarController.navigationController setNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tableView reloadData];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBarController.navigationController setNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //Add Back Button
    UIButton* buttonCancel =[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonCancel addTarget:self action:@selector(didClickBackButton) forControlEvents:UIControlEventTouchUpInside];
    NSAttributedString * title = [[NSAttributedString alloc]initWithString:@"Back" attributes: @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:14.0], NSForegroundColorAttributeName: [UIColor grayColor]}];
    [buttonCancel setAttributedTitle:title forState:UIControlStateSelected];
    [buttonCancel setAttributedTitle:title forState:UIControlStateNormal];
    buttonCancel.frame =  CGRectMake(8.0, 8.0, 50.0, 50.5);
    [self.view addSubview:buttonCancel];
    
    
    
    
    //Fetch for event info
    _event = [CoreDataController getEventByEventId: self.eventId];
    _headerView = [[MGHeaderView alloc] initWithNibName:@"HeaderView"];
    [_headerView.labelTitle setText: [self.event.event_name stringByDecodingHTMLEntities]];
    
    if(self.event.venue_id == nil){
        [_headerView.labelSubtitle setText: [_event.event_address1 stringByDecodingHTMLEntities]];
    }
    else{
        self.venue = [CoreDataController getVenueByVenueId: self.event.venue_id];
        [_headerView.labelSubtitle setText:[_venue.venue_name stringByDecodingHTMLEntities]];
    }
    _arrayPhotos = [CoreDataController getEventPhotosByEventId:self.event.event_id];
    //_video = [CoreDataController getEventVideoByEventId:eventId];
    //NSURL* url = [NSURL URLWithString:_video.video_url];
    
    //Setup images and Video
    [_headerView.imgBackground setClipsToBounds:YES];
    [_headerView.imgBackground setContentMode:UIViewContentModeScaleAspectFill];
    Photo* p = _arrayPhotos == nil || _arrayPhotos.count == 0 ? nil : _arrayPhotos[0];
    if(p){
        NSMutableArray * images = [[NSMutableArray alloc]init];
        for(int x = 0; x <[_arrayPhotos count]; x++) {
            p = _arrayPhotos[x];
            [images addObject: [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:p.photo_url]]]];
        }
    _headerView.imgBackground.image = [UIImage animatedImageWithImages:images duration:3.0];
    }
    _headerHeight = _headerView.frame.size.height;
    
    _footerView = [[MGFooterView alloc]initWithNibName:@"FooterView"];
    [_footerView.buttonFacebook addTarget:self
                                   action:@selector(didClickButtonFacebook:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [_footerView.buttonTwitter addTarget:self
                                  action:@selector(didClickButtonTwitter:)
                        forControlEvents:UIControlEventTouchUpInside];
    
    
    //* Static Buy Ticket Button *//
    CGFloat buttonheight = self.view.frame.size.height - 50;
    CGRect rect = CGRectMake(0, buttonheight, self.view.frame.size.width, 50);
    UIButton* buyButton = [[UIButton alloc]initWithFrame:rect];
    NSAttributedString * buttonTitle = [[NSAttributedString alloc]initWithString:@"Attend Event" attributes: @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:18.0], NSForegroundColorAttributeName: [UIColor blackColor]}];
    [buyButton setAttributedTitle:buttonTitle forState:UIControlStateNormal];
    [buyButton setAttributedTitle: buttonTitle forState:UIControlStateSelected];
    [buyButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [buyButton.layer setBorderWidth:2.0];
    [buyButton setBackgroundImage:[UIImage imageNamed:NAV_BAR_BG] forState: UIControlStateNormal];
    [buyButton setBackgroundImage:[UIImage imageNamed:NAV_BAR_BG] forState:UIControlStateSelected];
    [buyButton setBackgroundColor:[UIColor grayColor]];
    [buyButton addTarget:self action:@selector(didClickBuyButton) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setAlpha:0.85];
    [self.view addSubview:buyButton];
        
    self.tableView.tableHeaderView  = _headerView;
    self.tableView.tableFooterView = _footerView;
    [self tableView].delaysContentTouches = NO;
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    

}

-(void) didClickBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) didClickBuyButton{
    //*********** GO TO Tickets ******************//
    
    QRTicketViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardQRTicket"];
    
    //   DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardQRTicket"];
    //vc.event = listViewMain.arrayData[indexPath.row];
    
    vc.event = self.event;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yPos = -scrollView.contentOffset.y;
    if (yPos > 0) {
        CGRect imgRect = _headerView.imgBackground.frame;
        imgRect.origin.y = scrollView.contentOffset.y;
        imgRect.size.height = _headerHeight + yPos;
        _headerView.imgBackground.frame = imgRect;
    }
}

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:LIST_EVENT_PLACEHOLDER ];
    
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
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
                            }];
}

- (DetailTableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    //Description of Event
    
   
    cell.eventDescription.numberOfLines = 0;
    [cell.eventDescription setText:[_event.event_desc stringByDecodingHTMLEntities]];
    [cell.eventDescription sizeToFit];
    
    
    
    
    return cell;
}



-(void)didClickButtonFacebook:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *shareSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [shareSheet setInitialText:LOCALIZED(@"FACEBOOK_STATUS_SHARE")];
        [shareSheet addImage:_headerView.imgViewPhoto.image];
        
        [shareSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        if(!(shareSheet == nil))
            [self presentViewController:shareSheet animated:YES completion:nil];
    }
    else {
        [MGUtilities showAlertTitle:LOCALIZED(@"FACEBOOK_AUTHENTICATION_FAILED")
                            message:LOCALIZED(@"FACEBOOK_AUTHENTICATION_FAILED_MSG")];
    }
}

-(void)didClickButtonTwitter:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheet setInitialText:LOCALIZED(@"TWITTER_STATUS_SHARE")];
        [tweetSheet addImage:_headerView.imgViewPhoto.image];
        
        //        [shareSheet addURL:[NSURL URLWithString:_website]];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else {
        [MGUtilities showAlertTitle:LOCALIZED(@"TWITTER_AUTHENTICATION_FAILED")
                            message:LOCALIZED(@"TWITTER_AUTHENTICATION_FAILED_MSG")];
    }
}



#pragma mark - MAP Delegate

-(void) MGMapView:(MGMapView*)mapView didSelectMapAnnotation:(MGMapAnnotation*)mapAnnotation {
    
}
-(void) MGMapView:(MGMapView *)mapView didAccessoryTapped:(MGMapAnnotation *)mapAnnotation    {
    
}

-(void) MGMapView:(MGMapView*)mapView didCreateMKPinAnnotationView:(MKPinAnnotationView*)mKPinAnnotationView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    mKPinAnnotationView.image = [UIImage imageNamed:MAP_PIN];
    mKPinAnnotationView.frame = CGRectMake(0, 0, 20.0, 22.0);
}


-(void)didClickButtonRoute:(id)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_event.lat doubleValue], [_event.lon doubleValue]);
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = _event.event_name;
    
    if ([mapItem respondsToSelector:@selector(openInMapsWithLaunchOptions:)]) {
        [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
    }
    else {
        NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&saddr=Current+Location", coordinate.latitude, coordinate.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
