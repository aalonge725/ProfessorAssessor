@import HCSStarRatingView;
#import <UIKit/UIKit.h>
#import "Professor.h"
#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *professorName;
@property (nonatomic, strong) IBOutlet UILabel *courseName;
@property (nonatomic, strong) IBOutlet HCSStarRatingView *rating;
@property (nonatomic, strong) IBOutlet UITextField *ratingField;
@property (nonatomic, strong) IBOutlet UITextView *content;
@property (nonatomic, strong) Professor *professor;
@property (nonatomic, strong) Course *course;

@end

NS_ASSUME_NONNULL_END
