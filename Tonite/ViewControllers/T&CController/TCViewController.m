//
//  TCViewController.m
//  RealEstateFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "TCViewController.h"
#import "AppDelegate.h"

@interface TCViewController ()<UIScrollViewDelegate>

@end

@implementation TCViewController
@synthesize scrollViewMain;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated    {
    [super viewWillAppear:animated];
    self.navigationItem.titleView = [ToniteNavigationBar createLogo:TONITE_LOGO];
    
    [_termsView removeFromSuperview];
    [scrollViewMain addSubview:_termsView];
    scrollViewMain.contentSize = _termsView.frame.size;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.navigationItem.titleView = [ToniteNavigationBar createLogo:HEADER_LOGO];

    
  
    _termsView = [[MGRawView alloc] initWithFrame:scrollViewMain.frame nibName:@"TCView"];
    

    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
    if(screen) {
        CGRect frame = _termsView.frame;
        frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.height;
        _termsView.frame = frame;
    }
    
    scrollViewMain.frame = self.view.frame;
    
    UIEdgeInsets inset = scrollViewMain.contentInset;
    inset.bottom = NAV_BAR_OFFSET_DEFAULT;
    scrollViewMain.contentInset = inset;
    
    inset = scrollViewMain.scrollIndicatorInsets;
    inset.bottom = NAV_BAR_OFFSET_DEFAULT;
    scrollViewMain.scrollIndicatorInsets = inset;
    UIBarButtonItem* buttonCancel = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(didClickCancel)];
    [buttonCancel setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:13.0]} forState:UIControlStateNormal];
    [buttonCancel setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:13.0]} forState:UIControlStateSelected];
    [self.navigationItem setLeftBarButtonItem:buttonCancel];
    
}

-(void) didClickCancel{
    [self.navigationController popViewControllerAnimated:YES];
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


-(void)scrollViewDidScroll:(UIScrollView *)scrollView   {
    if([scrollView.panGestureRecognizer translationInView:self.view].y < 0)
    {
        [self.navigationController setNavigationBarHidden:YES];
    }
    if([scrollView.panGestureRecognizer translationInView:self.view].y > 0)
    {
        [self.navigationController setNavigationBarHidden:NO];
    }
    if(scrollView.contentOffset.y < 10.0){
        [self.navigationController setNavigationBarHidden: NO];
    }
}

@end
