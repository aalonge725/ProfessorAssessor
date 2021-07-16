#import "SignUpViewController.h"
#import "SchoolSelectionViewController.h"
#import "User.h"
#import "School.h"

@interface SignUpViewController () <SchoolSelectionViewControllerDelegate>

- (IBAction)signUp:(UIButton *)sender;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



- (IBAction)signUp:(UIButton *)sender {
    User *newUser = (User *)[PFUser user];

    newUser.username = self.username.text;
    newUser.password = self.password.text;
    // TODO: set school after selected from table view

    // TODO: set professors after selected from table view

    // TODO: check if username is taken; decide which vc users will be registered in
    if ([self validCredentials]) {
        [self performSegueWithIdentifier:@"schoolSelectionSegue" sender:self];
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

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    SchoolSelectionViewController *viewController = (SchoolSelectionViewController *)navigationController.topViewController;

    viewController.delegate = self;
}

@end
