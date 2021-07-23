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
            [course saveInBackgroundWithBlock:completion];
        }
    }];
}

+ (void)fetchSchoolAndProfessorsWithCompletion:(
                                                void(^)
                                                (PFObject *_Nullable,
                                                 NSError *_Nullable))completion {
    PFQuery *query = [School query];

    [query includeKeys:@[@"professors",
                         @"professors.courses",
                         @"professors.courses.reviews"]];

    [query
     getObjectInBackgroundWithId:[User currentUser].school.objectId
     block:completion];
}

+ (void)fetchReviewsForProfessor:(Professor *)professor
                      forCourses:(NSArray<Course *> *)courses
                  withCompletion:(
                                  void(^)
                                  (NSArray<Review *> *_Nullable objects,
                                   NSError *_Nullable error))completion {
    PFQuery *query = [Review query];

    [query orderByDescending:@"createdAt"];
    [query whereKey:@"professor" equalTo:professor];
    [query whereKey:@"course" containedIn:courses];

    [query findObjectsInBackgroundWithBlock:completion];
}


+ (Course *)courseFromObject:(PFObject *)object
              withCompletion:(
                              void(^)(NSArray<Review *> *_Nullable objects,
                                      NSError *_Nullable error))completion {
    if (object) {
        Course *course = [Course new];
        course.identifier = object[@"objectId"];
        course.createdAt = object[@"createdAt"];
        course.updatedAt = object[@"updatedAt"];
        course.name = object[@"name"];

        PFQuery *reviewQuery = [Review query];

        [reviewQuery orderByDescending:@"createdAt"];
        [reviewQuery includeKey:@"course"];
        [reviewQuery whereKey:@"course" equalTo:object];

        [reviewQuery findObjectsInBackgroundWithBlock:completion];

        return course;
    }
    return [Course new];
}

@end
