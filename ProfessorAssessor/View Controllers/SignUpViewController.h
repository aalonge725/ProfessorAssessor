#import <UIKit/UIKit.h>
#import "FacebookUser.h"
#import "School.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *schoolSelection;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) FacebookUser *user;
@property (strong, nonatomic) School *school;

@end

NS_ASSUME_NONNULL_END
