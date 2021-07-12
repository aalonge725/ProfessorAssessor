#import "SceneDelegate.h"
#import "Parse/Parse.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

        configuration.applicationId = @"2qBLOkwaoPNgW3eM2jmwKdzCwxrCS1Vi0WMBiHwY";
        configuration.clientKey = @"x14DUoLsbu24NCHBs6pUqZRYgQW2pBb5Ne6o21kf";
        configuration.server = @"https://parseapi.back4app.com";
    }];

    [Parse initializeWithConfiguration:config];

    if (PFUser.currentUser) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    }
}

@end
