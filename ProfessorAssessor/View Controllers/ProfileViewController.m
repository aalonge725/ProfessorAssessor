@import Parse;
@import FBSDKLoginKit;
@import DGActivityIndicatorView;
#import "ProfileViewController.h"
#import "AuthenticationViewController.h"
#import "SchoolSelectionViewController.h"
#import "HomeViewController.h"
#import "ProfessorAssessor-Swift.h"
#import "SceneDelegate.h"
#import "Networker.h"
#import "ReviewCell.h"
#import "User.h"
#import "School.h"
#import "Review.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, SchoolSelectionViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *username;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *logoutButton;
@property (nonatomic, strong) IBOutlet UIButton *changeSchoolButton;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray<Review *> *reviews;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) Review *review;

- (IBAction)logout:(UIBarButtonItem *)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [User currentUser];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReviewCell" bundle:nil] forCellReuseIdentifier:@"ReviewCell"];

    [self decorateViews];

    [self setUpActivityIndicator];
    [self setUpRefreshControl];

    [self updateLabelsWithSchool:self.school];

    [self fetchReviewsForCurrentUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSIndexPath *selected = self.tableView.indexPathForSelectedRow;

    if (selected) {
        [self.tableView deselectRowAtIndexPath:selected animated:animated];
    }
}

- (void)fetchReviewsForCurrentUser {
    [self.activityIndicator startAnimating];

    __weak typeof(self) weakSelf = self;

    [Networker fetchReviewsForCurrentUserWithCompletion:^(NSArray<Review *> *_Nullable objects, NSError *_Nullable error) {
        if (objects) {
            __strong typeof(self) strongSelf = weakSelf;

            strongSelf.reviews = objects;

            [strongSelf.tableView reloadData];
            [strongSelf.tableView.refreshControl endRefreshing];
            [strongSelf.activityIndicator stopAnimating];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReviewCell *cell = [tableView
                        dequeueReusableCellWithIdentifier:@"ReviewCell"
                        forIndexPath:indexPath];

    Review *review = self.reviews[indexPath.row];
    [cell setReview:review];
    [cell configureBackground];

    return cell;
}

- (void)updateLabelsWithSchool:(School *)school {
    self.username.text = self.user.username;
    self.schoolName.text = school.name;
}

- (void)didSelectSchool:(School *)school {
    self.user.school = school;

    [self buttonsEnabled:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.activityIndicator startAnimating];

    [self.user
     saveInBackgroundWithBlock:^(
                                 BOOL succeeded,
                                 NSError *_Nullable error) {
        if (succeeded) {
            [self updateLabelsWithSchool:school];

            UINavigationController *navigationController =
            self.tabBarController.viewControllers[0];
            HomeViewController *viewController = (HomeViewController *)navigationController.viewControllers[0];
            
            viewController.school = school;
            [viewController fetchSchoolAndProfessors];

            [self.activityIndicator stopAnimating];
            [self buttonsEnabled:YES];
        }
    }];
}

- (IBAction)logout:(UIBarButtonItem *)sender {
    [self.activityIndicator startAnimating];

    [self buttonsEnabled:NO];

    [PFUser logOutInBackgroundWithBlock:^(NSError *_Nullable error) {
        [self.activityIndicator stopAnimating];

        [[FBSDKLoginManager alloc] logOut];

        [self displayLoginPage];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.review = self.reviews[indexPath.row];

    [self performSegueWithIdentifier:@"reviewDetailFromProfileSegue" sender:self];
}

- (void)setUpActivityIndicator {
    CGFloat width = self.view.bounds.size.width / 5.0f;
    self.activityIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotateMultiple tintColor:[UIColor systemTealColor] size:width];

    self.activityIndicator.frame = CGRectMake(self.view.center.x - width / 2, self.view.center.y - width / 2, width, width);

    [self.view addSubview:self.activityIndicator];
}

- (void)setUpRefreshControl {
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];

    [self.tableView.refreshControl addTarget:self
                                      action:@selector(fetchReviewsForCurrentUser)
                            forControlEvents:UIControlEventValueChanged];

    [self.tableView insertSubview:self.tableView.refreshControl atIndex:0];
}

- (void)displayLoginPage {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AuthenticationViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"AuthenticationViewController"];

    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    [sceneDelegate changeRootViewController:viewController];
}

- (void)buttonsEnabled:(BOOL)enabled {
    self.logoutButton.enabled = enabled;
    self.changeSchoolButton.enabled = enabled;
    self.tabBarController.tabBar.userInteractionEnabled = enabled;
}

- (void)decorateViews {
    [self decorateButton:self.changeSchoolButton];
}

- (void)decorateButton:(UIButton *)button {
    button.layer.borderWidth = 2.0f;
    button.layer.borderColor = [[UIColor colorNamed:@"DefaultBlue"] CGColor];
    button.layer.cornerRadius = 8;
    button.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"changeSchoolSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        SchoolSelectionViewController *viewController = (SchoolSelectionViewController *)navigationController.topViewController;

        viewController.delegate = self;
    } else if ([segue.identifier isEqual:@"reviewDetailFromProfileSegue"]) {
        ReviewViewController *viewController = [segue destinationViewController];

        viewController.review = self.review;
    }
}

@end
