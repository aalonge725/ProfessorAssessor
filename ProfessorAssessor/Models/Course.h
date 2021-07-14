#import <Parse/Parse.h>
#import "Review.h"

NS_ASSUME_NONNULL_BEGIN

@interface Course : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<Review *> *reviews;

@end

NS_ASSUME_NONNULL_END
