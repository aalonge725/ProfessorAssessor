@import FBSDKLoginKit;
@import HCSStarRatingView;
@import DGActivityIndicatorView;
#import "HomeViewController.h"
#import "AuthenticationViewController.h"
#import "ProfessorViewController.h"
#import "ProfessorSearchViewController.h"
#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "Networker.h"
#import "ProfessorCell.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, ProfessorSelectionViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *schoolName;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *searchButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *composeButton;
@property (nonatomic, strong) IBOutlet UIButton *sortButton;
@property (nonatomic, strong) NSArray<Professor *> *professors;
@property (nonatomic, strong) NSArray<Professor *> *sortedProfessors;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicator;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfessorCell" bundle:nil] forCellReuseIdentifier:@"ProfessorCell"];

    [self setUpActivityIndicator];
    [self setUpRefreshControl];

    [self fetchSchoolAndProfessors];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSIndexPath *selected = self.tableView.indexPathForSelectedRow;

    if (selected) {
        [self.tableView deselectRowAtIndexPath:selected animated:animated];
    }
}

- (void)fetchSchoolAndProfessors {
    [self.activityIndicator startAnimating];
    [self viewsEnabled:NO];

    __weak typeof(self) weakSelf = self;

    [Networker
     fetchSchoolAndProfessorsWithCompletion:^(
                                              PFObject *_Nullable object,
                                              NSError *_Nonnull error) {
        if (object) {
            __strong __typeof(self) strongSelf = weakSelf;

            strongSelf.school = [School schoolFromPFObject:object];
            strongSelf.schoolName.text = strongSelf.school.name;
            [self setSchoolInProfileTab];
            
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
            [strongSelf.activityIndicator stopAnimating];
            [self viewsEnabled:YES];
        }
    }];
}

- (void)viewsEnabled:(BOOL)enabled {
    self.searchButton.enabled = enabled;
    self.composeButton.enabled = enabled;
    self.sortButton.enabled = enabled;
    self.tableView.userInteractionEnabled = enabled;
    self.tabBarController.tabBar.userInteractionEnabled = enabled;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.professor = self.sortedProfessors[indexPath.row];

    [self performSegueWithIdentifier:@"professorDetailSegue" sender:self];
}

- (void)didSelectProfessor:(Professor *)professor {
    self.professor = professor;

    [self performSegueWithIdentifier:@"professorDetailSegue" sender:self];
}

- (void)setSchoolInProfileTab {
    UINavigationController *navigationController = self.tabBarController.viewControllers[1];
    ProfileViewController *viewController = (ProfileViewController *)navigationController.viewControllers[0];

    viewController.school = self.school;
}

- (void)setUpRefreshControl {
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];

    [self.tableView.refreshControl addTarget:self action:@selector(fetchSchoolAndProfessors) forControlEvents:UIControlEventValueChanged];

    [self.tableView insertSubview:self.tableView.refreshControl atIndex:0];
}

- (void)setUpActivityIndicator {
    CGFloat width = self.view.bounds.size.width / 5.0f;
    self.activityIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotateMultiple tintColor:[UIColor systemTealColor] size:width];

    self.activityIndicator.frame = CGRectMake(self.view.center.x - width / 2, self.view.center.y - width / 2, width, width);

    [self.view addSubview:self.activityIndicator];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedProfessors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfessorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfessorCell" forIndexPath:indexPath];

    Professor *professor = self.sortedProfessors[indexPath.row];
    [cell setProfessor:professor];
    [cell configureBackground];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"professorSearchSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ProfessorSearchViewController *viewController = (ProfessorSearchViewController *)navigationController.topViewController;

        viewController.delegate = self;
        viewController.professors = self.professors;
    } else if ([segue.identifier isEqual:@"professorDetailSegue"]) {
        ProfessorViewController *viewController = [segue destinationViewController];

        viewController.professor = self.professor;
    }
}

@end
