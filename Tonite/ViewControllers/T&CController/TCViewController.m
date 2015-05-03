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
    // Do any additional setup after loading the view.
    UILabel * tc = [[UILabel alloc ]initWithFrame:self.view.frame];
    [tc setNumberOfLines:0];
    NSError* error;
    [tc setText:[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"toniteTC" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error]];
    if(error){
        NSLog(@"Failed to read file");
    }
    NSLog(@"%@", tc.text);
    [tc sizeToFit];
    [self.view addSubview:tc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
