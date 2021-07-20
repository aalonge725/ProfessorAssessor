@import Parse;
@import FBSDKLoginKit;
#import "ProfileViewController.h"
#import "LogInOrSignUpViewController.h"
#import "SchoolSelectionViewController.h"
#import "SceneDelegate.h"
#import "User.h"
#import "School.h"

@interface ProfileViewController () <SchoolSelectionViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) User *user;


- (IBAction)logout:(UIBarButtonItem *)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [self updateLabels];
}

- (void)updateLabels {
    self.user = [User currentUser];

    [self.user.school fetchIfNeededInBackgroundWithBlock:^(PFObject *_Nullable object, NSError *_Nullable error) {
        if (object) {
            self.username.text = self.user.username;
            School *school = (School *)object;
            self.schoolName.text = school.name;
        }
    }];
}

- (void)didSelectSchool:(School *)school {
    // TODO: show alert asking user to confirm they want to change schools
    self.user.school = school;

    [self.user
     saveInBackgroundWithBlock:^(
                                 BOOL succeeded,
                                 NSError * _Nullable error) {
        if (succeeded) {
            self.schoolName.text = school.name;
        }
    }];

    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    SchoolSelectionViewController *viewController = (SchoolSelectionViewController *)navigationController.topViewController;

    viewController.delegate = self;
}

@end
