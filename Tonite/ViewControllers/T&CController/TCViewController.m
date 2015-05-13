//
//  TCViewController.m
//  Tonite
//
//  Created by Julie Murakami on 5/2/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "TCViewController.h"

@interface TCViewController ()

@end

@implementation TCViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIBarButtonItem* buttonCancel = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(didClickCancel)];
    [buttonCancel setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:13.0]} forState:UIControlStateNormal];
    [buttonCancel setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:13.0]} forState:UIControlStateSelected];
    [self.navigationItem setLeftBarButtonItem:buttonCancel];
    

    // Do any additional setup after loading the view.
    UILabel * tc = [[UILabel alloc ]initWithFrame:CGRectMake(3.0, 2.0, self.view.frame.size.width-6, self.view.frame.size.height)];
    //[tc setFont:[UIFont fontWithName:@"Avenir Light" size:11.0]];
    //tc.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    NSError* error;
    [tc setText:[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"toniteTC" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error]];

    if(error){
        NSLog(@"Failed to read file");
    }

    [tc setLineBreakMode:NSLineBreakByWordWrapping];
    [tc setNumberOfLines:0];
    
    
    NSLog(@"%@", tc.text);
    [tc setTextColor:[UIColor blackColor]];
    
    [tc sizeToFit];
    [self.scrollView setContentSize: tc.frame.size];
    [self.scrollView addSubview:tc];
    [self.scrollView setScrollEnabled:YES];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) didClickCancel{
    [self.navigationController popViewControllerAnimated:YES];
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
