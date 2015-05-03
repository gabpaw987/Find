//
//  AboutMeTableViewController.m
//  Tonite
//
//  Created by Julie Murakami on 4/19/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "AboutMeTableViewController.h"

@interface AboutMeTableViewController ()<UIScrollViewDelegate>
@property (nonatomic,assign) BOOL isFemale;

@end

@implementation AboutMeTableViewController
@synthesize  genderMale;
@synthesize  genderFemale;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFemale = NO;
    // Uncomment the following line to preserve selection between presentations.

    //    // self.clearsSelectionOnViewWillAppear = NO;
    [self.navigationController setNavigationBarHidden:NO];
    UIBarButtonItem* buttonCancel = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(didClickCancel)];
    [buttonCancel setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:13.0]} forState:UIControlStateNormal];
    [buttonCancel setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:13.0]} forState:UIControlStateSelected];
    [self.navigationItem setLeftBarButtonItem:buttonCancel];
    
    UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(didSelectSave:)];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:13.0]} forState:UIControlStateNormal];
    [right setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:13.0]} forState:UIControlStateSelected];
    [self.navigationItem setRightBarButtonItem:right];
    [self.genderFemale setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateSelected];
    [self.genderFemale setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
    [self.genderMale setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateSelected];
    [self.genderMale setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
    
}

-(void) didClickCancel{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.labelFirstName){
        [ self.labelFirstName resignFirstResponder];
        [self.labelLastName becomeFirstResponder];
    }
    else if(textField == self.labelLastName){
        [ self.labelLastName resignFirstResponder];
        [self.labelEmail becomeFirstResponder];
    }
    else if(textField == self.labelEmail){
        [self.labelEmail resignFirstResponder];
        [self.labelPassword becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    return YES;
}

-(void) didSelectSave:(UIBarButtonItem*) sender{
    NSLog(@"%@", self.labelFirstName.text);
    
    
}




-(void) viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];

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

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView.panGestureRecognizer translationInView:self.view].y < 0)
    {
        [self.navigationController setNavigationBarHidden:YES];
    }
    else if([scrollView.panGestureRecognizer translationInView:self.view].y > 0)
    {
        [self.navigationController setNavigationBarHidden:NO];
    }    
}



- (IBAction)selectGender:(UIButton *)sender {
    if(sender.tag == 0){
        [self.genderMale setSelected:YES];
        [self.genderFemale setSelected:NO];
        self.isFemale = NO;
    }
    else{
        [self.genderFemale setSelected: YES];
        [self.genderMale setSelected:NO];
        self.isFemale = YES;
    }
    
}
@end
