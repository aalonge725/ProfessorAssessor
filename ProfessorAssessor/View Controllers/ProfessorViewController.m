@import HCSStarRatingView;
#import "ProfessorViewController.h"
#import "Professor.h"

@interface ProfessorViewController ()

@property (strong, nonatomic) IBOutlet UILabel *professorName;
@property (strong, nonatomic) IBOutlet UILabel *departmentName;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *averageRating;

@end

@implementation ProfessorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setProfessorDetails:self.professor];

    // TODO: fetch and display courses and reviews
}

- (void)setProfessorDetails:(Professor *)professor {
    self.professor = professor;

    self.professorName.text = self.professor.name;
    self.departmentName.text = self.professor.departmentName;
    self.averageRating.value = [self.professor.averageRating doubleValue];
}

@end
