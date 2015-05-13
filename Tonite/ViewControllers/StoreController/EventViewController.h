

#import <UIKit/UIKit.h>

@interface EventViewController : UIViewController <MGListViewDelegate>


@property (retain, nonatomic) IBOutlet MGListView *listViewMain;

@property (nonatomic,retain) NSString* mainCategoryId;

@end
