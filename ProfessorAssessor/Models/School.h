#import <Parse/Parse.h>
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@interface School : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSArray<Professor *> *professors;

@end

NS_ASSUME_NONNULL_END
