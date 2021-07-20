#import "Course.h"

@implementation Course

@dynamic identifier;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic name;
@dynamic reviews;

+ (nonnull NSString *)parseClassName {
    return @"Course";
}

+ (Course *)courseFromPFObject:(PFObject *)object {
    Course *course = [Course new];

    if (object) {
        course.identifier = object[@"objectId"];
        course.createdAt = object[@"createdAt"];
        course.updatedAt = object[@"updatedAt"];
        course.name = object[@"name"];
        course.reviews = object[@"reviews"];
    }

    return course;
}

@end
