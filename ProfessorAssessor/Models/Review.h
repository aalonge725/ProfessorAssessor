@class User;
@class Professor;
@class Course;
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Review : PFObject <PFSubclassing>

@property (nonatomic, strong) User *reviewer;
@property (nonatomic, weak) Course *course;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, weak) Professor *professor;

@end

NS_ASSUME_NONNULL_END
