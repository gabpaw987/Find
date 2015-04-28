//
//  AboutMeTableViewController.h
//  Tonite
//
//  Created by Julie Murakami on 4/19/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutMeTableViewController : UITableViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *labelFirstName;
@property (strong, nonatomic) IBOutlet UITextField *labelLastName;
@property (strong, nonatomic) IBOutlet UITextField *labelEmail;
@property (strong, nonatomic) IBOutlet UIImageView *labelPassword;
@property (strong, nonatomic) IBOutlet UITextField *initialPP;
@property (strong, nonatomic) IBOutlet UITextField *initialTC;
@property (strong, nonatomic) IBOutlet UIButton *genderMale;
@property (strong, nonatomic) IBOutlet UIButton *genderFemale;
- (IBAction)selectGender:(UIButton *)sender;


@end
