//
//  MenuTableViewController.m
//  Tonite
//
//  Created by Julie Murakami on 5/7/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MenuTableViewCell.h"

@interface MenuTableViewController ()
@property (nonatomic, strong) NSArray* arrayData;

@end

@implementation MenuTableViewController

-(void) viewWillAppear:(BOOL)animated   {
    [self.tabBarController.navigationController setNavigationBarHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.categoryTable.frame.size.height/2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    self.arrayData = [CoreDataController getCategories];
    return [self.arrayData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell" forIndexPath:indexPath];
    MainCategory* category = [CoreDataController getCategoryByCategoryId: [NSString stringWithFormat:@"%ld", (long)indexPath.row+1]];
    //UIImageView * image = [[UIImageView alloc]initWithFrame: cell.frame];
    if([category.category_icon hasPrefix:@"http"] || [category.category_icon hasPrefix:@"www"]){
        [cell.imgBackground setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:category.category_icon]]]];
    }
    else
        [cell.imgBackground setImage:[UIImage imageNamed:category.category_icon]];
    [cell.labelTitle setText: category.category];
   // [cell.contentView addSubview:imgB];
    return cell;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    //Create Parallax effect on cell imgBackground
    for(MenuTableViewCell *view in self.categoryTable.visibleCells) {
        CGFloat yOffset = ((self.categoryTable.contentOffset.y - view.frame.origin.y) /300) * 25;
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
