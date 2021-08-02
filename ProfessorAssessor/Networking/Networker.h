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

+ (void)updateDatabaseForNewReviewWithProfessor:(Professor *)professor
                                         course:(Course *)course
                                        content:(NSString *)content
                                         rating:(NSNumber *)rating
                                     completion:(void (^)(BOOL succeeded,
                                                         NSError *_Nullable error))completion;

+ (void)fetchSchool:(School *)school
     withCompletion:(void (^)(PFObject *_Nullable object,
                             NSError *_Nullable error))completion;

+ (void)fetchSchoolsWithCompletion:(
                                    void (^)(NSArray<School *> *_Nullable schools,
                                            NSError *_Nullable error))completion;

+ (void)fetchSchoolAndProfessorsWithCompletion:(
                                                void (^)
                                                (PFObject *_Nullable object,
                                                 NSError *_Nullable error))completion;

+ (PFQuery *)fetchReviewsForProfessor:(Professor *)professor
                      forCourses:(NSMutableSet<Course *> *)courses
                           limit:(int)limit
                  withCompletion:(
                                  void (^)
                                  (NSArray<Review *> *_Nullable objects,
                                   NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
