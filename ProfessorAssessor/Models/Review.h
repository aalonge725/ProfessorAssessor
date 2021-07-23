@class User;
@class Professor;
@class Course;
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Review : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) User *reviewer;
@property (nonatomic, weak) Course *course;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, weak) Professor *professor;

+ (Review *)reviewFromPFObject:(PFObject *)object;

@end

NS_ASSUME_NONNULL_END
