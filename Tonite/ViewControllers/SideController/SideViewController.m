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
@property (nonatomic,retain) NSArray* backgroundImages;
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
    [self reloadInputViews];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.navigationController setNavigationBarHidden:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
  // Do any additional setup after loading the view.
  
    tableViewSide.delegate = self;
    tableViewSide.dataSource = self;
    
    self.categories = [CoreDataController getCategoryDisplayInfo: @"category_title"];
    self.backgroundImages = [CoreDataController getCategoryDisplayInfo:@"category_icon"];
  
 
    AppDelegate* delegate = [AppDelegate instance];
    _cellHeight = (delegate.window.frame.size.height-45)/2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return _cellHeight;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [self.categories count];
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    [cell.imgBackground setImage:[UIImage imageNamed:self.backgroundImages[indexPath.row]]];
    [cell.labelTitle setText: self.categories[indexPath.row]];
    return cell;
}



-(void)reloadInputViews     {
    [tableViewSide reloadData];
}


-(void) scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < 10.0){
        [self.tabBarController.navigationController setNavigationBarHidden:NO];
    }
    else{
        [self.tabBarController.navigationController setNavigationBarHidden:YES];
    }
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
    else if([scrollView.panGestureRecognizer translationInView:self.view].y > 0){
        [self.tabBarController.navigationController setNavigationBarHidden:NO];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath* index = [self.tableViewSide indexPathForSelectedRow];
    EventViewController* vc = segue.destinationViewController;
    vc.mainCategoryId= [NSString stringWithFormat:@"%ld", (long)index.row];
    
}


@end
