@import HCSStarRatingView;
@import TTGTagCollectionView;
@import DGActivityIndicatorView;
#import "ProfessorViewController.h"
#import "ComposeViewController.h"
#import "InfiniteScrollActivityView.h"
#import "Networker.h"
#import "ReviewCell.h"

static int queryLimitIncrement = 10;

@interface ProfessorViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, TTGTextTagCollectionViewDelegate, ComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *professorName;
@property (nonatomic, strong) IBOutlet UILabel *departmentName;
@property (nonatomic, strong) IBOutlet HCSStarRatingView *averageRating;
@property (nonatomic, strong) NSArray<Course *> *courses;
@property (nonatomic, strong) NSMutableSet<Course *> *selectedCourses;
@property (nonatomic, strong) NSArray<Review *> *reviews;
@property (nonatomic, strong) InfiniteScrollActivityView *loadingMoreView;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) BOOL loadingMoreReviews;
@property (nonatomic, assign) int queryLimit;
@property (nonatomic) PFQuery *query;

@end

@implementation ProfessorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.queryLimit = queryLimitIncrement;
    self.reviewCache = [NSCache new];

    [self setUpInfiniteScrollView];

    [self setProfessorDetails];

    [self setUpActivityIndicator];
    [self setUpRefreshControl];

    [self fetchCoursesAndReviews];
}

- (void)setProfessorDetails {
    self.professorName.text = self.professor.name;
    self.departmentName.text = self.professor.departmentName;
    self.averageRating.value = [self.professor.averageRating doubleValue];
}

- (void)fetchCoursesAndReviews {
    self.courses = [self sortedCourses];
    self.selectedCourses = [NSMutableSet new];

    [self displayCourseTags];

    [self fetchReviewsForTagChange]; // TODO: show activity indicator
}

- (void)fetchReviewsWithLimit:(int)limit
               withCompletion:(void (^)(NSArray<Review *> *_Nullable objects,
                                        NSError *_Nullable error))completion {
    self.query = [Networker fetchReviewsForProfessor:self.professor
                                          forCourses:self.selectedCourses
                                               limit:limit
                                      withCompletion:completion];
}

- (void)fetchReviewsForRefresh {
    if (self.query) {
        [self cancelQuery];
    }

    [self.activityIndicator startAnimating];

    __weak typeof(self) weakSelf = self;

    [self fetchReviewsWithLimit:self.queryLimit
                 withCompletion:^(NSArray<Review *> *_Nullable objects,
                                  NSError *_Nullable error) {
        __strong __typeof(self) strongSelf = weakSelf;

        strongSelf.reviews = objects;

        [strongSelf.tableView reloadData];
        [strongSelf.tableView.refreshControl endRefreshing];
        [strongSelf.activityIndicator stopAnimating];

        strongSelf.averageRating.value = [strongSelf.professor.averageRating doubleValue];

        strongSelf.query = nil;
    }];
}

- (void)fetchReviewsForInfiniteScroll {
    if (self.query) {
        [self cancelQuery];
    }

    NSArray<Review *> *reviews = [self.reviewCache objectForKey:self.selectedCourses];

    if (reviews.count >= self.queryLimit) {
        self.reviews = reviews;

        [self.tableView reloadData];
        [self.loadingMoreView stopAnimating];

        self.queryLimit = (int)reviews.count + queryLimitIncrement;
        self.loadingMoreReviews = NO;
    } else {
        __weak typeof(self) weakSelf = self;
        NSMutableSet<Course *> *selectedCourses = [self.selectedCourses copy];

        [self fetchReviewsWithLimit:self.queryLimit
                     withCompletion:^(NSArray<Review *> *_Nullable objects,
                                      NSError *_Nullable error) {
            __strong __typeof(self) strongSelf = weakSelf;
            NSArray<Review *> *reviews = [objects mutableCopy];

            strongSelf.reviews = objects;

            [strongSelf.reviewCache setObject:reviews forKey:selectedCourses];

            [strongSelf.tableView reloadData];
            [strongSelf.loadingMoreView stopAnimating];

            strongSelf.loadingMoreReviews = NO;

            strongSelf.query = nil;
        }];
    }
}

- (void)fetchReviewsForTagChange {
    if (self.query) {
        [self cancelQuery];
    }

    NSArray<Review *> *reviews = [self.reviewCache objectForKey:self.selectedCourses];

    if (self.selectedCourses.count == 0) {
        self.reviews = @[];
        [self.tableView reloadData];
    } else if (reviews) {
        self.reviews = reviews;
        [self.tableView reloadData];
    } else {
        [self.activityIndicator startAnimating];

        __weak typeof(self) weakSelf = self;
        NSMutableSet<Course *> *selectedCourses = [self.selectedCourses copy];

        [self fetchReviewsWithLimit:50
                     withCompletion:^(NSArray<Review *> *_Nullable objects,
                                      NSError *_Nullable error) {
            __strong __typeof(self) strongSelf = weakSelf;
            NSArray<Review *> *reviews = [objects mutableCopy];

            strongSelf.reviews = objects;

            [strongSelf.tableView reloadData];
            [strongSelf.tableView.refreshControl endRefreshing];
            [strongSelf.activityIndicator stopAnimating];

            [strongSelf.reviewCache setObject:reviews forKey:selectedCourses];

            strongSelf.query = nil;
        }];
    }
}

