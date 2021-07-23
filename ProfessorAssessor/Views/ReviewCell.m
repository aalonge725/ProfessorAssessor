@import Parse;
#import "ReviewCell.h"
#import "Course.h"

static NSDateFormatter *dateFormatter = nil;

@implementation ReviewCell

- (void)setReview:(Review *)review {
    [review.course
     fetchIfNeededInBackgroundWithBlock:^
     (PFObject *_Nullable object,
      NSError *_Nullable error) {
        if (object) {
            Course *course = [Course courseFromPFObject:object];

            self.courseName.text = course.name;
            self.rating.value = [review.rating doubleValue];
            self.content.text = review.content;

            if (dateFormatter == nil) {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            }

            self.date.text = [dateFormatter
                              stringFromDate:review.createdAt];
        }
    }];
}

@end
