@import DGActivityIndicatorView;
#import "ComposeViewController.h"
#import "ProfessorSelectionViewController.h"
#import "CourseSelectionViewController.h"
#import "Networker.h"
#import "User.h"

static NSNumberFormatter *numberFormatter = nil;

@interface ComposeViewController () <ProfessorSelectionViewControllerDelegate, CourseSelectionViewControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UIView *nonContentViews;
@property (nonatomic, strong) IBOutlet UILabel *professorLabel;
@property (nonatomic, strong) IBOutlet UILabel *courseLabel;
@property (nonatomic, strong) IBOutlet UILabel *ratingLabel;
@property (nonatomic, strong) IBOutlet UILabel *reviewLabel;
@property (nonatomic, strong) IBOutlet UILabel *characterCountLabel;
@property (nonatomic, strong) IBOutlet UIButton *chooseProfessorButton;
@property (nonatomic, strong) IBOutlet UIButton *chooseCourseButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *submitButton;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicator;

- (IBAction)ratingViewChanged:(HCSStarRatingView *)sender;
- (IBAction)ratingFieldChanged:(UITextField *)sender;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self decorateViews];

    [self setUpActivityIndicator];

    if (self.professor) {
        self.professorName.text = self.professor.name;
    } else {
        [self viewsEnabled:NO];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self updateConstraints:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self updateConstraints:NO];
}

- (void)updateConstraints:(BOOL)moveViewsUp {
    [UIView animateWithDuration:0.3 animations:^{
        if (moveViewsUp) {
            self.nonContentViews.alpha = 0;
        } else {
            self.nonContentViews.alpha = 1;
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            CGFloat distance = self.reviewLabel.frame.origin.y - self.nonContentViews.frame.origin.y;
            CGRect contentViewFrame = self.contentView.frame;

            if (moveViewsUp) {
                [self.scrollView setContentOffset:CGPointMake(0, distance)];
            } else {
                [self.scrollView setContentOffset:CGPointMake(0, 0)];
            }
            [self.scrollView setScrollEnabled:!moveViewsUp];

            self.contentView.frame = contentViewFrame;
        }];
    }];
}

- (IBAction)submitReview:(UIBarButtonItem *)sender {
    if (self.course == nil) {
        [self presentAlertWithTitle:nil withMessage:@"Please select a course"];
    } else if (self.ratingField.text.length == 0) {
        [self presentAlertWithTitle:nil withMessage:@"Please enter a rating"];
    } else if (self.content.text.length == 0) {
        [self presentAlertWithTitle:nil withMessage:@"Please type your review of this professor"];
    } else {
        [self.activityIndicator startAnimating];
        self.contentView.userInteractionEnabled = NO;

        NSNumber *ratingValue = [NSNumber numberWithDouble:[self.ratingField.text doubleValue]];

        [Networker
         updateDatabaseForNewReviewWithProfessor:self.professor
         course:self.course
         content:self.content.text
         rating:ratingValue
         completion:^(BOOL succeeded, NSError *_Nullable error) {
            if (error == nil) {
                [self.delegate didTapSubmit];

                [self.activityIndicator stopAnimating];
                self.contentView.userInteractionEnabled = YES;

                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

- (void)didSelectProfessor:(Professor *)professor {
    self.professor = professor;
    self.professorName.text = professor.name;
    self.courseName.text = @"(No course selected)";
    self.course = nil;

    [self viewsEnabled:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectCourse:(Course *)course {
    self.course = course;
    self.courseName.text = course.name;

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)close:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewsEnabled:(BOOL)enabled {
    self.courseLabel.enabled = enabled;
    self.ratingLabel.enabled = enabled;
    self.reviewLabel.enabled = enabled;

    self.chooseCourseButton.enabled = enabled;
    self.rating.enabled = enabled;
    self.ratingField.enabled = enabled;
    self.content.userInteractionEnabled = enabled;
    self.submitButton.enabled = enabled;
}

- (void)setUpActivityIndicator {
    CGFloat width = self.view.bounds.size.width / 5.0f;
    self.activityIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotateMultiple tintColor:[UIColor systemTealColor] size:width];

    self.activityIndicator.frame = CGRectMake(self.view.center.x - width / 2, self.view.center.y - width / 2, width, width);

    [self.view addSubview:self.activityIndicator];
}

- (IBAction)ratingViewChanged:(HCSStarRatingView *)sender {
    NSNumber *ratingValue = [NSNumber numberWithDouble:sender.value];

    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"0.#"];
    }

    self.ratingField.text = [numberFormatter stringFromNumber:ratingValue];
}

- (IBAction)ratingFieldChanged:(UITextField *)sender {
    double ratingInput = [sender.text doubleValue];
    double ratingValue;

    if (ratingInput < 0.0) {
        ratingValue = 0.0;
    } else if (ratingInput > 5.0) {
        ratingValue = 5.0;
    } else {
        ratingValue = ratingInput;
    }

    self.rating.value = ratingValue;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 500;

    NSString *newText = [self.content.text
                         stringByReplacingCharactersInRange:range withString:text];

    if (newText.length <= characterLimit) {
        NSInteger charactersLeft = 500 - newText.length;
        self.characterCountLabel.text = [NSString
                                         stringWithFormat:@"%d",
                                         (int)charactersLeft];
        return true;
    } else {
        return false;
    }
}

- (IBAction)dismissKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)presentAlertWithTitle:(NSString *)title
                  withMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *_Nonnull action) {
    }];
    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)decorateViews {
    [self decorateButton:self.chooseProfessorButton];
    [self decorateButton:self.chooseCourseButton];
    [self decorateTextField:self.ratingField];
    [self decorateTextView:self.content];
}

- (void)decorateButton:(UIButton *)button {
    button.layer.borderWidth = 2.0f;
    button.layer.borderColor = [[UIColor colorNamed:@"DefaultBlue"] CGColor];
    button.layer.cornerRadius = 8;
    button.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)decorateTextField:(UITextField *)field {
    field.layer.borderWidth = 2.0f;
    field.layer.borderColor = [[UIColor colorNamed:@"Salmon"] CGColor];
    field.layer.cornerRadius = 8;
}

- (void)decorateTextView:(UITextView *)view {
    view.layer.borderWidth = 2.0f;
    view.layer.borderColor = [[UIColor colorNamed:@"Salmon"] CGColor];
    view.layer.cornerRadius = 8;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];

    if ([segue.identifier isEqual:@"professorSelectionSegue"]) {
        ProfessorSelectionViewController *viewController = (ProfessorSelectionViewController *)navigationController.topViewController;

        viewController.delegate = self;
    } else if ([segue.identifier isEqual:@"courseSelectionSegue"]) {
        CourseSelectionViewController *viewController = (CourseSelectionViewController *)navigationController.topViewController;

        viewController.delegate = self;
        viewController.professor = self.professor;
    }

}

@end
