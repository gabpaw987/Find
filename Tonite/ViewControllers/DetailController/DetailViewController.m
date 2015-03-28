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

@interface DetailViewController () <MGListViewDelegate, UIViewControllerTransitioningDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, MGMapViewDelegate> {
    
    MGHeaderView* _headerView;
    MGFooterView* _footerView;
    
    NSArray* _arrayPhotos;
    float _headerHeight;
    BOOL _canRate;
    NSArray* _arrayIcons;
    BOOL _isLoadedView;
}

@property (nonatomic, strong) id<MGAnimationController> animationController;

@end

@implementation DetailViewController

@synthesize tableViewMain;
@synthesize event;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
    self.view.backgroundColor = THEME_BLACK_TINT_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    
    _footerView = [[MGFooterView alloc] initWithNibName:@"FooterView"];
    [_footerView.buttonTwitter setTitle:LOCALIZED(@"SHARE") forState:UIControlStateNormal];
    [_footerView.buttonTwitter setTitle:LOCALIZED(@"SHARE") forState:UIControlStateSelected];
    [_footerView.buttonTwitter setTitleColor:WHITE_TEXT_COLOR forState:UIControlStateNormal];
    [_footerView.buttonTwitter setTitleColor:WHITE_TEXT_COLOR forState:UIControlStateSelected];
    
    
    [_footerView.buttonFacebook setTitle:LOCALIZED(@"SHARE") forState:UIControlStateNormal];
    [_footerView.buttonFacebook setTitle:LOCALIZED(@"SHARE") forState:UIControlStateSelected];
    [_footerView.buttonFacebook setTitleColor:WHITE_TEXT_COLOR forState:UIControlStateNormal];
    [_footerView.buttonFacebook setTitleColor:WHITE_TEXT_COLOR forState:UIControlStateSelected];
    
    [_footerView.buttonFacebook addTarget:self
                                   action:@selector(didClickButtonFacebook:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [_footerView.buttonTwitter addTarget:self
                                  action:@selector(didClickButtonTwitter:)
                        forControlEvents:UIControlEventTouchUpInside];
    
    [_footerView.buttonCall addTarget:self
                                  action:@selector(didClickButtonCall:)
                        forControlEvents:UIControlEventTouchUpInside];
    
    [_footerView.buttonEmail addTarget:self
                                  action:@selector(didClickButtonEmail:)
                        forControlEvents:UIControlEventTouchUpInside];
    
    [_footerView.buttonRoute addTarget:self
                                  action:@selector(didClickButtonRoute:)
                        forControlEvents:UIControlEventTouchUpInside];
    
    
    _footerView.buttonWebsite.enabled = NO;
    if(event.website != nil && event.website.length > 0)
        _footerView.buttonWebsite.enabled = YES;
    
    _footerView.buttonEmail.enabled = NO;
    if(event.email != nil && event.email.length > 0)
        _footerView.buttonEmail.enabled = YES;
    
    _footerView.buttonWebsite.enabled = NO;
    if(event.website != nil && event.website.length > 0)
        _footerView.buttonWebsite.enabled = YES;
    
    _headerView = [[MGHeaderView alloc] initWithNibName:@"HeaderView"];
    
    _headerView.imgViewPhoto.contentMode = UIViewContentModeScaleAspectFill;
    _headerView.imgViewPhoto.clipsToBounds = YES;
    _headerView.label1.backgroundColor = [BLACK_TEXT_COLOR colorWithAlphaComponent:0.66];
    
    _headerView.labelTitle.textColor = THEME_ORANGE_COLOR;
    _headerView.labelSubtitle.textColor = WHITE_TEXT_COLOR;
    
    _headerView.labelTitle.text = [event.event_name stringByDecodingHTMLEntities];
    _headerView.labelSubtitle.text = [event.event_address stringByDecodingHTMLEntities];
    
    _arrayPhotos = [CoreDataController getEventPhotosByEventId:event.event_id];
    
    [_headerView.buttonPhotos addTarget:self
                                 action:@selector(didClickButtonPhotos:)
                       forControlEvents:UIControlEventTouchUpInside];
    
    [_headerView.labelPhotos setText:[NSString stringWithFormat:@"%d", (int)_arrayPhotos.count]];
    
    _headerHeight = _headerView.frame.size.height;
    
    Photo* p = _arrayPhotos == nil || _arrayPhotos.count == 0 ? nil : _arrayPhotos[0];
    
    if(p != nil)
        [self setImage:p.photo_url imageView:_headerView.imgViewPhoto];
    
    
    _arrayIcons = @[ICON_DETAIL_EMAIL, ICON_DETAIL_SMS, ICON_DETAIL_CALL, ICON_DETAIL_WEBSITE];
    
    
    tableViewMain.delegate = self;
    [tableViewMain registerNibName:@"DetailCell" cellIndentifier:@"DetailCell"];
    [tableViewMain baseInit];
    
    tableViewMain.tableView.tableHeaderView = _headerView;
    tableViewMain.tableView.tableFooterView = _footerView;
    tableViewMain.noOfItems = 1;
    tableViewMain.cellHeight = 0;
    [tableViewMain reloadData];
    [tableViewMain tableView].delaysContentTouches = NO;
    
    _isLoadedView = NO;
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

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:DETAIL_IMAGE_PLACEHOLDER];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

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
    
    if(cell != nil) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedColor = WHITE_TEXT_COLOR;
        cell.unSelectedColor = WHITE_TEXT_COLOR;
        cell.labelDescription.textColor = THEME_BLACK_TINT_COLOR;
        cell.backgroundColor = [UIColor clearColor];
        
        if(indexPath.row < _arrayIcons.count)
            [cell.imgViewPic setImage:[UIImage imageNamed:_arrayIcons[indexPath.row]]];
        
        cell.labelDescription.textColor = WHITE_TEXT_COLOR;
        [cell.labelDescription setText:[event.event_desc stringByDecodingHTMLEntities]];
        
        CGSize size = [cell.labelDescription sizeOfMultiLineLabel];
        CGRect frame = cell.labelDescription.frame;
        cell.labelDescription.frame = frame;
        
        float totalHeightLabel = size.height + frame.origin.y + (18);
        
        if(totalHeightLabel > cell.frame.size.height) {
            frame.size = size;
            cell.labelDescription.frame = frame;
            
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = totalHeightLabel + cell.frame.size.height;
            cell.frame = cellFrame;
        }
        else {
            
            frame.size = size;
            cell.labelDescription.frame = frame;
        }
        
        
        cell.mapViewCell.delegate = self;
        [cell.mapViewCell baseInit];
        cell.mapViewCell.mapView.zoomEnabled = NO;
        cell.mapViewCell.mapView.scrollEnabled = NO;
        
        
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([event.lat doubleValue], [event.lon doubleValue]);
        
        if(CLLocationCoordinate2DIsValid(coords)) {
            MGMapAnnotation* ann = [[MGMapAnnotation alloc] initWithCoordinate:coords
                                                                          name:event.event_name
                                                                   description:event.event_address];
            ann.object = event;
            
            [cell.mapViewCell setMapData:[NSMutableArray arrayWithObjects:ann, nil] ];
            [cell.mapViewCell setSelectedAnnotation:coords];
            [cell.mapViewCell moveCenterByOffset:CGPointMake(0, -40) from:coords];
        }
        
    }
    
    return cell;
}

