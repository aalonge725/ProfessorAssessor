@import HCSStarRatingView;
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *professor;
@property (strong, nonatomic) IBOutlet UIButton *course;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *rating;
@property (strong, nonatomic) IBOutlet UITextField *ratingField;
@property (strong, nonatomic) IBOutlet UITextView *content;

@end

NS_ASSUME_NONNULL_END
