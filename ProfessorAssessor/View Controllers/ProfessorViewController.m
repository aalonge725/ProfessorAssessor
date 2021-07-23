@import HCSStarRatingView;
@import TTGTagCollectionView;
#import "ProfessorViewController.h"
#import "Networker.h"
#import "ReviewCell.h"
#import "Professor.h"
#import "Course.h"
#import "Review.h"

@interface ProfessorViewController () <UITableViewDataSource, UITableViewDelegate, TTGTextTagCollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *professorName;
@property (nonatomic, strong) IBOutlet UILabel *departmentName;
@property (nonatomic, strong) IBOutlet HCSStarRatingView *averageRating;
@property (nonatomic, strong) NSArray<Course *> *courses;
@property (nonatomic, strong) NSArray<Course *> *selectedCourses;
@property (nonatomic, strong) NSArray<Review *> *reviews;

@end

@implementation ProfessorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setProfessorDetails];

    self.selectedCourses = self.professor.courses;
    [self fetchCoursesAndReviews];

    [self setUpRefreshControl];
}

- (void)setProfessorDetails {
    self.professorName.text = self.professor.name;
    self.departmentName.text = self.professor.departmentName;
    self.averageRating.value = [self.professor.averageRating doubleValue];
}

- (void)fetchCoursesAndReviews {
    self.courses = [self.professor.courses sortedArrayUsingComparator:^
                    NSComparisonResult(Course *_Nonnull course1,
                                       Course *_Nonnull course2) {
        return [course1.name compare:course2.name];
    }];

    [self fetchReviews];
}

- (void)fetchReviews {
    __weak typeof(self) weakSelf = self;

    [Networker
     fetchReviewsForProfessor:weakSelf.professor
     forCourses:weakSelf.selectedCourses
     withCompletion:^(NSArray<Review *> *_Nullable objects,
                      NSError *_Nullable error) {
        if (objects) {
            weakSelf.reviews = objects;

            [weakSelf.tableView reloadData];
            [weakSelf.tableView.refreshControl endRefreshing];
        }
    }];
}

- (void)setUpRefreshControl {
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];

    [self.tableView.refreshControl addTarget:self
                                      action:@selector(fetchCoursesAndReviews)
                            forControlEvents:UIControlEventValueChanged];

    [self.tableView insertSubview:self.tableView.refreshControl atIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReviewCell *cell = [tableView
                        dequeueReusableCellWithIdentifier:@"ReviewCell"
                        forIndexPath:indexPath];

    Review *review = self.reviews[indexPath.row];
    [cell setReview:review];

    return cell;
}

@end