- (NSArray<NSString *> *)courseNames:(NSSet *)courses {
    NSMutableArray<NSString *> *courseNames = [NSMutableArray new];
    for (Course *course in courses) {
        [courseNames addObject:course.name];
    }
    return courseNames;
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(TTGTextTag *)tag
                      atIndex:(NSUInteger)index {
    Course *course = self.courses[index];

    if ([self.selectedCourses containsObject:course]) {
        [self.selectedCourses removeObject:course];
    } else {
        [self.selectedCourses addObject:course];
    }

    [self fetchReviewsForTagChange];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.loadingMoreReviews) {
         int scrollViewContentHeight = self.tableView.contentSize.height;
         int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height * 1.5;

         if(scrollView.contentOffset.y > scrollOffsetThreshold &&
            self.tableView.isDragging &&
            self.selectedCourses.count > 0) {
             self.loadingMoreReviews = YES;
             self.queryLimit += queryLimitIncrement;

             [self displayInfiniteScrollView];

             [self fetchReviewsForInfiniteScroll];
         }
    }
}

- (void)setUpInfiniteScrollView {
    CGRect frame = CGRectMake(0,
                              self.tableView.contentSize.height,
                              self.tableView.bounds.size.width,
                              InfiniteScrollActivityView.defaultHeight);
        self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
        self.loadingMoreView.hidden = true;
        [self.tableView addSubview:self.loadingMoreView];

        UIEdgeInsets insets = self.tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        self.tableView.contentInset = insets;
}

- (void)displayInfiniteScrollView {
    CGRect frame = CGRectMake(0,
                              self.tableView.contentSize.height,
                              self.tableView.bounds.size.width,
                              InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView.frame = frame;
    [self.loadingMoreView startAnimating];
}

- (void)displayCourseTags {
    TTGTextTagCollectionView *courseSelectionView = [self setUpTagCollectionView];
    [self.tableView addSubview:courseSelectionView];

    TTGTextTagStyle *unselectedStyle = [self
                                        setUpTagStyleWithColor:[UIColor lightGrayColor]];
    TTGTextTagStyle *selectedStyle = [self
                                      setUpTagStyleWithColor:[UIColor systemTealColor]];

    for (Course *course in self.courses) {
        TTGTextTag *courseTag = [TTGTextTag
                                 tagWithContent:[TTGTextTagStringContent
                                                 contentWithText:course.name]
                                 style:unselectedStyle];

        [courseTag setSelectedStyle:selectedStyle];
        [courseTag setSelected:YES];

        [self.selectedCourses addObject:course];

        [courseSelectionView addTag:courseTag];
    }
}

- (TTGTextTagCollectionView *)setUpTagCollectionView {
    TTGTextTagCollectionView *tagCollectionView =
    [[TTGTextTagCollectionView alloc]
     initWithFrame:CGRectMake(20, 127, 350, 64)];

    tagCollectionView.delegate = self;
    tagCollectionView.alignment = TTGTagCollectionAlignmentCenter;

    return tagCollectionView;
}

- (TTGTextTagStyle *)setUpTagStyleWithColor:(UIColor *)color {
    TTGTextTagStyle *style = [TTGTextTagStyle new];

    style.backgroundColor = color;
    style.shadowColor = [UIColor clearColor];
    style.shadowOffset = CGSizeMake(0, 0);
    style.shadowRadius = 0;
    style.borderWidth = 0;
    style.extraSpace = CGSizeMake(10, 5);

    return style;
}

- (void)didTapSubmit {
    [self fetchReviewsForRefresh];
}

- (void)setUpActivityIndicator {
    CGFloat width = self.view.bounds.size.width / 5.0f;
    self.activityIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotateMultiple tintColor:[UIColor systemTealColor] size:width];

    self.activityIndicator.frame = CGRectMake(self.view.center.x - width / 2, self.view.center.y - width / 2, width, width);

    [self.view addSubview:self.activityIndicator];
}

- (void)setUpRefreshControl {
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];

    [self.tableView.refreshControl addTarget:self
                                      action:@selector(fetchReviewsForRefresh)
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

- (NSArray *)sortedCourses {
    return [self.professor.courses sortedArrayUsingComparator:^
                    NSComparisonResult(Course *_Nonnull course1,
                                       Course *_Nonnull course2) {
        return [course1.name compare:course2.name];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *viewController = (ComposeViewController *)navigationController.topViewController;

    viewController.delegate = self;
    viewController.professor = self.professor;
}

- (void)cancelQuery {
    [self.query cancel];
    self.query = nil;
    [self.tableView.refreshControl endRefreshing];
    [self.loadingMoreView stopAnimating];
    [self.activityIndicator stopAnimating];
    self.loadingMoreReviews = NO;
}

@end
