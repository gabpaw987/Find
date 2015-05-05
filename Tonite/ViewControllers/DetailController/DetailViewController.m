//
//  DetailViewController.m
//  Tonite
//
//
//  Copyright (c) Mangasaur Games. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "ImageViewerController.h"
#import "ZoomAnimationController.h"
#import "QRTicketViewController.h"
#import "NSDate+Helper.h"
#import <MediaPlayer/MediaPlayer.h>

@interface DetailViewController () <MGListViewDelegate, UIViewControllerTransitioningDelegate, MGMapViewDelegate> {
    
    MGHeaderView* _headerView;
    MGFooterView* _footerView;
 
    NSArray* _arrayPhotos;
    NSMutableArray* images;
    float _headerHeight;
    int count;
}

@property (nonatomic, strong) id<MGAnimationController> animationController;
@property (nonatomic, retain) Event* event;
@property (nonatomic, retain) Venue * venue;
@property (nonatomic, retain) MPMoviePlayerController* video;
@end

@implementation DetailViewController

@synthesize tableViewMain;
@synthesize eventId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tabBarController.navigationController setNavigationBarHidden:YES];
//    [self.navigationController setNavigationBarHidden:YES];
    [self.slidingViewController.panGesture setEnabled:NO];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.slidingViewController.panGesture setEnabled:YES];
}


