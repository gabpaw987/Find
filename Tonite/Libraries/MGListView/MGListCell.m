

#import "MGListCell.h"

@implementation MGListCell

@synthesize labelTitle;     //Event name
@synthesize labelSubtitle;  //Venue name
@synthesize labelDetails;   //Date and time
@synthesize imgView;        //Event pics
@synthesize labelExtraInfo; //Price
@synthesize fade;           //Fade on top
@synthesize divider;        //Translucent Between cells
@synthesize locationIcon;   


@synthesize mapViewCell;
@synthesize labelVenueDescription;
@synthesize labelDescription;   //Event Description

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
    [super setSelected:selected animated:animated];
    
    if(selected) {
        [ self.imgView setAlpha:0.7];
    }
    else {
        [self.imgView setAlpha:1.0];
    }
}



- (IBAction)routeButton:(UIButton *)sender {
}
@end
