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

-(void) viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    [self reloadInputViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    // Do any additional setup after loading the view.
    [self.tabBar setHidden:YES];

    [self setSelectedIndex:0];
    [self.navigationItem setTitleView:[ToniteNavigationBar createLogo:@"TONITELOGO_new.png"]];
    
    // Do any additional setup after loading the view.
    LBHamburgerButton* itemMenu = [[LBHamburgerButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                   
                                                lineWidth:18
                                                                lineHeight:1
                                                               lineSpacing:3.4
                                                                lineCenter:CGPointMake(10, 0)
                                                                     color:[UIColor grayColor]];
    [itemMenu setCenter:CGPointMake(120, 120)];
    [itemMenu setBackgroundColor:[UIColor clearColor]];
    [itemMenu addTarget:self action:@selector(didClickBarButtonMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBtn=[[UIBarButtonItem alloc] initWithCustomView:itemMenu];
    self.navigationItem.leftBarButtonItem = customBtn;
    
    UIBarButtonItem* itemLoginMenu = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed: ICON_USER]style:UIBarButtonItemStylePlain target:self action:@selector(didClickProfileMenuButton)];
    [itemLoginMenu setTintColor:[UIColor grayColor]];
   
    itemLoginMenu.imageInsets = UIEdgeInsetsMake(22, 44, 23, 3); //top, left, bottom, right
    self.navigationItem.rightBarButtonItem = itemLoginMenu;
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) didClickBarButtonMenu:(id) sender{
  
    LBHamburgerButton* btn = (LBHamburgerButton*)sender;
        [btn switchState];
    if(self.selectedIndex ==1){

       [self setSelectedIndex:0];
    }
    else{

        [self setSelectedIndex:1];
}
}

-(void) didClickProfileMenuButton{
    
    if(self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredLeft){
        [self.slidingViewController resetTopViewAnimated:YES];
    }
    else{
    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
    }
}

-(void) reloadInputViews  {

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
