#import <UIKit/UIKit.h>
#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseSelectionCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;

- (void)setCourse:(Course *)course;

@end

NS_ASSUME_NONNULL_END
