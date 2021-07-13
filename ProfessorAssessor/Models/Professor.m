#import "Professor.h"

@implementation Professor

@dynamic name;
@dynamic courses;
@dynamic departmentName;
@dynamic averageRating;

+ (nonnull NSString *)parseClassName {
    return @"Professor";
}

@end
