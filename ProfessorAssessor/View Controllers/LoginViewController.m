#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;

- (IBAction)didTapLogin:(UIButton *)sender;
- (IBAction)didTapSignUp:(UIButton *)sender;
- (IBAction)didTapSignUpWithFacebook:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapLogin:(UIButton *)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;

    // TODO: check if username and password are valid before method call
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            // TODO: handle error
        } else {
            // TODO: manually segue to logged in view
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }];
}

- (IBAction)didTapSignUp:(UIButton *)sender {
    PFUser *newUser = [PFUser user];

    newUser.username = self.username.text;
    newUser.password = self.username.text;

    // TODO: check if username and password are valid before method call
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            // TODO: handle error
        } else {
            // TODO: manually segue to register view
            [self performSegueWithIdentifier:@"signUpSegue" sender:self];
        }
    }];
}

- (IBAction)didTapSignUpWithFacebook:(UIButton *)sender {

}

@end
