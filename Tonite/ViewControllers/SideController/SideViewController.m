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
    [self.tabBarController.navigationController setNavigationBarHidden:NO];

}

-(void) viewWillDisappear:(BOOL)animated{
    [self.slidingViewController resetTopViewAnimated:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
  // Do any additional setup after loading the view.
    tableViewSide.delegate = self;
    tableViewSide.dataSource = self;
    
    self.categories = [CoreDataController getCategoryDisplayInfo: @"category_title"];
    self.backgroundImages = [CoreDataController getCategoryDisplayInfo:@"category_icon"];
  
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeGesture.cancelsTouchesInView = YES; //So the user can still interact with controls in the modal view
    
    [self.view addGestureRecognizer:swipeGesture];
    
    AppDelegate* delegate = [AppDelegate instance];
    _cellHeight = (delegate.window.frame.size.height-65)/2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
//        [self.tabBarController reloadInputViews];
//        [self.tabBarController setSelectedIndex:0];
    }
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
//    if(cell == nil){
//        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
//    }
    [cell.imgBackground setImage:[UIImage imageNamed:self.backgroundImages[indexPath.row]]];
    [cell.labelTitle setText: self.categories[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    //self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
  
    if(indexPath.row < 8){
         EventViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardEvent"];
        vc.mainCategoryId= [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        [self.tabBarController.navigationController pushViewController:vc animated:YES];
    }
}


-(void)reloadInputViews     {
    [tableViewSide reloadData];
}


-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView  {
    if([scrollView.panGestureRecognizer translationInView:self.view].y < 0){
        [self.tabBarController.navigationController setNavigationBarHidden:YES];
    }
    else if([scrollView.panGestureRecognizer translationInView:self.view].y > 0){
        [self.tabBarController.navigationController setNavigationBarHidden:NO];
    }
}


-(void) scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y == 0.0){
        [self.tabBarController.navigationController setNavigationBarHidden:NO];
    }
    else{
        [self.tabBarController.navigationController setNavigationBarHidden:YES];
    }
}





-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
//  NSArray* cells = self.tableViewSide.visibleCells;
//    CGFloat scale;
//    for( int i = 0; i <2; i++){
//       
//        MenuTableViewCell* view = cells[i];
//        
//        CGFloat offset = (float)((int)self.tableViewSide.contentOffset.y %(int) self.view.frame.size.height);
//        scale = 1+(offset/self.view.frame.size.height);
//       // scale = 1+(1-scale);
////        if(offset == 0){
////            scale = view.scale;
////        }
//       // scale = (offset) /300;
//        
////        if(offset < view.frame.size.height){
////            scale = view.scale;
////        }
//        
////        if(i ==([cells count]-1) ){
////            CGFloat num = (self.tableViewSide.contentOffset.y- view.frame.origin.y);
//            NSLog(@"offset .... %f", offset);
////
////            scale = view.scale;
////        }
//        //self.tableViewSide.frame.size.height)+.5;
//        
//                           //- view.frame.origin.y)/300;
//      
//        //NSLog(@" scale by ......%f", scale );
//          if(scale < 1 ){
//                NSLog(@"reached limit");
//            continue;
//            }
//                   if([scrollView.panGestureRecognizer translationInView:self.view].y > 0 ){ //scrolled UP
//        
//            
//            CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
//            view.imgBackground.transform = transform;
//            
//        }
//        else{
//            if(i == 0){
//                scale = view.scale;
//            }
//           CGAffineTransform transform = CGAffineTransformMakeScale( scale, scale);
//            view.imgBackground.transform = transform;
//        }
//        [view setScale: scale];
//     
//    }

    for(MenuTableViewCell *view in self.tableViewSide.visibleCells) {
        CGFloat yOffset = ((self.tableViewSide.contentOffset.y - view.frame.origin.y) /300) * 25;
        CGRect frame =view.imgBackground.bounds;
        CGRect offsetFrame = CGRectOffset(frame, 0, yOffset);
        view.imgBackground.frame = offsetFrame;
        }
    
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

@end
