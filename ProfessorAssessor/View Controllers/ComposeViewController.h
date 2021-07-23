@import HCSStarRatingView;
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *professor;
@property (nonatomic, strong) IBOutlet UIButton *course;
@property (nonatomic, strong) IBOutlet HCSStarRatingView *rating;
@property (nonatomic, strong) IBOutlet UITextField *ratingField;
@property (nonatomic, strong) IBOutlet UITextView *content;

@end

NS_ASSUME_NONNULL_END
