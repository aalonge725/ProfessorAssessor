#import "Professor.h"

@implementation Professor

@dynamic identifier;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic name;
@dynamic courses;
@dynamic departmentName;
@dynamic averageRating;

+ (nonnull NSString *)parseClassName {
    return @"Professor";
}

+ (Professor *)professorFromPFObject:(PFObject *)object {
    Professor *professor = [Professor new];

    if (object) {
        professor.identifier = object[@"objectId"];
        professor.createdAt = object[@"createdAt"];
        professor.updatedAt = object[@"updatedAt"];
        professor.name = object[@"name"];
        professor.courses = object[@"courses"];
        professor.departmentName = object[@"departmentName"];
        professor.averageRating = object[@"averageRating"];
    }

    return professor;
}

@end
