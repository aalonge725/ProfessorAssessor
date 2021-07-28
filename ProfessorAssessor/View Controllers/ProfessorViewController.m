@import HCSStarRatingView;
@import TTGTagCollectionView;
#import "ProfessorViewController.h"
#import "ComposeViewController.h"
#import "InfiniteScrollActivityView.h"
#import "Networker.h"
#import "ReviewCell.h"
#import "Course.h"
#import "Review.h"

static int queryLimitIncrement = 10;

@interface ProfessorViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, TTGTextTagCollectionViewDelegate, ComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *professorName;
@property (nonatomic, strong) IBOutlet UILabel *departmentName;
@property (nonatomic, strong) IBOutlet HCSStarRatingView *averageRating;
@property (nonatomic, strong) NSArray<Course *> *courses;
@property (nonatomic, strong) NSMutableArray<Course *> *selectedCourses;
@property (nonatomic, strong) NSArray<Review *> *reviews;
@property (nonatomic, strong) InfiniteScrollActivityView *loadingMoreView;
@property (nonatomic, assign) BOOL loadingMoreReviews;
@property (nonatomic, assign) int queryLimit;

@end

@implementation ProfessorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.queryLimit = queryLimitIncrement;

    [self setUpInfiniteScrollView];

    [self setProfessorDetails];

    [self fetchCoursesAndReviews];

    [self setUpRefreshControl];
}

- (void)setProfessorDetails {
    self.professorName.text = self.professor.name;
    self.departmentName.text = self.professor.departmentName;
    self.averageRating.value = [self.professor.averageRating doubleValue];
}

- (void)fetchCoursesAndReviews {
    self.courses = [self sortedCourses];
    self.selectedCourses = [NSMutableArray new];

    [self displayCourseTags];

    [self fetchReviews];
}

- (void)fetchReviews { // TODO: use CacheElseNetwork cache policy
    __weak typeof(self) weakSelf = self;

    [Networker
     fetchReviewsForProfessor:weakSelf.professor
     forCourses:weakSelf.selectedCourses
     limit:weakSelf.queryLimit
     withCompletion:^(NSArray<Review *> *_Nullable objects,
                      NSError *_Nullable error) {
        if (objects) {
            __strong __typeof(self) strongSelf = weakSelf;

            strongSelf.loadingMoreReviews = NO;
            [strongSelf.loadingMoreView stopAnimating];

            strongSelf.reviews = objects;

            [strongSelf.tableView reloadData];
            [strongSelf.tableView.refreshControl endRefreshing];

            strongSelf.averageRating.value = [strongSelf.professor.averageRating doubleValue];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.loadingMoreReviews) {
         int scrollViewContentHeight = self.tableView.contentSize.height;
         int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height * 2;

         if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
             self.loadingMoreReviews = YES;
             self.queryLimit += queryLimitIncrement;

             [self displayUpdateInfiniteScrollView];

             [self fetchReviews];
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

- (void)displayUpdateInfiniteScrollView {
    CGRect frame = CGRectMake(0,
                              self.tableView.contentSize.height,
                              self.tableView.bounds.size.width,
                              InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView.frame = frame;
    [self.loadingMoreView startAnimating];
}

- (void)displayCourseTags { // TODO: make clear tags button
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

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(TTGTextTag *)tag
                      atIndex:(NSUInteger)index { // TODO: consider not fetching new reviews unless user refreshes (selecting/unselecting tag update tableView only, not reviews)
    Course *course = self.courses[index];

    if ([self.selectedCourses containsObject:course]) {
        [self.selectedCourses removeObject:course];

        [self fetchReviews];
    } else {
        [self.selectedCourses addObject:course];

        [self fetchReviews];
    }
}

- (void)didTapSubmit {
    [self fetchReviews];
}

- (void)setUpRefreshControl {
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];

    [self.tableView.refreshControl addTarget:self
                                      action:@selector(fetchReviews)
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

@end
