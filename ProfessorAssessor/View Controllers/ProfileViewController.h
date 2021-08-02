#import <UIKit/UIKit.h>
#import "School.h"
#import "Review.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) School *school;
@property (nonatomic, strong) IBOutlet UILabel *schoolName;

@end

NS_ASSUME_NONNULL_END
