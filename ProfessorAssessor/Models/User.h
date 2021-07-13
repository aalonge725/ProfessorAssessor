#import <Parse/Parse.h>
#import "School.h"
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser <PFSubclassing>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) School *school;
@property (nonatomic, strong) NSMutableArray<Professor *> *professors;

@end

NS_ASSUME_NONNULL_END
