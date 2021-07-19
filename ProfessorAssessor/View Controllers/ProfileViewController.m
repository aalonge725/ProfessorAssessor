@import Parse;
@import FBSDKLoginKit;
#import "ProfileViewController.h"
#import "LogInOrSignUpViewController.h"
#import "SceneDelegate.h"

@interface ProfileViewController ()

- (IBAction)logout:(UIBarButtonItem *)sender;

@end

@implementation ProfileViewController

- (IBAction)logout:(UIBarButtonItem *)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError *_Nullable error) {
        [[FBSDKLoginManager alloc] logOut];

        [self displayLoginPage];
    }];
}

- (void)displayLoginPage {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LogInOrSignUpViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInOrSignUpViewController"];

    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    [sceneDelegate changeRootViewController:viewController];
}

@end
