#import <UIKit/UIKit.h>
#import "School.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (nonatomic, strong) School *school;

- (void)fetchSchoolAndProfessors;

@end

NS_ASSUME_NONNULL_END
