

#import <UIKit/UIKit.h>
#import "FadeImageView.h"

@interface MGListCell : UITableViewCell{

}

//Slider Cell
@property (nonatomic, retain) IBOutlet UILabel* labelTitle;
@property (nonatomic, retain) IBOutlet UILabel* labelSubtitle;
@property (nonatomic, retain) IBOutlet UILabel* labelDetails;
@property (nonatomic, retain) IBOutlet UILabel* labelExtraInfo;
@property (strong, nonatomic) IBOutlet UIImageView *fade;
@property (strong, nonatomic) IBOutlet UIImageView *divider;
@property (strong, nonatomic) IBOutlet UIImageView *locationIcon;
@property (strong, nonatomic) IBOutlet FadeImageView *imgView;


//Event Detail Page
@property (nonatomic, retain) IBOutlet UILabel* labelDescription;
@property (nonatomic, retain) IBOutlet UILabel* labelVenue;
@property (nonatomic, retain) IBOutlet UILabel* labelVenueDescription;
@property (nonatomic, retain) IBOutlet MGMapView* mapViewCell;


@property (nonatomic, retain) IBOutlet UIImageView* imgViewThumb;
@property (nonatomic, retain) IBOutlet UILabel* labelInfo;

@property (strong, nonatomic) IBOutlet UIButton *routeButton;

@end
