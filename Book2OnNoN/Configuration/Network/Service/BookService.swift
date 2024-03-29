//
//  BookService.swift
//  Book2OnNoN
//
//  Created by 여성일 on 3/12/24.
//

import Foundation
import RxSwift
import Alamofire

public struct BookService {
    func getBookSearchData(title: String, type:String, page: Int) -> Single<Result<Book, Error>>{
        return Single.create { single -> Disposable in
            AF.request(BookAPI.searchBook(title: title, type: type, page: page))
                .responseDecodable(of: Book.self) { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(.success(data)))
                    case .failure(let error):
                        single(.success(.failure(error)))
                    }
                }
            return Disposables.create()
        }
    }    
    
    func getBookSearchLookUpData(isbn: String) -> Single<Result<LookUp, Error>>{
        return Single.create { single -> Disposable in
            AF.request(BookAPI.lookUpBook(isbn: isbn))
                .responseDecodable(of: LookUp.self) { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(.success(data)))
                    case .failure(let error):
                        single(.success(.failure(error)))
                    }
                }
            return Disposables.create()
        }
    }
}
