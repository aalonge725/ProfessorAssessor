#import <Parse/Parse.h>
#import "Review.h"

NS_ASSUME_NONNULL_BEGIN

@interface Course : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<Review *> *reviews;

+ (Course *)courseFromPFObject:(PFObject *)object;

@end

NS_ASSUME_NONNULL_END
