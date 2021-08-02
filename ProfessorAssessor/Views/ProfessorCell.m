#import "ProfessorCell.h"

@implementation ProfessorCell

- (void)setProfessor:(Professor *)professor {
    self.professorName.text = professor.name;
    self.departmentName.text = professor.departmentName;
    self.averageRating.value = [(professor.averageRating) doubleValue];
}

- (void)configureBackground {
    self.background.layer.shadowOpacity = 0.25;
    self.background.layer.shadowRadius = 5;
    self.background.layer.shadowOffset = CGSizeMake(0, 0);
    self.background.layer.shadowColor = [UIColor blackColor].CGColor;
    self.background.backgroundColor = [UIColor whiteColor];
    self.background.layer.cornerRadius = 10;
}

@end
