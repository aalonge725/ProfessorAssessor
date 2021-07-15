@import Parse;
#import "ProfileViewController.h"
#import "LoginViewController.h"

@interface ProfileViewController ()

- (IBAction)logout:(UIBarButtonItem *)sender;

@end

@implementation ProfileViewController

- (IBAction)logout:(UIBarButtonItem *)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];

        [[UIApplication sharedApplication].keyWindow setRootViewController:loginViewController];
    }];
}

@end
