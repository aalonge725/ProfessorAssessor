#import "School.h"

@implementation School

@dynamic identifier;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic name;
@dynamic address;
@dynamic professors;

+ (nonnull NSString *)parseClassName {
    return @"School";
}

+ (School *)schoolFromPFObject:(PFObject *)object {
    School *school = [School new];

    if (object) {
        school.identifier = object[@"objectId"];
        school.createdAt = object[@"createdAt"];
        school.updatedAt = object[@"updatedAt"];
        school.name = object[@"name"];
        school.address = object[@"address"];
        school.professors = object[@"professors"];
    }

    return school;
}

@end
