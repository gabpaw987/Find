//
//  CategoryTableViewController.m
//  Tonite
//
//  Created by Julie Murakami on 5/4/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "LBHamburgerButton.h"
#import "DetailViewController.h"
#import "EventTableViewCell.h"

@interface CategoryTableViewController (){
    float cellHeight;
}

@end

@implementation CategoryTableViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.navigationController setNavigationBarHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];
    
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden: YES];
    [self.tabBarController.navigationController setNavigationBarHidden: YES];
    
}

- (UIBarButtonItem *)backButton
{
    LBHamburgerButton* button = [[LBHamburgerButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                               lineWidth:18
                                                              lineHeight:1
                                                             lineSpacing:3.4
                                                              lineCenter:CGPointMake(10, 0)
                                                                   color:[UIColor grayColor]];
    [button setCenter:CGPointMake(120, 120)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(didClickBarButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}


-(void)didClickBarButtonMenu:(id)sender {
    LBHamburgerButton* btn = (LBHamburgerButton*)sender;
    [btn switchState];
    [btn removeTarget:self action:@selector(didClickBarButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self.tabBarController action:@selector(didClickBarButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.navigationItem setTitleView:[ToniteNavigationBar createLogo:@"TONITELOGO_new.png"]];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.navigationController setNavigationBarHidden:NO];
    cellHeight = (self.view.frame.size.height-50)/2;
    [self.tableView registerNib:[UINib nibWithNibName:@"Eventcell" bundle:nil] forCellReuseIdentifier:@"EventCell"];
    //[self.tableView registerNib:[UINib nibWithNibName:@"SliderCell" bundle:nil] forCellReuseIdentifier:@"EventCell" ];
    
    [self beginParsing];
    
    //Creates the title label on the navigation bar. See ToniteNavigationBar
    [self.tabBarController.navigationItem setTitleView:[ToniteNavigationBar createTitle:[CoreDataController getCategoryByCategoryId:_mainCategoryId].category]];
    
    [self.tabBarController.navigationItem setLeftBarButtonItem: [self backButton]];
    
    UIRefreshControl* refresher = [[UIRefreshControl alloc]init];
    [refresher addTarget: self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [refresher setTintColor:[UIColor whiteColor]];
    [self.tableView addSubview:refresher];
    
}



-(void)beginParsing {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"LOADING");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
    [hud showAnimated:YES whileExecutingBlock:^{
        self.events = [CoreDataController getEventsByCategoryId:_mainCategoryId];
        
        
    } completionBlock:^{
        
        [hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        [self.tableView reloadData];
        
        if(self.events == nil || self.events.count == 0) {
            [self.tableView setUserInteractionEnabled:NO];
            UIColor* color = [[UIColor blackColor] colorWithAlphaComponent:0.70];
            [MGUtilities showStatusNotifier:LOCALIZED(@"NO_RESULTS")
                                  textColor:[UIColor whiteColor]
                             viewController:self
                                   duration:0.5f
                                    bgColor:color
                                        atY:64];
        }
    }];
}


-(void) refresh:(UIRefreshControl*)refresher{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // (...code to get new data here...)
        dispatch_async(dispatch_get_main_queue(), ^{
            //any UI refresh
            [refresher endRefreshing];
        });
    });
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
    return [self.events count];
}



//-(NSString*)formatDateWithStart:(NSString*)dateAndStart withEndTime:(NSString*)endTime{
//    
//    NSDate * myDate = [NSDate dateFromString:dateAndStart withFormat:[NSDate dbFormatString]];
//    NSString* date = [NSDate stringForDisplayFromFutureDate:myDate prefixed:YES alwaysDisplayTime:YES ];
//    return date;
//}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView.panGestureRecognizer translationInView:self.view].y < 0 )
    {
        [self.tabBarController.navigationController setNavigationBarHidden:YES];
    }
    else{
        [self.tabBarController.navigationController setNavigationBarHidden:NO];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      Event* event= [self.events objectAtIndex:indexPath.row];
        DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    vc.eventId = event.event_id;
    [self.navigationController pushViewController:vc animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    Event* event = [self.events objectAtIndex:indexPath.row];
    cell.labelEvent.text = event.event_name;
    // Configure the cell...
    
    return cell;
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
