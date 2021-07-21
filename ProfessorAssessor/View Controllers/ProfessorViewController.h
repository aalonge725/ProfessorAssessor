#import <UIKit/UIKit.h>
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessorViewController : UIViewController

@property (nonatomic, strong) Professor *professor;

- (void)setProfessor:(Professor *)professor;

@end

NS_ASSUME_NONNULL_END
