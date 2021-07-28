@import Parse;
#import "ReviewCell.h"
#import "Course.h"

static NSDateFormatter *dateFormatter = nil;

@implementation ReviewCell

- (void)setReview:(Review *)review {
    self.courseName.text = review.course.name;
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

@end
