@import HCSStarRatingView;
#import <UIKit/UIKit.h>
#import "Review.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReviewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *courseName;
@property (nonatomic, strong) IBOutlet UILabel *date;
@property (nonatomic, strong) IBOutlet HCSStarRatingView *rating;
@property (nonatomic, strong) IBOutlet UILabel *content;
@property (nonatomic, strong) IBOutlet UIView *background;

- (void)setReview:(Review *)review;
- (void)configureBackground;

@end

NS_ASSUME_NONNULL_END