- (void)fadeImage {
    if(count == [images count]-1)
        count = 0;
    else
        count++;
    _headerView.imgBackground.alpha = 0;
    
    [UIView transitionWithView:_headerView.imgBackground duration:2.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
         _headerView.imgBackground.image = images[count];
        _headerView.imgBackground.alpha = 1;
    }completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //Add Back Button
    UIButton* buttonCancel =[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonCancel addTarget:self action:@selector(didClickBackButton) forControlEvents:UIControlEventTouchUpInside];
    NSAttributedString * title = [[NSAttributedString alloc]initWithString:@"Back" attributes: @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:14.0], NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [buttonCancel setAttributedTitle:title forState:UIControlStateSelected];
    [buttonCancel setAttributedTitle:title forState:UIControlStateNormal];
    buttonCancel.frame =  CGRectMake(8.0, 8.0, 55, 55);
    [self.view addSubview:buttonCancel];
    
    //Fetch for event info
    self.event = [CoreDataController getEventByEventId: eventId];
    _headerView = [[MGHeaderView alloc] initWithNibName:@"HeaderView"];
    [_headerView.labelTitle setText: [_event.event_name stringByDecodingHTMLEntities]];
    
    self.venue = [CoreDataController getVenueByVenueId: self.event.venue_id];
    if(self.venue.venue_name ==self.event.event_name){
        [_headerView.labelSubtitle setText: [_event.event_address1 stringByDecodingHTMLEntities]];
    }
    else{
        [_headerView.labelSubtitle setText:[_venue.venue_name stringByDecodingHTMLEntities]];
    }
    NSString* date = [self formatDateWithStart:_event.event_date_starttime withEndTime:_event.event_endtime];
    [_headerView.labelDetails setText: date];
    _headerHeight = _headerView.frame.size.height;
    
    TicketType* ticket = [CoreDataController getTicketTypeByEventId:_event.event_id];
    [_headerView.labelPrice setText:[NSString stringWithFormat:@"$%@",ticket.ticket_price]];
    
    
    //Setup images and Video
    _arrayPhotos = [CoreDataController getEventPhotosByEventId:self.event.event_id];
    [_headerView.imgBackground setBackgroundColor:[UIColor blackColor]];
    [_headerView.imgBackground setClipsToBounds:YES];
    [_headerView.imgBackground setContentMode:UIViewContentModeScaleAspectFill];
    Photo* p = _arrayPhotos == nil || _arrayPhotos.count == 0 ? nil : _arrayPhotos[0];
    if(p){
        images = [[NSMutableArray alloc]init];
        for(int x = 0; x <[_arrayPhotos count]; x++) {
            p = _arrayPhotos[x];
            [images addObject: [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:p.photo_url]]]];
        }
       // _headerView.imgBackground.image = [UIImage animatedImageWithImages:images duration:3.0];
        count = 0;
        [_headerView.imgBackground setImage:images[0]];
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(fadeImage) userInfo:nil repeats:YES];
        
        //[_headerView.imgBackground setAnimationImages:images];
       // [_headerView.imgBackground setAnimationDuration: 5.0];
       // [_headerView.imgBackground startAnimating];
    }
   
    [_headerView.buttonPhotos addTarget:self action:@selector(didClickButtonPhotos:) forControlEvents:UIControlEventTouchUpInside   ];
    
    
    //*  Static "BUY" Button *//
   // [self.view setBackgroundColor:[UIColor whiteColor]];
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
    
    
    //*** Twitter and Facebook buttons in Footer//
    _footerView = [[MGFooterView alloc] initWithNibName:@"FooterView"];
    [_footerView.buttonFacebook addTarget:self
                                   action:@selector(didClickButtonFacebook:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [_footerView.buttonTwitter addTarget:self
                                  action:@selector(didClickButtonTwitter:)
                        forControlEvents:UIControlEventTouchUpInside];
   
    tableViewMain.delegate = self;
    [tableViewMain registerNibName:@"DetailCell" cellIndentifier:@"DetailCell"];
    [tableViewMain baseInit];
 
    tableViewMain.tableView.tableHeaderView = _headerView;
    tableViewMain.tableView.tableFooterView = _footerView;
    tableViewMain.noOfItems = 1;
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void) didClickBuyButton{
    //*********** GO TO Tickets ******************//

    QRTicketViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardQRTicket"];
    
 //   DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardQRTicket"];
    //vc.event = listViewMain.arrayData[indexPath.row];
    
    vc.event = self.event;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void) didClickBackButton{
    [self.navigationController popViewControllerAnimated:YES];
}

//To ImageViewController to view event images//
-(void)didClickButtonPhotos:(id)sender {
    if(_arrayPhotos == nil || _arrayPhotos.count == 0)
        return;
    ImageViewerController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"segueImageViewer"];
    vc.imageArray = _arrayPhotos;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void) MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell == nil) {
        return cell;
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        cell.labelDescription.numberOfLines  = 0;
        [cell.labelDescription setText:[_event.event_desc stringByDecodingHTMLEntities]];
        [cell.labelDescription sizeToFit];
    NSLog(@" description height is . %f", cell.labelDescription.frame.size.height);
    
    
        CGRect mapFrame = cell.mapViewCell.frame;
        mapFrame.origin.y = cell.labelDescription.frame.origin.y + cell.labelDescription.frame.size.height+ 10;
        mapFrame.size.height = 150;
    
    NSLog(@" map starts at .  %f" , mapFrame.origin.y);
        [cell.mapViewCell setFrame: mapFrame];
      
        //Dividing Border of MapView
        UIImageView* upperBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NAV_BAR_BG]];
        [upperBorder setFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 5)];
        [cell.mapViewCell addSubview: upperBorder];
    
        UIImageView* bottomFrame = [[UIImageView alloc]initWithImage:[UIImage imageNamed:NAV_BAR_BG]];
        [bottomFrame setFrame: CGRectMake(0.0, cell.mapViewCell.frame.size.height, self.view.frame.size.width, 5)];
        [cell.mapViewCell addSubview: bottomFrame];

    
        cell.mapViewCell.delegate = self;
        [cell.mapViewCell baseInit];
        cell.mapViewCell.mapView.zoomEnabled = NO;
        cell.mapViewCell.mapView.scrollEnabled = NO;
    
        [cell.routeButton addTarget:self
                         action:@selector(didClickButtonRoute:)
               forControlEvents:UIControlEventTouchUpInside];

    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([_event.lat doubleValue], [_event.lon doubleValue]);
    
    if(CLLocationCoordinate2DIsValid(coords)) {
        
        MGMapAnnotation* ann = [[MGMapAnnotation alloc] initWithCoordinate:coords
                                                                      name:_venue.venue_name                                                                   description:_event.event_address1];
        ann.object = _event;
        
        [cell.mapViewCell setMapData:[NSMutableArray arrayWithObjects:ann, nil] ];
        [cell.mapViewCell setSelectedAnnotation:coords];
        [cell.mapViewCell moveCenterByOffset:CGPointMake(0, -40) from:coords];
    }

    CGRect venueFrame = cell.labelVenue.frame;
    venueFrame.origin.y = mapFrame.origin.y + 160;
    NSLog(@"label for venue starts at  %f", venueFrame.origin.y);
    [cell.labelVenue setFrame: venueFrame];
    cell.labelVenueDescription.numberOfLines = 0;
        if(_venue){
            [cell.labelVenue setText:[_venue.venue_name stringByDecodingHTMLEntities ]];
            [cell.labelVenueDescription setText:_venue.venue_desc ];
        }
        else{
            [cell.labelVenue setText:[_event.event_address1 stringByDecodingHTMLEntities ]];
            [cell.labelVenueDescription setText: @"Description about the Venue" ];
        }
        [cell.labelVenueDescription setTextAlignment:NSTextAlignmentJustified];
        [cell.labelVenueDescription sizeToFit];
        [cell.labelVenueDescription setClipsToBounds:YES];
        CGRect descripFrame = cell.labelVenueDescription.frame;
        descripFrame.origin.y = venueFrame.origin.y + 40;
        NSLog( @" description of venue starts at %f, and ends at %f",descripFrame.origin.y , descripFrame.origin.y + descripFrame.size.height);
        [cell.labelVenueDescription setFrame: descripFrame];
        float height = cell.labelVenueDescription.frame.size.height + cell.labelVenueDescription.frame.origin.y;
        CGRect frame = cell.frame;
        frame.size.height = height;
        [cell setFrame: frame];
        return cell;
}