-(void)MGListView:(MGListView *)_listView scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat yPos = -scrollView.contentOffset.y;
    
    if (yPos > 0) {
        CGRect imgRect = _headerView.imgViewPhoto.frame;
        imgRect.origin.y = scrollView.contentOffset.y;
        imgRect.size.height = _headerHeight + yPos;
        _headerView.imgViewPhoto.frame = imgRect;
    }
    
}

-(CGFloat)MGListView:(MGListView *)listView cell:(MGListCell*)cell heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 4) {
        [cell.labelDescription setText:event.event_desc];
        CGSize size = [cell.labelDescription sizeOfMultiLineLabel];
        
        return size.height + (CELL_CONTENT_MARGIN * 2);
    }
    
    [cell.labelDescription setText:[event.event_desc stringByDecodingHTMLEntities]];
    CGSize size = [cell.labelDescription sizeOfMultiLineLabel];
    CGRect frame = cell.labelDescription.frame;
    CGRect cellFrame = cell.frame;
    
    float totalHeightLabel = size.height + frame.origin.y + (18);
    
    if(totalHeightLabel > cell.frame.size.height) {
        frame.size = size;
        cell.labelDescription.frame = frame;
        
        float heightDiff = totalHeightLabel - cell.frame.size.height;
        
        cellFrame.size.height += heightDiff;
        cell.frame = cellFrame;
    }
    
    
    return cell.frame.size.height;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.animationController.isPresenting = YES;
    
    return self.animationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animationController.isPresenting = NO;
    
    return self.animationController;
}

