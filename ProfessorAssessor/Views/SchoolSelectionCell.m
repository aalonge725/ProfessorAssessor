#import "SchoolSelectionCell.h"

@implementation SchoolSelectionCell

- (void)setSchool:(School *)school {
    self.name.text = school.name;
    self.address.text = school.address;
}

@end
