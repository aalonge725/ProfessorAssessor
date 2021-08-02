#import <UIKit/UIKit.h>
#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIView *background;

- (void)setCourse:(Course *)course;
- (void)configureBackground;

@end

NS_ASSUME_NONNULL_END
