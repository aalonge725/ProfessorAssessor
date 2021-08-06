#import <UIKit/UIKit.h>
#import "School.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SchoolSelectionViewControllerDelegate

- (void)didSelectSchool:(School *)school;

@end

@interface SchoolSelectionViewController : UIViewController

@property (nonatomic, weak) id<SchoolSelectionViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
