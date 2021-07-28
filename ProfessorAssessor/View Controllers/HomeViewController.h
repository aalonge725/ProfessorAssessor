#import <UIKit/UIKit.h>
#import "School.h"
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (nonatomic, strong) School *school;
@property (nonatomic, strong) Professor *searchedProfessor;

- (void)fetchSchoolAndProfessors;

@end

NS_ASSUME_NONNULL_END
