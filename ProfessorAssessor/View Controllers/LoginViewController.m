@import FBSDKLoginKit;
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "HomeViewController.h"
#import "SchoolSelectionViewController.h"
#import "SignUpViewController.h"
#import "User.h"

@interface LoginViewController ()

@property (strong, nonatomic) NSDictionary *requestResult;

- (IBAction)login:(UIButton *)sender;
- (IBAction)continueWithFacebook:(UIButton *)sender;

@end

@implementation LoginViewController

- (IBAction)login:(UIButton *)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;

    if ([self validCredentials]) {
        [PFUser logInWithUsernameInBackground:username
                                     password:password
                                        block:^(PFUser *user, NSError *error) {
            if (error == nil) {
                [self displayHomePage];
            }
        }];
    }
}

- (IBAction)continueWithFacebook:(UIButton *)sender {
    FBSDKLoginManager *manager = [FBSDKLoginManager new];
    FBSDKLoginConfiguration *configuration = [[FBSDKLoginConfiguration alloc] initWithPermissions:@[@"public_profile", @"email"] tracking:FBSDKLoginTrackingEnabled];

    [self displayFacebookLoginWithManager:manager withConfiguration:configuration];
}

- (void)displayFacebookLoginWithManager:(FBSDKLoginManager *)manager
                      withConfiguration:(FBSDKLoginConfiguration *)configuration {
    [manager logInFromViewController:self
                       configuration:configuration
                          completion:^(FBSDKLoginManagerLoginResult *_Nullable result, NSError *_Nullable error) {
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
    [request startWithCompletion:^(id<FBSDKGraphRequestConnecting> _Nullable connection, id _Nullable result, NSError *_Nullable error) {
        if (result) {
            self.requestResult = @{@"first_name":result[@"first_name"], @"last_name":result[@"last_name"], @"email":result[@"email"]};
            NSString *email = result[@"email"];

            [self handleFacebookLoginWithEmail:email];
        }
    }];
}

- (void)handleFacebookLoginWithEmail:(NSString *)email {
    PFQuery *userQuery = [User query];

    [userQuery whereKey:@"email" equalTo:email];

    [userQuery countObjectsInBackgroundWithBlock:^(int count, NSError *_Nullable error) {
        if (count == 0) {
            [self performSegueWithIdentifier:@"signUpSegue" sender:self];
        } else {
            [self displayHomePage];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SignUpViewController *viewController = [segue destinationViewController];

    viewController.requestResult = self.requestResult;
}

@end
