//
//  RightSideViewController.m
//  StoreFinder
//
//  Created by Julie Murakami on 3/2/15.
//  Copyright (c) 2015 Client. All rights reserved.
//

#import "RightSideViewController.h"

@interface RightSideViewController ()

@end

@implementation RightSideViewController

@synthesize userProfilePicture;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UserSession* user = [UserAccessSession getUserSession];
    
    if( user != nil && user.coverPhotoUrl != nil) {
        [self setImage:user.coverPhotoUrl imageView:userProfilePicture withBorder:YES isThumb:YES];
    }

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

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView withBorder:(BOOL)border isThumb:(BOOL)isThumb{
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    
    NSString* thumbPlaceholder = isThumb ? PROFILE_THUMB_PLACEHOLDER_IMAGE : PROFILE_PLACEHOLDER_IMAGE;
    UIImage* imgPlaceholder = [UIImage imageNamed:thumbPlaceholder];
    
    [imgView setImageWithURLRequest:urlRequest
                   placeholderImage:imgPlaceholder
                            success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                
                                CGSize size = weakImgRef.frame.size;
                                
                                if([MGUtilities isRetinaDisplay]) {
                                    size.height *= 2;
                                    size.width *= 2;
                                }
                                
                                UIImage* croppedImage = [image imageByScalingAndCroppingForSize:size];
                                weakImgRef.image = croppedImage;
                                
                                if(border) {
                                    [MGUtilities createBorders:weakImgRef
                                                   borderColor:THEME_MAIN_COLOR
                                                   shadowColor:[UIColor clearColor]
                                                   borderWidth:CELL_BORDER_WIDTH];
                                }
                                
                                
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
                            }];
}

-(void) updateUI{

}
@end