-(CGFloat)MGListView:(MGListView *)listView cell:(MGListCell *)cell heightForRowAtIndexPath:(NSIndexPath *)indexPath    {

    
    [cell.labelDescription setText:[_event.event_desc stringByDecodingHTMLEntities]];
    CGSize size = [cell.labelDescription sizeOfMultiLineLabel];
    CGRect frame = cell.labelDescription.frame;
    [cell.labelVenueDescription setText: [_venue.venue_desc stringByDecodingHTMLEntities]];
    CGSize vsize = [cell.labelVenueDescription sizeOfMultiLineLabel];
    
    float totalHeightLabel = size.height + frame.origin.y + vsize.height+ 200;
    
    if(totalHeightLabel > cell.frame.size.height) {
        return totalHeightLabel;
    }
    else{
        return totalHeightLabel;
    }
}

-(NSString*)formatDateWithStart:(NSString*)dateAndStart withEndTime:(NSString*)endTime{
    
    NSDate * myDate = [NSDate dateFromString:dateAndStart withFormat:[NSDate dbFormatString]];
    NSString* date = [NSDate stringForDisplayFromFutureDate:myDate prefixed:YES alwaysDisplayTime:YES ];
    return date;
}

//Resizes images while scrolling
-(void)MGListView:(MGListView *)_listView scrollViewDidScroll:(UIScrollView *)scrollView {

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

#pragma mark - UIViewControllerTransitioningDelegate
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
//                                                                  presentingController:(UIViewController *)presenting
//                                                                      sourceController:(UIViewController *)source
//{
//    self.animationController.isPresenting = YES;
//    
//    return self.animationController;
//}
//
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    self.animationController.isPresenting = NO;
//    
//    return self.animationController;
//}

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


@end
