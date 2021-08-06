#import "AuthenticationViewController.h"

@interface AuthenticationViewController ()

@property (strong, nonatomic) IBOutlet UIButton *logInButton;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *guestButton;

@end

@implementation AuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self decorateViews];
}

- (void)decorateViews {
    [self decorateButton:self.logInButton];
    [self decorateButton:self.signUpButton];
    [self decorateButton:self.guestButton];
}

- (void)decorateButton:(UIButton *)button {
    button.layer.borderWidth = 2.0f;
    button.layer.borderColor = [[UIColor colorNamed:@"DefaultBlue"] CGColor];
    button.layer.cornerRadius = 8;
    button.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
}

@end
