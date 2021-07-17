@import FBSDKLoginKit;
#import "SceneDelegate.h"
#import "Parse/Parse.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

        NSString *path = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

        NSString *applicationId = [dict objectForKey:@"applicationId"];
        NSString *clientKey = [dict objectForKey:@"clientKey"];

        configuration.applicationId = applicationId;
        configuration.clientKey = clientKey;
        configuration.server = @"https://parseapi.back4app.com";
    }];

    [Parse initializeWithConfiguration:config];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    if (PFUser.currentUser || FBSDKAccessToken.currentAccessTokenIsActive) {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    } else {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    }
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
  UIOpenURLContext *context = URLContexts.allObjects.firstObject;
  [FBSDKApplicationDelegate.sharedInstance application:UIApplication.sharedApplication
                                               openURL:context.URL
                                     sourceApplication:context.options.sourceApplication
                                            annotation:context.options.annotation];
}

- (void)changeRootViewController:(UIViewController *)viewController {
    self.window.rootViewController = viewController;

    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:nil completion:nil];
}

@end
