#import "ProfessorSelectionCell.h"

@implementation ProfessorSelectionCell

- (void)setProfessor:(Professor *)professor {
    self.name.text = professor.name;
    self.departmentName.text = professor.departmentName;
}

@end
