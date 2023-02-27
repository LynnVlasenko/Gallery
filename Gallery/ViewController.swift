//
//  ViewController.swift
//  Gallery
//
//  Created by Алина Власенко on 24.02.2023.
//


import UIKit

class ViewController: UIViewController {

    let catImages: [UIImage?] = [
         UIImage(named: "cat1"),
         UIImage(named: "cat2"),
         UIImage(named: "cat3")
     ]

    // MARK: - UIElements
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.text = "Cats Gallery".uppercased()
        label.font = UIFont(name: "Roboto-Bold", size: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //додаємо можливість скролити
    private let scrollView = UIScrollView()

    //додаємо перемикач для слайдера (крапки, які показують на якому слайді поточна картинка)
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        //індикатор поточної сторінки - визначимо кількість гортаючих елементів - визначимося з кількістю крапок для слайдера
        pageControl.numberOfPages = 3 //помилка на catImages.count
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        return pageControl
    }()

   // private var pageForSlider = UIImageView()

    private let buttonPrev: UIButton = {
        let button = UIButton()
        button.setTitle("Prev".uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
        button.setTitleColor(.systemGray4, for: .highlighted)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(showPrevImg), for: .valueChanged)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let buttonNext: UIButton = {
        let button = UIButton()
        button.setTitle("Next".uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
        button.setTitleColor(.systemGray4, for: .highlighted)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(showNextImg), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let container: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.alignment = .fill
        container.spacing = 300 - (60 + 135) * 2
        container.distribution = .equalSpacing
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    private let buttonImgViewSwitcher: UIButton = {
        let button = UIButton()
        button.setTitle("Black & White".uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)
        button.setTitleColor(.systemGray4, for: .highlighted)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(switchImage), for: .valueChanged)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    // MARK: - viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.addTarget(self,
                              action: #selector(pageControlDidChanchge(_:)) ,
                              for: .valueChanged)
        //scrollView.backgroundColor = .red
        addSubviews()
        applyConstraints()
        scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //створемо фрейм для перегляду прокрутки
        scrollView.frame = CGRect(x: 10, y: buttonImgViewSwitcher.frame.size.height+120, width: view.frame.size.width-20, height: 400)
        //створемо фрейм для крапок перемикача
        pageControl.frame = CGRect(x: 10 , y: scrollView.frame.size.height+180, width: view.frame.size.width-20, height: 70)
        if scrollView.subviews.count == 2 { //чому ми використовуємо тут 2, так як вью за замовчуванням не має ніяких додаткових сабвью . Це тому, що режим прокручування (UIScrollView) за замовчуванням насправді має сабвью(додаткові перегляди). Якщо ми знайомі з (scrollIndicator)індикаторами прокручування - це маленька смужка збоку і знизу для прокрутки. Тож виходить, що як раз scrollView має 2 сабвью.
            //можемо викликати конфігуре
            configureScrollView()
        }
    }


    // MARK: - addSubviews

    private func addSubviews() {
        view.addSubview(titleLbl)
        view.addSubview(buttonImgViewSwitcher)
        view.addSubview(container)
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        //view.addSubview(pageForSlider)
        container.addArrangedSubview(buttonPrev)
        container.addArrangedSubview(buttonNext)
    }

    // MARK: - Functions for scroll
    
    //функція для налаштування вмісту перегляду прокрутки
    private func configureScrollView() {
        //прописуємо розмір вмісту для перегляду прокрутки
        scrollView.contentSize = CGSize(width: view.frame.size.width*3, height: scrollView.frame.size.height)
        //вмикаємо сторінку, яка фактично прив'язую кожну сторінку до всього екрана, а не дозволяє користувачу прокручувати наполовину між ними
        scrollView.isPagingEnabled = true
        //створимо масив кольорів для наших пейджів у циклі

//        let colors: [UIColor] = [
//            .systemGreen,
//            .systemOrange,
//            .systemPurple
//        ]
        for i in 0..<catImages.count {
            //в нашому випадку кожна сторінка буде виглядом інтерфейсу
            let page = UIImageView(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height-498)) //не розумію, що ми тут намутили з Х-ом
            //додаємо нашу сторінку на на наш скрол
            page.image = catImages[i]
            page.contentMode = .scaleAspectFit
            //page.backgroundColor = colors[i] //передаємо у колір наше число з перебраного ренджа - це буде індексом для нашого масиву і він покаже усі кольори за номером індекса.
            scrollView.addSubview(page)
        }
    }
    
    
    @objc private func pageControlDidChanchge(_ sender: UIPageControl) { //де відправник є елементом керування інтерфейсу
        //точка відправника на поточній сторінці
        let current = sender.currentPage
        //встановити зміщення вмісту, ми хочемо анімувати його до цієї сторінки
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }

    
    // MARK: - Functions for buttons
    

