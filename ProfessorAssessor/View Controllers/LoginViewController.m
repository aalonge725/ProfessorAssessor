#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "User.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;

- (IBAction)login:(UIButton *)sender;
- (IBAction)signUp:(UIButton *)sender;

@end

@implementation LoginViewController

- (IBAction)login:(UIButton *)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    // TODO: check if username and password are valid before method call
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (error == nil) {
            // TODO: manually segue to logged in view
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }];
}

- (IBAction)signUp:(UIButton *)sender {
    User *newUser = (User *)[PFUser user];

    newUser.username = self.username.text;
    newUser.password = self.password.text;

    // TODO: set school after selected from table view

    // TODO: set professors after selected from table view

    // TODO: check if username and password are valid before signup;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self performSegueWithIdentifier:@"schoolSelectionSegue" sender:self];
        }
    }];
}

@end
