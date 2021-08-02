#import "SchoolSelectionCell.h"

@implementation SchoolSelectionCell

- (void)setSchool:(School *)school {
    self.name.text = school.name;
    self.address.text = school.address;
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
