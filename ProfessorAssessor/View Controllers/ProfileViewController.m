@import Parse;
@import FBSDKLoginKit;
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"

@interface ProfileViewController ()

- (IBAction)logout:(UIBarButtonItem *)sender;

@end

@implementation ProfileViewController

- (IBAction)logout:(UIBarButtonItem *)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError *_Nullable error) {
        if (FBSDKAccessToken.currentAccessTokenIsActive) {
            [[FBSDKLoginManager alloc] logOut];
        }

        [self displayLoginPage];
    }];
}

- (void)displayLoginPage {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];

    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    [sceneDelegate changeRootViewController:loginViewController];
}

@end
