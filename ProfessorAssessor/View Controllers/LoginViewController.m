#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "User.h"
#import "School.h"
#import "Professor.h"
#import "Course.h"
#import "Review.h"
#import "Networker.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;

- (IBAction)didTapLogin:(UIButton *)sender;
- (IBAction)didTapSignUp:(UIButton *)sender;

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
    // TODO: make new user and set username and password

    // TODO: set school after selected from table view

    // TODO: check if username and password are valid; if so, sign up in background with block.
        // TODO: if error != nil, handle error
        // TODO: else, manually segue using signUpSegue
}

@end
