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

    [self setProfessor:self.professor];
}

- (void)setProfessor:(Professor *)professor {
    self.professor = professor;

}

@end