    //перейти на попередню картинку
    @objc func showPrevImg() {
        scrollView.contentSize = CGSize(width: view.frame.size.width*3, height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        for i in 0..<catImages.count {
            let page = UIImageView(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height-498))
            page.image = catImages[i]
            page.contentMode = .scaleAspectFit
            scrollView.addSubview(page)
        }
    }

    //перейти на наступну картинку
    @objc func showNextImg() {
        scrollView.contentSize = CGSize(width: view.frame.size.width*3, height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        for i in 0..<catImages.count {
            //в нашому випадку кожна сторінка буде виглядом інтерфейсу
            let page = UIImageView(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height-498)) //не розумію, що ми тут намутили з Х-ом
            //додаємо нашу сторінку на на наш скрол
            page.image = catImages[i]
            page.contentMode = .scaleAspectFit
            //page.backgroundColor = colors[i] //передаємо у колір наше число з перебраного ренджа - це буде індексом для нашого масиву і він покаже усі кольори за номером індекса.
            scrollView.addSubview(page)
        }
    }
    
    //переключати вигляд картинки у ч/б
    @objc func switchImage() {
        let context = CIContext()
        let filter = CIFilter(name:"CIColorControls")

        for i in 0..<catImages.count {
            let img = CIImage(image: catImages[i]!)
            filter?.setValue(img, forKey: kCIInputImageKey)
            filter?.setValue(0.0, forKey: kCIInputSaturationKey)
            let grayscaleCIImage = filter?.outputImage
            let cgOutputImage = context.createCGImage(grayscaleCIImage!, from: img!.extent)
        }
    }
    
    
    // MARK: - applyConstraints

    private func applyConstraints() {
        let titleLblConstratnts = [
            titleLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]

//        let scrollViewConstratnts = [
//            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
//            scrollView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 40)
//        ]
//
//        let pageControlConstratnts = [
//            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
//            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
//            pageControl.heightAnchor.constraint(equalToConstant: 70)
//        ]

        let buttonImgViewSwitcherConstratnts = [
            buttonImgViewSwitcher.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            buttonImgViewSwitcher.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonImgViewSwitcher.heightAnchor.constraint(equalToConstant: 70),
            buttonImgViewSwitcher.widthAnchor.constraint(equalToConstant: 300)
        ]

        let containerConstraints = [
            container.bottomAnchor.constraint(equalTo: buttonImgViewSwitcher.topAnchor, constant: -40),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.heightAnchor.constraint(equalToConstant: 60),
            container.widthAnchor.constraint(equalToConstant: 300)
        ]

        let buttonPrevConstraints = [
            buttonPrev.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            buttonPrev.heightAnchor.constraint(equalToConstant: 60),
            buttonPrev.widthAnchor.constraint(equalToConstant: 135)
        ]

        let buttonNextConstraints = [
            buttonNext.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            buttonNext.heightAnchor.constraint(equalToConstant: 60),
            buttonNext.widthAnchor.constraint(equalToConstant: 135)
        ]

        NSLayoutConstraint.activate(titleLblConstratnts)
//        NSLayoutConstraint.activate(scrollViewConstratnts)
//        NSLayoutConstraint.activate(pageControlConstratnts)
        NSLayoutConstraint.activate(buttonImgViewSwitcherConstratnts)
        NSLayoutConstraint.activate(containerConstraints)
        NSLayoutConstraint.activate(buttonPrevConstraints)
        NSLayoutConstraint.activate(buttonNextConstraints)
    }

}


