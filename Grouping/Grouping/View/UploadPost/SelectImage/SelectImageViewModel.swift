//
//  SelectImageViewModel.swift
//  Grouping
//
//  Created by J_Min on 2023/07/15.
//

import Foundation

protocol SelectImageViewModelInterface: ObservableObject {
    var images: [String] { get set }
    var selectedImageIndexes: [(index: Int, number: Int)] { get set }
    
    func select(index: Int)
    func getSelectImageNumbers(index: Int) -> Int?
}

final class SelectImageViewModel: SelectImageViewModelInterface {
    @Published var images: [String] = [
        "test_image_1",
        "test_image_2",
        "test_image_3",
        "test_image_4",
        "test_image_5",
        "test_image_6",
    ]
    @Published var selectedImageIndexes: [(index: Int, number: Int)] = [] {
        didSet {
            if selectedImageIndexes.count > 5 {
                selectedImageIndexes.removeLast()
                lastNumber -= 1
            }
        }
    }
    private var lastNumber: Int = 0
    
    deinit {
        print("SelectImageViewModel", #function)
    }
    
    func select(index: Int) {
        let isContains = selectedImageIndexes.contains {
            $0.index == index
        }
        if isContains {
            // TODO: - 제거
            deSelect(index: index)
        } else {
            // TODO: - 추가
            selectedImageIndexes.append((index, lastNumber + 1))
            lastNumber += 1
        }
    }
    
    private func deSelect(index: Int) {
        let arrayIndex = selectedImageIndexes.firstIndex {
            $0.index == index
        }
        guard let arrayIndex = arrayIndex else {
            return
        }
        
        let range: ClosedRange<Int> = arrayIndex...selectedImageIndexes.count - 1
        let numberChangeImages = selectedImageIndexes[range]
            .map {
                var v = $0
                v.number -= 1
                return v
            }
        
        selectedImageIndexes.replaceSubrange(range, with: numberChangeImages)
        selectedImageIndexes.removeAll {
            $0.index == index
        }
        lastNumber -= 1
    }
    
    func getSelectImageNumbers(index: Int) -> Int? {
        let index = selectedImageIndexes.firstIndex {
            index == $0.index
        }
        
        if index == nil {
            return nil
        } else {
            return selectedImageIndexes[index!].number
        }
    }
}
