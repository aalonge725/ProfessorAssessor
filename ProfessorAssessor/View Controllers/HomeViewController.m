@import FBSDKLoginKit;
#import "HomeViewController.h"
#import "LogInOrSignUpViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "Networker.h"
#import "School.h"
#import "Professor.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) School *school;
@property (strong, nonatomic) NSArray<Professor *> *professors;
@property (strong, nonatomic) NSArray<Professor *> *filteredProfessors;
@property (strong, nonatomic) NSArray<Professor *> *sortedProfessors;

- (IBAction)logout:(UIBarButtonItem *)sender;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchSchoolAndProfessors];
}

- (void)fetchSchoolAndProfessors {
    __weak typeof(self) weakSelf = self;

    [Networker fetchSchoolAndProfessorsWithCompletion:^(PFObject *_Nullable object, NSError *_Nonnull error) {
        if (object) {
            weakSelf.school = [School schoolFromPFObject:object];
            weakSelf.professors = weakSelf.school.professors;
            weakSelf.filteredProfessors = weakSelf.professors;

            // TODO: reload tableView
        }
    }];
}

- (IBAction)logout:(UIBarButtonItem *)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError *_Nullable error) {
        [[FBSDKLoginManager alloc] logOut];

        [self displayLoginPage];
    }];
}

- (void)displayLoginPage {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LogInOrSignUpViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInOrSignUpViewController"];

    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    [sceneDelegate changeRootViewController:viewController];
}

@end
