//
//  WebViewController.m
//  Tonite
//
//  Created by Julie Murakami on 5/4/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
-(void) viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

    NSString* textURL = @"http://www.hashtagtonite.com/faq";
    NSURL * weburl = [NSURL URLWithString:textURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:weburl];
    [_webView loadRequest:request];
  
    
    [self.navigationController setNavigationBarHidden:NO];
    UIBarButtonItem* buttonCancel = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(didClickCancel)];
    [buttonCancel setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:13.0]} forState:UIControlStateNormal];
    [buttonCancel setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:13.0]} forState:UIControlStateSelected];
    [self.navigationItem setLeftBarButtonItem:buttonCancel];
}

-(void) didClickCancel{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView.panGestureRecognizer translationInView:self.view].y < 0){
        [self.navigationController setNavigationBarHidden:YES];
    }
    else if([scrollView.panGestureRecognizer translationInView:self.view].y > 0){
        [self.navigationController setNavigationBarHidden:NO];
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
