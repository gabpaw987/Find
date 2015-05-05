//
//  SideViewController.m
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "SideViewController.h"
#import "AppDelegate.h"
#import "EventViewController.h"
#import "MenuTableViewCell.h"

@interface SideViewController ()<UIScrollViewDelegate>

@property (nonatomic, retain) NSArray* categories;
@property (nonatomic) CGFloat cellHeight;
@end

@implementation SideViewController
@synthesize tableViewSide;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void) viewWillAppear:(BOOL)animated {
    [self.tableViewSide reloadData];
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];

    // Do any additional setup after loading the view.
    tableViewSide.delegate = self;
    tableViewSide.dataSource = self;
    tableViewSide.frame = self.view.frame;
    //Set cell size for two per view
    AppDelegate* delegate = [AppDelegate instance];
    _cellHeight = (delegate.window.frame.size.height-45)/2;
  
    
    //Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableViewSide addSubview:refreshControl];
    [refreshControl setTintColor:[UIColor whiteColor]];

}

- (void)refresh:(UIRefreshControl *)refreshControl {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // (...code to get new data here...)
        dispatch_async(dispatch_get_main_queue(), ^{
            //any UI refresh
            [refreshControl endRefreshing];
        });
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return _cellHeight;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.categories = [CoreDataController getCategories];
    return [self.categories count];
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    MainCategory* category = [CoreDataController getCategoryByCategoryId: [NSString stringWithFormat:@"%ld", (long)indexPath.row+1]];
    if([category.category_icon hasPrefix:@"http"] || [category.category_icon hasPrefix:@"www"]){
        [self setImage:category.category_icon imageView:cell.imgBackground];
    }
    else
        [cell.imgBackground setImage:[UIImage imageNamed:category.category_icon]];
    [cell.labelTitle setText: category.category];
    
    return cell;
}




-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
   //Create Parallax effect on cell imgBackground
    for(MenuTableViewCell *view in self.tableViewSide.visibleCells) {
        CGFloat yOffset = ((self.tableViewSide.contentOffset.y - view.frame.origin.y) /300) * 25;
        CGRect frame =view.imgBackground.bounds;
        CGRect offsetFrame = CGRectOffset(frame, 0, yOffset);
        view.imgBackground.frame = offsetFrame;
    }
  
    if([scrollView.panGestureRecognizer translationInView:self.view].y < 0){
        [self.tabBarController.navigationController setNavigationBarHidden:YES];
    }
    else {
        [self.tabBarController.navigationController setNavigationBarHidden:NO];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath* index = [self.tableViewSide indexPathForSelectedRow];
    EventViewController    * vc = segue.destinationViewController;
    vc.mainCategoryId= [NSString stringWithFormat:@"%ld", (long)index.row+ 1];
    
}


-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    //    [imgView setImageWithURL:url placeholderImage:[UIImage imageNamed:LIST_EVENT_PLACEHOLDER]];
    //   imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:LIST_EVENT_PLACEHOLDER];
    
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
                                NSLog(@"Failure to request photo");
                            }];
    
}


@end
