@import FBSDKLoginKit;
#import "SignUpViewController.h"
#import "SceneDelegate.h"
#import "SchoolSelectionViewController.h"
#import "HomeViewController.h"
#import "User.h"
#import "School.h"
#import "FacebookUser.h"

@interface SignUpViewController () <SchoolSelectionViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *signUpButton;
@property (nonatomic, strong) IBOutlet UIButton *signUpWithFacebookButton;
@property (nonatomic, strong) FacebookUser *user;

- (IBAction)signUp:(UIButton *)sender;
- (IBAction)signUpWithFacebook:(UIButton *)sender;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self disableSignUpFieldsAndButtons];
}

- (IBAction)signUp:(UIButton *)sender {
    User *newUser = [self createUserWithUsernameAndPassword];

    if ([self validCredentials]) {
        [self signUpNewUser:newUser];
    }
}

- (User *)createUserWithFacebookLogin {
    User *newUser = (User *)[PFUser user];

    newUser.username = self.user.email;
    newUser.password = self.user.email;
    newUser.firstName = self.user.firstName;
    newUser.lastName = self.user.lastName;
    newUser.email = self.user.email;
    newUser.school = self.school;

    return newUser;
}

- (User *)createUserWithUsernameAndPassword {
    User *newUser = (User *)[PFUser user];

    newUser.username = self.username.text;
    newUser.password = self.password.text;
    newUser.school = self.school;

    return newUser;
}

- (void)signUpNewUser:(User *)newUser {
    [newUser signUpInBackgroundWithBlock:^(
                                           BOOL succeeded,
                                           NSError *_Nullable error) {
        if (succeeded) {
            [self displayHomePage];
        } else {
            [self presentAlertWithTitle:nil withMessage:error.localizedDescription];
        }
    }];
}

- (IBAction)signUpWithFacebook:(UIButton *)sender {
    FBSDKLoginManager *manager = [FBSDKLoginManager new];

    [self displayFacebookLoginWithManager:manager];
}

- (void)displayFacebookLoginWithManager:(FBSDKLoginManager *)manager {
    [manager logInWithPermissions:@[@"public_profile", @"email"]
               fromViewController:self
                          handler:^(FBSDKLoginManagerLoginResult *_Nullable result,
                                    NSError *_Nullable error) {
        if (error == nil && !result.isCancelled) {
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:@"/me"
                                          parameters:@{@"fields":@"first_name,last_name,email"}
                                          HTTPMethod:@"GET"];

            [self fetchUserInformationWithRequest:request];
        }
    }];
}

- (void)fetchUserInformationWithRequest:(FBSDKGraphRequest *)request {
    [request
     startWithCompletion:^(
                           id<FBSDKGraphRequestConnecting> _Nullable connection,
                           id _Nullable result,
                           NSError *_Nullable error) {
        if (result) {
            FacebookUser *user = [FacebookUser
                                  createUserWithFirstName:result[@"first_name"]
                                  lastName:result[@"last_name"]
                                  email:result[@"email"]];

            self.user = user;

            [self completeSignUpWithFacebookUser:user];
        }
    }];
}

- (void)completeSignUpWithFacebookUser:(FacebookUser *)user {
    PFQuery *userQuery = [User query];

    [userQuery whereKey:@"email" equalTo:user.email];

    [userQuery
     countObjectsInBackgroundWithBlock:^(
                                         int count,
                                         NSError *_Nullable error) {
        if (count == 0) {
            User *newUser = [self createUserWithFacebookLogin];

            [self signUpNewUser:newUser];
        } else {
            [PFUser
             logInWithUsernameInBackground:user.email
             password:user.email
             block:^(PFUser *_Nullable user, NSError *_Nullable error) {
                if (error == nil) {
                    [self displayHomePage];
                }
            }];
        }
    }];
}

- (void)displayHomePage {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];

    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    [sceneDelegate changeRootViewController:viewController];
}

- (BOOL)validCredentials {
    if ([self.username.text isEqual:@""] || [self.password.text isEqual:@""]) {
        [self presentAlertWithTitle:nil withMessage:@"Username and password must be nonempty"];
        return NO;
    } else if ([self.password.text length] < 4) {
        [self presentAlertWithTitle:nil withMessage:@"Password must have at least 4 characters"];
        return NO;
    }
    return YES;
}

- (void)presentAlertWithTitle:(NSString *)title withMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *_Nonnull action) {
    }];
    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didSelectSchool:(School *)school {
    self.school = school;
    self.schoolSelection.text = school.name;

    [self enableSignUpFieldsAndButtons];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)disableSignUpFieldsAndButtons {
    self.username.enabled = NO;
    self.password.enabled = NO;
    self.signUpButton.enabled = NO;
    self.signUpWithFacebookButton.enabled = NO;
}

- (void)enableSignUpFieldsAndButtons {
    self.username.enabled = YES;
    self.password.enabled = YES;
    self.signUpButton.enabled = YES;
    self.signUpWithFacebookButton.enabled = YES;
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    SchoolSelectionViewController *viewController = (SchoolSelectionViewController *)navigationController.topViewController;

    viewController.delegate = self;
}

@end
