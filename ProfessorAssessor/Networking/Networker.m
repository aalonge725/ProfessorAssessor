#import "Networker.h"
#import "User.h"
#import "School.h"
#import "Professor.h"
#import "Course.h"
#import "Review.h"

@implementation Networker

+ (void)createSchoolWithName:(NSString *)name
                 withAddress:(NSString *)address
              withCompletion:(PFBooleanResultBlock)completion {
    School *newSchool = [School new];
    
    newSchool.name = name;
    newSchool.address = address;

    [newSchool saveInBackgroundWithBlock:completion];
}

+ (void)createProfessorWithName:(NSString *)name
             withDepartmentName:(NSString *)departmentName
                 withCompletion:(PFBooleanResultBlock)completion {
    Professor *newProfessor = [Professor new];

    newProfessor.name = name;
    newProfessor.departmentName = departmentName;

    [newProfessor saveInBackgroundWithBlock:completion];
}
+ (void)createCourseWithName:(NSString *)name
              withCompletion:(PFBooleanResultBlock)completion {
    Course *newCourse = [Course new];

    newCourse.name = name;

    [newCourse saveInBackgroundWithBlock:completion];
}

+ (void)buildReview:(Professor *)professor
         withCourse:(Course *)course
        withContent:(NSString *)content
         withRating:(NSNumber *)rating
     withCompletion:(PFBooleanResultBlock)completion {
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

    [newReview saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
        if (error == nil) {
            PFRelation *reviews = [course relationForKey:@"reviews"];
            [reviews addObject:newReview];
            [course saveInBackground];
        }
    }];
}

@end
