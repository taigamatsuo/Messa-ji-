//
//  PageViewController.swift
//  Messaji
//
//  Created by 松尾大雅 on 2020/10/08.
//  Copyright © 2020 litech. All rights reserved.
//

import UIKit
import os

class PageViewController: UIPageViewController {
    
    
    var pageViewControllers: [UIViewController] = []
    var nowPage: Int = 0
    //var currentPageでページ番号を管理
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self

        //インスタンス化
        let pageViewA = storyboard!.instantiateViewController(withIdentifier: "FirstView") as!
            ViewController
        let pageViewB = storyboard!.instantiateViewController(withIdentifier: "SecondView") as! SecondViewController
        let pageViewC = storyboard!.instantiateViewController(withIdentifier: "ThirdView") as!
            ThirdViewController
        let pageViewD = storyboard!.instantiateViewController(withIdentifier: "FourthView") as! FourthViewController
        pageViewControllers = [pageViewA, pageViewB, pageViewC, pageViewD]

        //最初に表示するページの指定
        self.setViewControllers([pageViewControllers[0]], direction: .forward, animated: true, completion: nil)
    }
}


extension PageViewController : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //全ページ数を返すメソッド
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllers.count
    }
    //現在のページを返すメソッド
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPage
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = pageViewControllers.firstIndex(of: viewController)
        if index == 0 {
            return nil
        } else {
            return pageViewControllers[index!-1]
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = pageViewControllers.firstIndex(of: viewController)
        if index == pageViewControllers.count - 1 {
            return nil
        } else {
            return pageViewControllers[index!+1]
        }
    }
}
