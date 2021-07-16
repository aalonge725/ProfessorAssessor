#import "SignUpViewController.h"
#import "SceneDelegate.h"
#import "SchoolSelectionViewController.h"
#import "HomeViewController.h"
#import "User.h"
#import "School.h"

@interface SignUpViewController () <SchoolSelectionViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *signUpWithFacebookButton;

- (IBAction)signUp:(UIButton *)sender;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self disableSignUpFieldsAndButtons];
}

- (IBAction)signUp:(UIButton *)sender {
    User *newUser = (User *)[PFUser user];

    newUser.username = self.username.text;
    newUser.password = self.password.text;
    newUser.school = self.school;

    if ([self validCredentials]) {
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                HomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];

                SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

                [sceneDelegate changeRootViewController:viewController];
            } else {
                [self presentAlertWithTitle:nil withMessage:error.localizedDescription];
            }
        }];
    }
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
