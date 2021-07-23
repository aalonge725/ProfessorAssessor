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
    if (object) {
        return [Networker courseFromObject:object
                            withCompletion:^
                (NSArray<Review *> *_Nullable objects,
                 NSError *_Nullable error) {
        }];
    }

    return [Course new];
}

@end
