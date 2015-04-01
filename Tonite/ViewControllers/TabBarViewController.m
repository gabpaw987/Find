//
//  TabBarViewController.m
//  Tonite
//
//  Created by Julie Murakami on 3/30/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "TabBarViewController.h"
#import "LBHamburgerButton.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self.tabBar setHidden:YES];
    
    [self setSelectedIndex:0];

    [self.tabBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    // Do any additional setup after loading the view.
    LBHamburgerButton* itemMenu = [[LBHamburgerButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                                 lineWidth:27
                                                                lineHeight:10/6
                                                               lineSpacing:7
                                                                lineCenter:CGPointMake(10, 0)
                                                                     color:[UIColor blackColor]];
    [itemMenu setCenter:CGPointMake(120, 120)];
    [itemMenu setBackgroundColor:[UIColor clearColor]];
    [itemMenu addTarget:self action:@selector(didClickBarButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBtn=[[UIBarButtonItem alloc] initWithCustomView:itemMenu];
    self.navigationItem.leftBarButtonItem = customBtn;
    
    UIBarButtonItem* itemLoginMenu = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed: ICON_USER]style:UIBarButtonItemStylePlain target:self action:@selector(didClickProfileMenuButton:)];
    [itemLoginMenu setTintColor:[UIColor blackColor]];
    itemLoginMenu.imageInsets = UIEdgeInsetsMake(18, 35, 18, 0);
    self.navigationItem.rightBarButtonItem = itemLoginMenu;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) didClickBarButtonMenu:(id) sender{
  //for now go back to menu screen
    if(self.selectedIndex == 2){
        [self setSelectedIndex:1];
    }
    LBHamburgerButton* btn = (LBHamburgerButton*)sender;
        [btn switchState];
    if(self.selectedIndex == 1){
        [self setSelectedIndex:0];
    }
    else{
        [self setSelectedIndex:1];
    }
}

-(void) didClickProfileMenuButton:(id) sender{
//    [self.delegate showProfileMenu];
}

-(void) reloadInputViews   {
    LBHamburgerButton* btn = (LBHamburgerButton*) [self.navigationItem leftBarButtonItem];
    if(self.selectedIndex == 1){
        [btn setState:LBHamburgerButtonStateHamburger];
    }
    else{
        [btn setState:LBHamburgerButtonStateNotHamburger];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
