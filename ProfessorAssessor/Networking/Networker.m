#import "Networker.h"
#import "User.h"
#import "School.h"
#import "Professor.h"
#import "Course.h"
#import "Review.h"

static NSNumberFormatter *numberFormatter = nil;

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

+ (void)updateDatabaseForNewReviewWithProfessor:(Professor *)professor
                                         course:(Course *)course
                                        content:(NSString *)content
                                         rating:(NSNumber *)rating
                                     completion:(void(^)(BOOL succeeded,
                                                         NSError *_Nullable error))completion {
    Review *newReview = [Networker createReviewWithCourse:course
                                                professor:professor
                                                  content:content
                                                   rating:rating];

    PFQuery *query = [Review query];

    [query whereKey:@"professor" equalTo:professor];

    [newReview saveInBackgroundWithBlock:^(BOOL succeeded,
                                           NSError *_Nullable error) {
        if (error == nil) {
            [query
             countObjectsInBackgroundWithBlock:^(int number,
                                                NSError *_Nullable error) {
                if (error == nil) {
                    professor.averageRating = [Networker
                                               updateRatingWithDouble:[rating doubleValue]
                                               forProfessor:professor
                                               reviewCount:number];

                    [professor
                     saveInBackgroundWithBlock:^(BOOL succeeded,
                                                 NSError *_Nullable error) {
                        if (error == nil) {
                            [Networker addReview:newReview
                                        toCourse:course
                                  withCompletion:completion];
                        }
                    }];
                }
            }];
        }
    }];
}

+ (Review *)createReviewWithCourse:(Course *)course
                         professor:(Professor *)professor
                           content:(NSString *)content
                            rating:(NSNumber *)rating {
    Review *newReview = [Review new];

    newReview.reviewer = [User currentUser];
    newReview.course = course;
    newReview.rating = rating;
    newReview.content = content;
    newReview.professor = professor;

    return newReview;
}

+ (NSNumber *)updateRatingWithDouble:(double)newRating
                        forProfessor:(Professor *)professor
                         reviewCount:(int)number{
    double oldAverageRating = [professor.averageRating doubleValue];
    double newAverageRating = oldAverageRating + ((newRating - oldAverageRating) / (double)number);
    NSNumber *averageRatingAsNumber = [NSNumber numberWithDouble:newAverageRating];

    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"0.#"];
    }

    NSString *newRatingString = [numberFormatter
                                 stringFromNumber:averageRatingAsNumber];

    return [numberFormatter numberFromString:newRatingString];
}

+ (void)addReview:(Review *)newReview
         toCourse:(Course *)course
   withCompletion:(void(^)(BOOL succeeded,
                          NSError *_Nullable error))completion {
    PFRelation *reviews = [course relationForKey:@"reviews"];
    [reviews addObject:newReview];
    [course saveInBackgroundWithBlock:completion];
}

+ (void)fetchSchool:(School *)school
     withCompletion:(void (^)(PFObject *_Nullable object,
                             NSError *_Nullable error))completion {
    User *user = [User currentUser];

    [user.school fetchIfNeededInBackgroundWithBlock:completion];
}

+ (void)fetchSchoolAndProfessorsWithCompletion:(
                                                void (^)
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
                           limit:(int)limit
                  withCompletion:(
                                  void (^)
                                  (NSArray<Review *> *_Nullable objects,
                                   NSError *_Nullable error))completion {
    PFQuery *query = [Review query];

    query.limit = limit;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"course"];
    [query whereKey:@"professor" equalTo:professor];
    [query whereKey:@"course" containedIn:courses];

    [query findObjectsInBackgroundWithBlock:completion];
}

@end
