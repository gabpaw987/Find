//
//  MyEventsController.m
//  StoreFinder
//
//  Created by Julie Murakami on 2/19/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "MyEventsController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

@interface MyEventsController() <MGListViewDelegate, MGSliderDelegate>


@end

@implementation MyEventsController

@synthesize listViewMain;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
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
    
    listViewMain.delegate = self;
    
    
    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
    listViewMain.cellHeight = screen ? 300 : 250;
    
    [listViewMain registerNibName:@"SliderCell" cellIndentifier:@"SliderCell"];
    [listViewMain baseInit];
    
    
    UIBarButtonItem* itemMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_MENU]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(didClickBarButtonMenu:)];
    self.navigationItem.leftBarButtonItem = itemMenu;
        
    [self beginParsing];
}

-(void)didClickBarButtonMenu:(id)sender {
    
    AppDelegate* delegate = [AppDelegate instance];
    [delegate.sideViewController updateUI];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

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
        [listViewMain reloadData];
        
        if(listViewMain.arrayData == nil || listViewMain.arrayData.count == 0) {
            
            UIColor* color = [THEME_ORANGE_COLOR colorWithAlphaComponent:0.70];
            [MGUtilities showStatusNotifier:LOCALIZED(@"NO_RESULTS")
                                  textColor:[UIColor whiteColor]
                             viewController:self
                                   duration:0.5f
                                    bgColor:color
                                        atY:64];
        }
    }];
    
}

-(void) performParsing {
    
    listViewMain.arrayData = [NSMutableArray arrayWithArray:[CoreDataController getFeaturedStores]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    [cell.imgViewThumb stopAnimating];
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    vc.store = listViewMain.arrayData[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell != nil) {
        Store* store = [listViewMain.arrayData objectAtIndex:indexPath.row];
        NSArray* arrayPhotos = [CoreDataController getStorePhotosByStoreId:store.store_id];
        if([arrayPhotos count]){
        cell.slideShow.delegate = self;
        cell.slideShow.numberOfItems = [arrayPhotos count];
        cell.slideShow.nibName = @"SliderView";
        [cell.slideShow setNeedsReLayoutWithViewSize:CGSizeMake(cell.frame.size.width, cell.frame.size.height)];
        [cell.slideShow startAnimationWithDuration:3.0f];
        cell.slideShow.imageArray = arrayPhotos;
            [cell.imgViewThumb bringSubviewToFront:cell.slideShow];
        }
        
      /*  Favorite* fave = [CoreDataController getFavoriteByStoreId:store.store_id];
        
        cell.imgViewFave.hidden = NO;
        
        if(fave == nil)
            cell.imgViewFave.hidden = YES;
     
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell.labelDescription setText:store.phone_no];
        NSInteger numOfEventPhotos = arrayPhotos.count;
        if(numOfEventPhotos == 0 ||
           arrayPhotos == nil){
            [self setImage:nil imageView:cell.imgViewThumb];
        }
        else{
            Photo* p = arrayPhotos[0];
            [self setImage:p.photo_url imageView:cell.imgViewThumb];
     
        }
        
        cell.labelHeader1.backgroundColor = [BLACK_TEXT_COLOR colorWithAlphaComponent:0.66];
        
        cell.lblNonSelectorTitle.textColor = THEME_ORANGE_COLOR;
        cell.labelSubtitle.textColor = WHITE_TEXT_COLOR;
        
        cell.lblNonSelectorTitle.text = store.store_name;
        cell.labelSubtitle.text = store.store_address;
        
        cell.ratingView.notSelectedImage = [UIImage imageNamed:STAR_EMPTY];
        cell.ratingView.halfSelectedImage = [UIImage imageNamed:STAR_HALF];
        cell.ratingView.fullSelectedImage = [UIImage imageNamed:STAR_FILL];
        cell.ratingView.editable = YES;
        cell.ratingView.maxRating = 5;
        cell.ratingView.midMargin = 0;
        cell.ratingView.userInteractionEnabled = NO;
        
        double rating = [store.rating_total doubleValue]/[store.rating_count doubleValue];
        cell.ratingView.rating = rating;
        
        NSString* info = [NSString stringWithFormat:@"%.2f %@ %@ %@", rating, LOCALIZED(@"RATING_AVERAGE"), store.rating_count, LOCALIZED(@"RATING")];
        
        if([store.rating_total doubleValue] == 0 || [store.rating_count doubleValue] == 0 )
            info = LOCALIZED(@"NO_RATING");
        
        cell.labelExtraInfo.text = info;
       */
    }
    
    return cell;
}


-(void)MGSlider:(MGSlider *)slider didCreateSliderView:(MGRawView *)rawView atIndex:(int)index {
    
    Photo*p = slider.imageArray[index];
    // Photo* p = [CoreDataController getStorePhotoByStoreId:store.store_id];
    
    /*   rawView.label1.backgroundColor = [BLACK_TEXT_COLOR colorWithAlphaComponent:0.66];
     
     rawView.labelTitle.textColor = WHITE_TEXT_COLOR;
     rawView.labelSubtitle.textColor = WHITE_TEXT_COLOR;
     
     //    rawView.labelTitle.text = store.store_name;
     //    rawView.labelSubtitle.text = store.store_address;
     */
    if(p != nil)
        [self setImage:p.photo_url imageView:rawView.imgViewPhoto];
    
    //   rawView.buttonGo.object = store;
    [rawView.buttonGo addTarget:self
                         action:@selector(didClickButtonGo:)
               forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)didClickButtonGo:(id)sender {
    
    MGButton* button = (MGButton*)sender;
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    vc.store = button.object;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)MGListView:(MGListView *)listView scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

-(UIImageView*)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:LIST_STORE_PLACEHOLDER];
    
    [MGUtilities createBorders:weakImgRef
                   borderColor:THEME_MAIN_COLOR
                   shadowColor:[UIColor clearColor]
                   borderWidth:CELL_BORDER_WIDTH];
    
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
    return imgView;
}



@end

