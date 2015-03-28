//
//  MyEventsTableViewController.m
//  StoreFinder
//
//  Created by Julie Murakami on 3/8/15.
//  Copyright (c) 2015 Client. All rights reserved.
//
/*
#import "MyEventsTableViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"


@interface MyEventsTableViewController ()

@property (strong, nonatomic) NSArray* arrayData;

@end

@implementation MyEventsTableViewController
@synthesize slideShow;

//@synthesize listMainView;

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
    
 //   [listMainView registerNib:[UINib nibWithNibName:@"SliderCell" bundle:nil] forCellReuseIdentifier:@"SliderCell"];

    
    
    UIBarButtonItem* itemMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_MENU]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(didClickBarButtonMenu:)];
    self.navigationItem.leftBarButtonItem = itemMenu;
    
    [self beginParsing];
    Store* event = _arrayData[3];
    NSArray* arr = [CoreDataController getStorePhotosByStoreId:event.store_id];
    slideShow.imageArray= arr;
    slideShow.numberOfItems = [arr count];
    [slideShow startAnimationWithDuration:3.0f];
    [slideShow setScrollView];

    
}

-(void)didClickBarButtonMenu:(id)sender {
    
    AppDelegate* delegate = [AppDelegate instance];
    [delegate.sideViewController updateUI];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

-(void)beginParsing {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDM (@"LOADING");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
    [hud showAnimated:YES whileExecutingBlock:^{
        
        [self performParsing];
        
    } completionBlock:^{
        
    [hud removeFromSuperview];
    [self.view setUserInteractionEnabled:YES];
   // [listMainView reloadData];
        
    if(_arrayData == nil || _arrayData.count == 0) {
            
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
    
    _arrayData = [NSMutableArray arrayWithArray:[CoreDataController getFeaturedStores]];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
    return screen ? 250:280;

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_arrayData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SliderViewCell *cell = [listMainView dequeueReusableCellWithIdentifier:@"SliderCell" forIndexPath:indexPath];
    if(cell){
    cell.scrollView.delegate = self;
    Store* event = _arrayData[indexPath.row];
    
    cell.imageArray = [CoreDataController getStorePhotosByStoreId:event.store_id];
        cell.numberOfItems = [cell.imageArray count];
   // [cell startAnimationWithDuration:3.0f];
    
    }
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
*/
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

//@end
