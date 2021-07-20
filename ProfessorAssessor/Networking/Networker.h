#import <Foundation/Foundation.h>
#import "School.h"
#import "Professor.h"
#import "Course.h"

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

+ (void)buildReview:(Professor *)professor
         withCourse:(Course *)course
        withContent:(NSString *)content
         withRating:(NSNumber *)rating
     withCompletion:(PFBooleanResultBlock)completion;

+ (void)fetchSchoolAndProfessorsWithCompletion:(
                                                void(^)
                                                (PFObject *_Nullable object,
                                                 NSError *_Nullable error))completion;

// TODO: add method for fetching all reviews for a professor

// TODO: add method for fetching reviews for a professor for a specific course

@end

NS_ASSUME_NONNULL_END
