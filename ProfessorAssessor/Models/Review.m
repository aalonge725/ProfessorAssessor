#import "User.h"
#import "Review.h"
#import "Professor.h"
#import "Course.h"

@implementation Review

@dynamic reviewer;
@dynamic course;
@dynamic rating;
@dynamic content;
@dynamic professor;

+ (nonnull NSString *)parseClassName {
    return @"Review";
}

@end
