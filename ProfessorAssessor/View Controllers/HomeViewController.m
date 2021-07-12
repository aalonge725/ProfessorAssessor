#import "HomeViewController.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface HomeViewController ()

- (IBAction)didTapLogout:(UIBarButtonItem *)sender;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapLogout:(UIBarButtonItem *)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];

        [[UIApplication sharedApplication].keyWindow setRootViewController:loginViewController];
    }];
}

@end
