#import <Parse/Parse.h>
#import "Professor.h"

NS_ASSUME_NONNULL_BEGIN

@interface School : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSArray<Professor *> *professors;

+ (School *)schoolFromPFObject:(PFObject *)object;

@end

NS_ASSUME_NONNULL_END
