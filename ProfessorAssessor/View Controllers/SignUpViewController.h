#import <UIKit/UIKit.h>
#import "FacebookUser.h"
#import "School.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *schoolSelection;
@property (nonatomic, strong) IBOutlet UITextField *username;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) School *school;

@end

NS_ASSUME_NONNULL_END
