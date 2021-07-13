#import <Parse/Parse.h>
#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface Professor : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<Course *> *courses;
@property (nonatomic, strong) NSString *departmentName;
@property (nonatomic, strong) NSNumber *averageRating;

@end

NS_ASSUME_NONNULL_END
