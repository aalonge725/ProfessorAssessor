#import "ProfessorSelectionViewController.h"
#import "ProfessorSelectionCell.h"
#import "Networker.h"
#import "School.h"

@interface ProfessorSelectionViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray<Professor *> *professors;
@property (nonatomic, strong) NSArray<Professor *> *filteredProfessors;

@end

@implementation ProfessorSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchProfessors];

    [self setUpRefreshControl];
}

- (void)fetchProfessors {
    __weak typeof(self) weakSelf = self;

    [Networker
     fetchSchoolAndProfessorsWithCompletion:^(
                                              PFObject *_Nullable object,
                                              NSError *_Nonnull error) {
        if (object) {
            __strong __typeof(self) strongSelf = weakSelf;

            School *school = [School schoolFromPFObject:object];

            NSArray<Professor *> *professors = school.professors;
            strongSelf.professors = [professors
                                   sortedArrayUsingComparator:
                                   ^NSComparisonResult(Professor *_Nonnull professor1,
                                                       Professor *_Nonnull professor2) {
                return [professor1.name compare:professor2.name];
            }];
            strongSelf.filteredProfessors = strongSelf.professors;

            [strongSelf.tableView reloadData];
            [strongSelf.tableView.refreshControl endRefreshing];
        }
    }];

}

- (void)setUpRefreshControl {
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];

    [self.tableView.refreshControl addTarget:self
                                      action:@selector(fetchProfessors)
                            forControlEvents:UIControlEventValueChanged];

    [self.tableView insertSubview:self.tableView.refreshControl atIndex:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredProfessors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfessorSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfessorSelectionCell" forIndexPath:indexPath];

    Professor *professor = self.filteredProfessors[indexPath.row];
    [cell setProfessor:professor];

    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate
                                  predicateWithBlock:^
                                BOOL(id _Nullable evaluatedObject,
                                       NSDictionary<NSString *,id>
                                       *_Nullable bindings) {
            return [((Professor *)evaluatedObject).name containsString:searchText];
        }];
        self.filteredProfessors = [self.professors filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredProfessors = self.professors;
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Professor *professor = self.filteredProfessors[indexPath.row];

    [self.delegate didSelectProfessor:professor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

@end
