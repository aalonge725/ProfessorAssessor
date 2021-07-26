#import <Foundation/Foundation.h>
#import "School.h"
#import "Professor.h"
#import "Course.h"
#import "Review.h"

NS_ASSUME_NONNULL_BEGIN

@interface Networker : NSObject

+ (void)createSchoolWithName:(NSString *)name
                 withAddress:(NSString *)address
              withCompletion:(PFBooleanResultBlock _Nullable)completion;

+ (void)createProfessorWithName:(NSString *)name
             withDepartmentName:(NSString *)departmentName
                 withCompletion:(PFBooleanResultBlock _Nullable)completion;

+ (void)createCourseWithName:(NSString *)name
              withCompletion:(PFBooleanResultBlock _Nullable)completion;

+ (void)createReview:(Professor *)professor
          withCourse:(Course *)course
         withContent:(NSString *)content
          withRating:(NSNumber *)rating
      withCompletion:(PFBooleanResultBlock)completion;

+ (void)fetchSchool:(School *)school
     withCompletion:(void(^)(PFObject *_Nullable object,
                             NSError *_Nullable error))completion;

+ (void)fetchSchoolAndProfessorsWithCompletion:(
                                                void(^)
                                                (PFObject *_Nullable object,
                                                 NSError *_Nullable error))completion;

+ (void)fetchReviewsForProfessor:(Professor *)professor
                      forCourses:(NSArray<Course *> *)courses
                  withCompletion:(
                                  void(^)
                                  (NSArray<Review *> *_Nullable objects,
                                   NSError *_Nullable error))completion;

+ (Course *)courseFromObject:(PFObject *)object
              withCompletion:(
                              void(^)(NSArray<Review *> *_Nullable objects,
                                      NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
