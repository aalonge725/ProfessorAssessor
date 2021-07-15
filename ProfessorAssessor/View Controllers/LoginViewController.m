#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "User.h"
#import "HomeViewController.h"
#import "SchoolSelectionViewController.h"

@interface LoginViewController ()

- (IBAction)login:(UIButton *)sender;
- (IBAction)signUp:(UIButton *)sender;

@end

@implementation LoginViewController

- (IBAction)login:(UIButton *)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;

    if ([self validCredentials]) {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error == nil) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                HomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];

                SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

                [sceneDelegate changeRootViewController:viewController];
            }
        }];
    }
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

@end
