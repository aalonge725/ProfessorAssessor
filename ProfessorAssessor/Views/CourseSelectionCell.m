#import "CourseSelectionCell.h"

@implementation CourseSelectionCell

- (void)setCourse:(Course *)course {
    self.name.text = course.name;
}

@end
