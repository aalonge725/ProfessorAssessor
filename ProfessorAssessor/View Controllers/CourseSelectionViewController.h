#import <UIKit/UIKit.h>
#import "Professor.h"
#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CourseSelectionViewControllerDelegate

- (void)didSelectCourse:(Course *)course;

@end

@interface CourseSelectionViewController : UIViewController

@property (nonatomic, weak) id<CourseSelectionViewControllerDelegate> delegate;
@property (nonatomic, strong) Professor *professor;

@end

NS_ASSUME_NONNULL_END
