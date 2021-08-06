@import Parse;
#import "ReviewCell.h"
#import "Course.h"
#import "User.h"

static NSDateFormatter *dateFormatter = nil;

@implementation ReviewCell

- (void)setReviewCell:(Review *)review {
    self.review = review;
    self.courseName.text = review.course.name;
    self.rating.value = [review.rating doubleValue];
    self.content.text = review.content;

    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }

    self.date.text = [dateFormatter
                      stringFromDate:review.createdAt];

    self.likes.text = [review.likes stringValue];
    self.dislikes.text = [review.dislikes stringValue];

    User *user = [User currentUser];

    [self.likeButton setSelected:[user.likedReviews containsObject:review]];
    [self.dislikeButton setSelected:[user.dislikedReviews containsObject:review]];
}

- (IBAction)like:(UIButton *)sender {
    [self checkForLikeOrUnlike];
}

- (IBAction)dislike:(UIButton *)sender {
    [self checkForDislikeOrUndislike];
}

- (void)checkForLikeOrUnlike {
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    BOOL shouldLikeReview = YES;
    BOOL shouldUndislikeReview = NO;

    if (!self.likeButton.selected) {
        self.review.likes = [NSNumber numberWithInt:[self.review.likes intValue] + 1];

        if (self.dislikeButton.selected) {
            self.review.dislikes = [NSNumber numberWithInt:[self.review.dislikes intValue] - 1];
            shouldUndislikeReview = YES;
        }
    } else {
        self.review.likes = [NSNumber numberWithInt:[self.review.likes intValue] - 1];
        shouldLikeReview = NO;
    }

    [self updateDatabaseAfterLike:shouldLikeReview shouldUndislike:shouldUndislikeReview];
}

- (void)checkForDislikeOrUndislike {
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    BOOL shouldDislikeReview = YES;
    BOOL shouldUnlikeReview = NO;

    if (!self.dislikeButton.selected) {
        self.review.dislikes = [NSNumber numberWithInt:[self.review.dislikes intValue] + 1];

        if (self.likeButton.selected) {
            self.review.likes = [NSNumber numberWithInt:[self.review.likes intValue] - 1];
            shouldUnlikeReview = YES;
        }
    } else {
        self.review.dislikes = [NSNumber numberWithInt:[self.review.dislikes intValue] - 1];
        shouldDislikeReview = NO;
    }

    [self updateDatabaseAfterDislike:shouldDislikeReview shouldUnlike:shouldUnlikeReview];
}

- (void)updateDatabaseAfterLike:(BOOL)shouldLike shouldUndislike:(BOOL)shouldUndislike {
    __weak typeof(self) weakSelf = self;

    [self.review saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;

        if (succeeded) {
            [strongSelf.likeButton setSelected:!strongSelf.likeButton.selected];
            strongSelf.likes.text = [strongSelf.review.likes stringValue];

            if (strongSelf.dislikeButton.selected) {
                [strongSelf.dislikeButton setSelected:!strongSelf.dislikeButton.selected];
                strongSelf.dislikes.text = [strongSelf.review.dislikes stringValue];
            }

            strongSelf.likeButton.enabled = YES;
            strongSelf.dislikeButton.enabled = YES;

            [strongSelf updateUserLikedReviews:shouldLike shouldUndislike:shouldUndislike];
        }
    }];
}

- (void)updateDatabaseAfterDislike:(BOOL)shouldDislike shouldUnlike:(BOOL)shouldUnlike {
    __weak typeof(self) weakSelf = self;

    [self.review saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;

        if (succeeded) {
            [strongSelf.dislikeButton setSelected:!strongSelf.dislikeButton.selected];
            strongSelf.dislikes.text = [strongSelf.review.dislikes stringValue];

            if (strongSelf.likeButton.selected) {
                [strongSelf.likeButton setSelected:!strongSelf.likeButton.selected];
                strongSelf.likes.text = [strongSelf.review.likes stringValue];
            }

            strongSelf.likeButton.enabled = YES;
            strongSelf.dislikeButton.enabled = YES;

            [strongSelf updateUserDislikedReviews:shouldDislike shouldUnlike:shouldUnlike];
        }
    }];
}

- (void)updateUserLikedReviews:(BOOL)shouldLike shouldUndislike:(BOOL)shouldUndislike {
    User *user = [User currentUser];

    if (shouldLike) {
        [user addObject:self.review forKey:@"likedReviews"];
    } else {
        [user removeObject:self.review forKey:@"likedReviews"];;
    }

    if (shouldUndislike) {
        [user removeObject:self.review forKey:@"dislikedReviews"];
    }

    [user saveInBackground];
}

- (void)updateUserDislikedReviews:(BOOL)shouldDislike shouldUnlike:(BOOL)shouldUnlike {
    User *user = [User currentUser];

    if (shouldDislike) {
        [user addObject:self.review forKey:@"dislikedReviews"];
    } else {
        [user removeObject:self.review forKey:@"dislikedReviews"];
    }

    if (shouldUnlike) {
        [user removeObject:self.review forKey:@"likedReviews"];;
    }

    [user saveInBackground];
}

- (void)configureBackground {
    self.background.layer.shadowOpacity = 0.5;
    self.background.layer.shadowRadius = 5;
    self.background.layer.shadowOffset = CGSizeMake(0, 0);
    self.background.layer.shadowColor = [UIColor blackColor].CGColor;
    self.background.backgroundColor = [UIColor colorNamed:@"Lavender"];
    self.background.layer.cornerRadius = 10;
}

@end
