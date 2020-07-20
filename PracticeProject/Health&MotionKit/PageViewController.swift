//
//  PageViewController.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 16/07/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import HealthKit

class PageViewController: UIPageViewController {
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        self.delegate = self
        self.dataSource = self
        
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "yellow")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "RunDetailsVC")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "pink")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([page2], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
    }
}

extension PageViewController: UIPageViewControllerDelegate,UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)!
        let previousIndex = currentIndex - 1
        return previousIndex >= 0 ? pages[previousIndex] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)!
        let nextIndex = currentIndex + 1
        return nextIndex < pages.count ? pages[nextIndex] : nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        let pageIndicator = UIPageControl.appearance()
        pageIndicator.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        pageIndicator.currentPageIndicatorTintColor = .black
        pageIndicator.pageIndicatorTintColor = .gray
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
