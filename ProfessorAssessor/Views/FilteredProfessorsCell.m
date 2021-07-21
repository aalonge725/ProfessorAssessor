#import "FilteredProfessorsCell.h"

@implementation FilteredProfessorsCell

- (void)setProfessor:(Professor *)professor {
    self.professorName.text = professor.name;
    self.departmentName.text = professor.departmentName;
    self.averageRating.value = [(professor.averageRating) doubleValue];
}

@end
