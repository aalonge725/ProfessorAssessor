#import <Parse/Parse.h>
#import "School.h"
#import "Professor.h"
#import "Review.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser <PFSubclassing>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) School *school;
@property (nonatomic, strong) NSMutableArray<Professor *> *professors;
@property (nonatomic, strong) NSMutableArray<Review *> *likedReviews;
@property (nonatomic, strong) NSMutableArray<Review *> *dislikedReviews;

@end

NS_ASSUME_NONNULL_END
