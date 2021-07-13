#import "Course.h"

@implementation Course

@dynamic name;
@dynamic reviews;

+ (nonnull NSString *)parseClassName {
    return @"Course";
}

@end
