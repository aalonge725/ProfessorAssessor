#import "SchoolCell.h"

@implementation SchoolCell

- (void)setSchool:(School *)school {
    self.name.text = school.name;
    self.address.text = [NSString stringWithFormat:@"%@, %@", school.city, school.state];
}

- (void)configureBackground {
    self.background.layer.shadowOpacity = 0.5;
    self.background.layer.shadowRadius = 5;
    self.background.layer.shadowOffset = CGSizeMake(0, 0);
    self.background.layer.shadowColor = [UIColor blackColor].CGColor;
    self.background.backgroundColor = [UIColor colorNamed:@"Lavender"];
    self.background.layer.cornerRadius = 10;
}

@end
