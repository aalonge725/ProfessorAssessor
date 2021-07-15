#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "User.h"
#import "HomeViewController.h"
#import "SchoolSelectionViewController.h"

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
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];

            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            
            [sceneDelegate changeRootViewController:viewController];
        }
    }];
}

- (IBAction)signUp:(UIButton *)sender {
    User *newUser = (User *)[PFUser user];

    newUser.username = self.username.text;
    newUser.password = self.password.text;

    // TODO: set school after selected from table view

    // TODO: set professors after selected from table view

    // TODO: check if username and password are valid before manual segue to SchoolSelectionVC
}

@end