// MARK: - Delegate

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //що разу коли scrollView прокручується ми хочемо обчислити на якій сторінці ми зараз
        //можемо сказати, що керування поточною сторінкою буде scrollView.contentOffset.x над scrollView.frame.size.width і ми хочемо, щоб це було округлено вниз і це будуть плаваючі крапки
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }
}




//Почала робити через UIPageViewController і тут же не спрацювало. бо setViewControllers просить вью контроттер, а не UIView..
//import UIKit
//
//class ViewController: UIPageViewController {
//
//    // external controls
//    private let titleLbl = UILabel()
//    var catImages = [UIImage?]()
//    private let pageControl = UIPageControl()
//    private let prevButton = UIButton()
//    private let nextButton = UIButton()
//    private let switchImgButton = UIButton()
//    let initialPage = 0
//
//    // animations
//    var prevButtonTopAnchor: NSLayoutConstraint?
//    var nextButtonTopAnchor: NSLayoutConstraint?
//    var pageControlBottomAnchor: NSLayoutConstraint?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setup()
//        style()
//        layout()
//    }
//}
//
//
//extension ViewController {
//
//    func setup() {
//        dataSource = self
//        delegate = self
//
//        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
//
//        let img1 = UIImage(named: "cat1")
//        let img2 = UIImage(named: "cat2")
//        let img3 = UIImage(named: "cat3")
//
//        catImages.append(img1)
//        catImages.append(img2)
//        catImages.append(img3)
//
//        setViewControllers([catImages[initialPage]], direction: .forward, animated: true, completion: nil)
//    }
//
//    func style() {
//        pageControl.translatesAutoresizingMaskIntoConstraints = false
//        pageControl.currentPageIndicatorTintColor = .black
//        pageControl.pageIndicatorTintColor = .systemGray2
//        pageControl.numberOfPages = pages.count
//        pageControl.currentPage = initialPage
//
//        skipButton.translatesAutoresizingMaskIntoConstraints = false
//        skipButton.setTitleColor(.systemBlue, for: .normal)
//        skipButton.setTitle("Skip", for: .normal)
//        skipButton.addTarget(self, action: #selector(skipTapped(_:)), for: .primaryActionTriggered)
//
//        nextButton.translatesAutoresizingMaskIntoConstraints = false
//        nextButton.setTitleColor(.systemBlue, for: .normal)
//        nextButton.setTitle("Next", for: .normal)
//        nextButton.addTarget(self, action: #selector(nextTapped(_:)), for: .primaryActionTriggered)
//    }
//
//    func layout() {
//        view.addSubview(pageControl)
//        view.addSubview(nextButton)
//        view.addSubview(skipButton)
//
//        NSLayoutConstraint.activate([
//            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
//            pageControl.heightAnchor.constraint(equalToConstant: 20),
//            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            skipButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
//
//            view.trailingAnchor.constraint(equalToSystemSpacingAfter: nextButton.trailingAnchor, multiplier: 2),
//        ])
//
//        // for animations
//        skipButtonTopAnchor = skipButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
//        nextButtonTopAnchor = nextButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
//        pageControlBottomAnchor = view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 2)
//
//        skipButtonTopAnchor?.isActive = true
//        nextButtonTopAnchor?.isActive = true
//        pageControlBottomAnchor?.isActive = true
//    }
//}
//

