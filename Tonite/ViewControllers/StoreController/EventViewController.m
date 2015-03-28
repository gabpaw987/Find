//
//  EventViewController.m
//  Tonite
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "EventViewController.h"
#import "DetailViewController.h"

@interface EventViewController () <MGListViewDelegate>

@end

@implementation EventViewController

@synthesize listViewMain;
@synthesize mainCategory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

    [self beginParsing];
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
    
    listViewMain.arrayData = [NSMutableArray arrayWithArray:
                              [CoreDataController getEventByCategoryId:mainCategory.category_id]];
}

-(void)didClickBarButtonMenu:(id)sender {
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

-(void) MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    vc.event = listViewMain.arrayData[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell != nil) {
        
        Event* event = [listViewMain.arrayData objectAtIndex:indexPath.row];
        Photo* p = [CoreDataController getEventPhotoByEventId:event.event_id];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell.labelDescription setText:event.phone_no];
        
        if(p != nil)
            [self setImage:p.thumb_url imageView:cell.imgViewThumb];
        else
            [self setImage:nil imageView:cell.imgViewThumb];
        
        
        cell.labelHeader1.backgroundColor = [BLACK_TEXT_COLOR colorWithAlphaComponent:0.66];
        
        cell.lblNonSelectorTitle.textColor = THEME_ORANGE_COLOR;
        cell.labelSubtitle.textColor = WHITE_TEXT_COLOR;
        
        cell.lblNonSelectorTitle.text = event.event_name;
        cell.labelSubtitle.text = event.event_address;
        
    }
    
    return cell;
}

-(void)MGListView:(MGListView *)listView scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:LIST_EVENT_PLACEHOLDER];
    
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
}

@end
