@import FBSDKLoginKit;
#import "SignUpViewController.h"
#import "SceneDelegate.h"
#import "SchoolSelectionViewController.h"
#import "HomeViewController.h"
#import "User.h"
#import "School.h"

@interface SignUpViewController () <SchoolSelectionViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;

- (IBAction)signUp:(UIButton *)sender;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self disableSignUpFieldsAndButtons];

    [self saveFacebookAccountInformation];
}

- (IBAction)signUp:(UIButton *)sender {
    if (self.email != nil) {
        User *newUser = [self createUserWithFacebookLogin];

        [self signUpNewUser:newUser];
    } else {
        User *newUser = [self createUserWithUsernameAndPassword];

        if ([self validCredentials]) {
            [self signUpNewUser:newUser];
        }
    }
}

- (User *)createUserWithFacebookLogin {
    User *newUser = (User *)[PFUser user];

    newUser.username = [[NSUUID UUID] UUIDString];
    newUser.password = [[NSUUID UUID] UUIDString];
    newUser.firstName = self.firstName;
    newUser.lastName = self.lastName;
    newUser.email = self.email;
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
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
        if (succeeded) {
            [self displayHomePage];
        } else {
            [self presentAlertWithTitle:nil withMessage:error.localizedDescription];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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

- (void)saveFacebookAccountInformation {
    self.firstName = self.requestResult[@"first_name"];
    self.lastName = self.requestResult[@"last_name"];
    self.email = self.requestResult[@"email"];
}

- (void)disableSignUpFieldsAndButtons {
    if (FBSDKAccessToken.currentAccessTokenIsActive) {
        [self.username setHidden:YES];
        [self.password setHidden:YES];
    }
    
    self.username.enabled = NO;
    self.password.enabled = NO;
    self.signUpButton.enabled = NO;
}

- (void)enableSignUpFieldsAndButtons {
    self.username.enabled = YES;
    self.password.enabled = YES;
    self.signUpButton.enabled = YES;
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
