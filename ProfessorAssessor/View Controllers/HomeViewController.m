@import FBSDKLoginKit;
@import HCSStarRatingView;
#import "HomeViewController.h"
#import "AuthenticationViewController.h"
#import "ProfessorViewController.h"
#import "ProfessorSearchViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "Networker.h"
#import "SortedProfessorsCell.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, ProfessorSelectionViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *schoolName;
@property (nonatomic, strong) NSArray<Professor *> *professors;
@property (nonatomic, strong) NSArray<Professor *> *sortedProfessors;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchSchoolAndProfessors];

    [self setUpRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSIndexPath *selected = self.tableView.indexPathForSelectedRow;

    if (selected) {
        [self.tableView deselectRowAtIndexPath:selected animated:animated];
    }
}

- (void)fetchSchoolAndProfessors {
    __weak typeof(self) weakSelf = self;

    [Networker
     fetchSchoolAndProfessorsWithCompletion:^(
                                              PFObject *_Nullable object,
                                              NSError *_Nonnull error) {
        if (object) {
            __strong __typeof(self) strongSelf = weakSelf;

            strongSelf.school = [School schoolFromPFObject:object];
            strongSelf.schoolName.text = strongSelf.school.name;
            
            NSArray<Professor *> *professors = strongSelf.school.professors;
            strongSelf.professors = [professors
                                   sortedArrayUsingComparator:
                                   ^NSComparisonResult(Professor *_Nonnull professor1,
                                                       Professor *_Nonnull professor2) {
                return [professor1.name compare:professor2.name];
            }];
            strongSelf.sortedProfessors = strongSelf.professors;

            [strongSelf.tableView reloadData];
            [strongSelf.tableView.refreshControl endRefreshing];
        }
    }];
}

- (void)didSelectProfessor:(id)professor {
    self.searchedProfessor = professor;

    [self performSegueWithIdentifier:@"professorDetailSegue" sender:self];
}

- (void)setUpRefreshControl {
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];

    [self.tableView.refreshControl addTarget:self action:@selector(fetchSchoolAndProfessors) forControlEvents:UIControlEventValueChanged];

    [self.tableView insertSubview:self.tableView.refreshControl atIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedProfessors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SortedProfessorsCell *cell = [
                                  tableView
                                  dequeueReusableCellWithIdentifier:@"SortedProfessorsCell"
                                  forIndexPath:indexPath];

    Professor *professor = self.sortedProfessors[indexPath.row];
    [cell setProfessor:professor];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"professorSearchSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ProfessorSearchViewController *viewController = (ProfessorSearchViewController *)navigationController.topViewController;

        viewController.delegate = self;
        viewController.professors = self.professors;
    } else if ([segue.identifier isEqual:@"sortedSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Professor *professor = self.sortedProfessors[indexPath.row];

        ProfessorViewController *viewController = [segue destinationViewController];
        viewController.professor = professor;
    } else if ([segue.identifier isEqual:@"professorDetailSegue"]) {
        ProfessorViewController *viewController = [segue destinationViewController];

        viewController.professor = self.searchedProfessor;
    }
}

@end
