#import <Foundation/Foundation.h>
#import "Professor.h"
#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface Networker : NSObject

+ (void)buildReview:(Professor *)professor
         withCourse:(Course *)course
        withContent:(NSString *)content
         withRating:(NSNumber *)rating
     withCompletion:(PFBooleanResultBlock)completion;

@end

NS_ASSUME_NONNULL_END
