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

@interface SideViewController ()

@property (nonatomic, retain) NSArray* categories;
@property (nonatomic,retain) NSArray* backgroundImages;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableViewSide.delegate = self;
    tableViewSide.dataSource = self;

    
    self.categories =
    @[
        @"UCLA",
        @"NIGHTLIFE",
        @"SPORTS",
        @"FOOD",
        @"CULTURE",
        @"MOVIES & FILM",
        @"THE 411",
        @"theGiveBack"
      ];
    
    self.backgroundImages =
    @[
      @"ucla2.jpg",
      @"nightlife.png",
      @"sports.png",
      @"dine.png",
      @"artsCulture.png",
      @"elReyTheatre.png",
      @"the411.png",
      @"thegiveback.png"];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    
    [self.slidingViewController.view addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeGesture.cancelsTouchesInView = YES; //So the user can still interact with controls in the modal view
    
    [self.slidingViewController.view addGestureRecognizer:swipeGesture];
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
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIView* view = sender.view;
        CGPoint loc = [sender locationInView:view];
        UIView* subview = [view hitTest:loc withEvent:nil];
        //NSLog(NSStringFromClass([subview class]));

        if (![NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellContentView"] &&
            [subview class] != [UIView class] &&
            [subview class] != [UINavigationItem class] &&
             subview != self.view) {
            [self.slidingViewController resetTopViewAnimated:YES];
        }
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return (tableViewSide.frame.size.height-65)/3;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [self.categories count];
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGListCell* cell =  [tableView dequeueReusableCellWithIdentifier:@"EntryCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.selectedColor = WHITE_TEXT_COLOR;
    cell.unSelectedColor = WHITE_TEXT_COLOR;
    
    cell.unselectedImage = [UIImage imageNamed:self.backgroundImages[indexPath.row]];
    cell.selectedImage = [UIImage imageNamed:SIDE_BAR_CELL_NORMAL];
    
    
    NSString* title = self.categories[indexPath.row];
    [cell.labelTitle setText:title];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);

    

    if(indexPath.row < 8){
       
        [self.tabBarController setSelectedIndex:2];
        
    }
}


-(void)reloadInputViews     {

    [tableViewSide reloadData];
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
