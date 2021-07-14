#import "Networker.h"
#import "User.h"
#import "School.h"
#import "Professor.h"
#import "Course.h"
#import "Review.h"

@implementation Networker

+ (void)buildReview:(Professor *)professor withCourse:(Course *)course withContent:(NSString *)content withRating:(NSNumber *)rating withCompletion:(PFBooleanResultBlock)completion {
    // TODO: check if you can create a professor
    // TODO: check if you can create a course
    // TODO: make sure content isn't empty
    // TODO: if all the validation passes, create a new Review object
    
    Review *newReview = [Review new];
    newReview.reviewer = (User *)[PFUser currentUser];
    newReview.course = course;
    newReview.rating = rating;
    newReview.content = content;
    newReview.professor = professor;

    [newReview saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error posting new review: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully posted new review!");
            PFRelation *reviews = [course relationForKey:@"reviews"];
            [reviews addObject:newReview];
            [course saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Error added new review to a course list: %@", error.localizedDescription);
                } else {
                    NSLog(@"Successfully added new review to a course list");
                }
            }];
        }
    }];
}

@end
