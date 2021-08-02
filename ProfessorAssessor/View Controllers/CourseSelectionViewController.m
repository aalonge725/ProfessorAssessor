#import "CourseSelectionViewController.h"
#import "CourseSelectionCell.h"

@interface CourseSelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<Course *> *courses;

@end

@implementation CourseSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchCourses];

    [self setUpRefreshControl];
}

- (void)fetchCourses {
    if (self.professor != nil) {
        self.courses = [self.professor.courses
                        sortedArrayUsingComparator:^
                        NSComparisonResult(Course *_Nonnull course1,
                                           Course *_Nonnull course2) {
            return [course1.name compare:course2.name];
        }];

        [self.tableView reloadData];
        [self.tableView.refreshControl endRefreshing];
    }
}

- (void)setUpRefreshControl {
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];

    [self.tableView.refreshControl addTarget:self
                                      action:@selector(fetchCourses)
                            forControlEvents:UIControlEventValueChanged];

    [self.tableView insertSubview:self.tableView.refreshControl atIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseSelectionCell" forIndexPath:indexPath];

    Course *course = self.courses[indexPath.row];
    [cell setCourse:course];
    [cell configureBackground];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Course *course = self.courses[indexPath.row];

    [self.delegate didSelectCourse:course];
}

@end
