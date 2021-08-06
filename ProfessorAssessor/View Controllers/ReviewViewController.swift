import UIKit
import HCSStarRatingView

@objc public class ReviewViewController: UIViewController {

    @IBOutlet var professorName: UILabel!
    @IBOutlet var courseName: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var content: UILabel!
    @IBOutlet var rating: HCSStarRatingView!

    @objc var review: Review!

    public override func viewDidLoad() {
        super.viewDidLoad()

        displayReview()
    }

    func displayReview() {
        professorName.text = review.professor?.name
        courseName.text = review.course?.name
        content.text = review.content
        rating.value = CGFloat(review.rating.doubleValue)

        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        date.text = formatter.string(from: review.createdAt)
    }

}
