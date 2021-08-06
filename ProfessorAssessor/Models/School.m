#import "School.h"

@implementation School

@dynamic identifier;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic name;
@dynamic city;
@dynamic state;
@dynamic professors;

+ (nonnull NSString *)parseClassName {
    return @"School";
}

+ (School *)schoolFromPFObject:(PFObject *)object {
    School *school = [School new];

    if (object) {
        school.identifier = object.objectId;
        school.createdAt = object.createdAt;
        school.updatedAt = object.updatedAt;
        school.name = object[@"name"];
        school.city = object[@"city"];
        school.state = object[@"state"];
        school.professors = object[@"professors"];
    }

    return school;
}

@end