-(void)didClickButtonRoute:(id)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([event.lat doubleValue], [event.lon doubleValue]);
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = event.event_name;
    
    if ([mapItem respondsToSelector:@selector(openInMapsWithLaunchOptions:)]) {
        [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
    }
    else {
        NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&saddr=Current+Location", coordinate.latitude, coordinate.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}


-(void)didClickButtonCall:(id)sender {
    
    if(event.phone_no == nil || [event.phone_no length] == 0 ) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"CONTACT_NO_SERVICE_ERROR")
                            message:LOCALIZED(@"CONTACT_NO_SERVICE_ERROR_MSG")];
        return;
    }
    
    NSString* trim = [MGUtilities removeDelimetersInPhoneNo:event.phone_no];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", trim] ]];
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

-(void)didClickButtonEmail:(id)sender {
    
    if(event.email == nil || [event.email length] == 0 ) {
        [MGUtilities showAlertTitle:LOCALIZED(@"EMAIL_ERROR")
                            message:LOCALIZED(@"EMAIL_ERROR_MSG")];
        return;
    }
    
    if ([MFMailComposeViewController canSendMail]) {
        
        // set the sendTo address
        NSMutableArray *recipients = [[NSMutableArray alloc] initWithCapacity:1];
        [recipients addObject:event.email];
        
        MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        
        [mailController setSubject:LOCALIZED(@"EMAIL_SUBJECT")];
        
        NSString* formattedBody = [NSString stringWithFormat:@"%@", LOCALIZED(@"EMAIL_BODY")];
        
        [mailController setMessageBody:formattedBody isHTML:NO];
        [mailController setToRecipients:recipients];
        
        if(DOES_SUPPORT_IOS7) {
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        WHITE_TEXT_COLOR, NSForegroundColorAttributeName, nil];
            
            [[mailController navigationBar] setTitleTextAttributes:attributes];
            [[mailController navigationBar ] setTintColor:[UIColor whiteColor]];
            
        }
        
        [self.view.window.rootViewController presentViewController:mailController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
    else {
        [MGUtilities showAlertTitle:LOCALIZED(@"EMAIL_SERVICE_ERROR")
                            message:LOCALIZED(@"EMAIL_SERVICE_ERROR_MSG")];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    
	[self becomeFirstResponder];
	[controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller
                didFinishWithResult:(MessageComposeResult)result {
    
    [self becomeFirstResponder];
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - MAP Delegate

-(void) MGMapView:(MGMapView*)mapView didSelectMapAnnotation:(MGMapAnnotation*)mapAnnotation {
    
}

-(void) MGMapView:(MGMapView*)mapView didAccessoryTapped:(MGMapAnnotation*)mapAnnotation {
    
}

-(void) MGMapView:(MGMapView*)mapView didCreateMKPinAnnotationView:(MKPinAnnotationView*)mKPinAnnotationView viewForAnnotation:(id<MKAnnotation>)annotation {
    
//    UIImageView *imageView = [[UIImageView alloc] init];
//    UIImage* imageAnnotation = [UIImage imageNamed:MAP_ARROW_RIGHT];
//    [imageView setImage:imageAnnotation];
    
    mKPinAnnotationView.image = [UIImage imageNamed:MAP_PIN];
    
//    imageView.frame = CGRectMake (0, 0, imageAnnotation.size.width, imageAnnotation.size.height);
//    mKPinAnnotationView.rightCalloutAccessoryView = imageView;
    
    
}


@end
