@import FBSDKLoginKit;
#import "LogInViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "HomeViewController.h"
#import "SchoolSelectionViewController.h"
#import "SignUpViewController.h"
#import "FacebookUser.h"
#import "User.h"

@interface LogInViewController ()

- (IBAction)logIn:(UIButton *)sender;
- (IBAction)logInWithFacebook:(UIButton *)sender;

@end

@implementation LogInViewController

- (IBAction)logIn:(UIButton *)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;

    if ([self validCredentials]) {
        [PFUser logInWithUsernameInBackground:username
                                     password:password
                                        block:^(PFUser *user,
                                                NSError *error) {
            if (error == nil) {
                [self displayHomePage];
            }
        }];
    }
}

- (IBAction)logInWithFacebook:(UIButton *)sender {
    FBSDKLoginManager *manager = [FBSDKLoginManager new];

    [self displayFacebookLoginWithManager:manager];
}

- (void)displayFacebookLoginWithManager:(FBSDKLoginManager *)manager {
    [manager logInWithPermissions:@[@"public_profile", @"email"]
               fromViewController:self
                          handler:^(
                                    FBSDKLoginManagerLoginResult *_Nullable result,
                                    NSError *_Nullable error) {
        if (error == nil && !result.isCancelled) {
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:@"/me"
                                          parameters:@{@"fields":@"first_name,last_name,email"}
                                          HTTPMethod:@"GET"];

            [self fetchUserInformationWithRequest:request];
        }
    }];
}

- (void)fetchUserInformationWithRequest:(FBSDKGraphRequest *)request {
    [request
     startWithCompletion:^(
                           id<FBSDKGraphRequestConnecting> _Nullable connection,
                           id _Nullable result,
                           NSError *_Nullable error) {
        if (result) {
            FacebookUser *user = [FacebookUser
                                  createUserWithFirstName:result[@"first_name"]
                                  lastName:result[@"last_name"]
                                  email:result[@"email"]];

            [self completeLoginWithFacebookUser:user];
        }
    }];
}

- (void)completeLoginWithFacebookUser:(FacebookUser *)user {
    PFQuery *userQuery = [User query];

    [userQuery whereKey:@"email" equalTo:user.email];

    [userQuery
     countObjectsInBackgroundWithBlock:^(
                                         int count,
                                         NSError *_Nullable error) {
        if (count == 0) {
            [self presentAlertWithTitle:nil withMessage:@"No account associated with this Facebook login. Please click 'Back' to sign up."];
        } else {
            [PFUser
             logInWithUsernameInBackground:user.email
             password:user.email
             block:^(PFUser *_Nullable user, NSError *_Nullable error) {
                if (error == nil) {
                    [self displayHomePage];
                }
            }];
        }
    }];
}

- (void)displayHomePage {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];

    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    [sceneDelegate changeRootViewController:viewController];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *_Nonnull action) {
    }];
    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
