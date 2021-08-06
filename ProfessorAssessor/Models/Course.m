#import "Course.h"
#import "Networker.h"

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
        course.identifier = object.objectId;
        course.createdAt = object.createdAt;
        course.updatedAt = object.updatedAt;
        course.name = object[@"name"];
        course.reviews = [Course reviewsForCourseObject:object];
    }

    return course;
}

+ (NSArray<Review *> *)reviewsForCourseObject:(PFObject *)object {
    PFQuery *reviewQuery = [Review query];

    [reviewQuery orderByDescending:@"createdAt"];
    [reviewQuery includeKeys:@[@"course", @"professor"]];
    [reviewQuery whereKey:@"course" equalTo:object];

    return [reviewQuery findObjects];
}

@end
