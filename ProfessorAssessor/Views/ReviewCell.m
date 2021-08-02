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

- (void)configureBackground {
    self.background.layer.masksToBounds = NO;
    self.background.layer.shadowOpacity = 0.25;
    self.background.layer.shadowRadius = 5;
    self.background.layer.shadowOffset = CGSizeMake(0, 0);
    self.background.layer.shadowColor = [UIColor blackColor].CGColor;
    self.background.backgroundColor = [UIColor whiteColor];
    self.background.layer.cornerRadius = 10;
}

@end
