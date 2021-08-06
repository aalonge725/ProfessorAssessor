#import "User.h"
#import "Review.h"
#import "Professor.h"
#import "Course.h"

@implementation Review

@dynamic identifier;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic reviewer;
@dynamic course;
@dynamic rating;
@dynamic content;
@dynamic professor;
@dynamic likes;
@dynamic dislikes;

+ (nonnull NSString *)parseClassName {
    return @"Review";
}

+ (Review *)reviewFromPFObject:(PFObject *)object {
    Review *review = [Review new];

    if (object) {
        review.identifier = object.objectId;
        review.createdAt = object.createdAt;
        review.updatedAt = object.updatedAt;
        review.reviewer = object[@"reviewer"];
        review.course = object[@"course"];
        review.rating = object[@"rating"];
        review.content = object[@"content"];
        review.professor = object[@"professor"];
        review.likes = object[@"likes"];
        review.dislikes = object[@"likes"];
    }

    return review;
}

@end
