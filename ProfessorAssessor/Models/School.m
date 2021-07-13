#import "School.h"

@implementation School

@dynamic name;
@dynamic address;
@dynamic professors;

+ (nonnull NSString *)parseClassName {
    return @"School";
}

@end
