@import Parse;
@import FBSDKLoginKit;
#import "ProfileViewController.h"
#import "AuthenticationViewController.h"
#import "SchoolSelectionViewController.h"
#import "HomeViewController.h"
#import "SceneDelegate.h"
#import "Networker.h"
#import "User.h"
#import "School.h"

@interface ProfileViewController () <SchoolSelectionViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *username;
@property (nonatomic, strong) User *user;

- (IBAction)logout:(UIBarButtonItem *)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchSchoolWithCompletion:^(School *school) {
        [self updateLabelsWithSchool:school];
    }];
}

- (void)fetchSchoolWithCompletion:(void (^)(School *))completion {
    self.user = [User currentUser];

    [Networker fetchSchool:self.user.school
            withCompletion:^(PFObject *_Nullable object,
                             NSError *_Nullable error) {
        if (object) {
            School *school = [School schoolFromPFObject:object];
            completion(school);
        }
    }];
}

- (void)updateLabelsWithSchool:(School *)school {
    self.username.text = self.user.username;
    self.schoolName.text = school.name;
}

- (void)didSelectSchool:(School *)school {
    self.user.school = school;

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
        }
        [self dismissViewControllerAnimated:YES completion:nil];
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
    AuthenticationViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"AuthenticationViewController"];

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
