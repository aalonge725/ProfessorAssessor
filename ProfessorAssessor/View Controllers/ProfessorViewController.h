#import <UIKit/UIKit.h>
#import "Professor.h"
#import "Course.h"
#import "Review.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessorViewController : UIViewController

@property (nonatomic, strong) Professor *professor;
@property (nonatomic, strong) NSCache<NSMutableSet<Course *> *, NSArray<Review *> *> *reviewCache;

@end

NS_ASSUME_NONNULL_END
