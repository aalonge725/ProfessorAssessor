@import FBSDKLoginKit;
#import "HomeViewController.h"
#import "LogInOrSignUpViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"

@interface HomeViewController ()

- (IBAction)logout:(UIBarButtonItem *)sender;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

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
