import XCTest
import Nimble
import RxSwift
@testable import TransparentDataAccess

class WebGatewayTest: XCTestCase {
    
    func test_UserProfile_SuccessfulRequest(){
        let target = GitHub.UserProfile("Rep2")
        var recievedModel: UserProfile?
        let gateway = WebGateway()
        
        waitUntil(timeout: 30, action: { done in
            _ = gateway.getResource(target).subscribeNext{ (model: UserProfile) in
                    recievedModel = model
                    done()
                }
        })
        
        expect(recievedModel).toNot(beNil())
    }

    func test_UserProfile_WebGateway(){
        let target = GitHub.UserProfile("Rep2")
        let gateway = WebGateway()

        let _ : Observable<UserProfile> = gateway.getResource(target)
    }

    func test_UserProfile_NoUserError(){
        let target = GitHub.UserProfile("Rep2123121")
        var recievedError: ErrorType?
        let gateway = WebGateway()
        
        waitUntil(timeout: 30, action: { done in
            _ = (gateway.getResource(target) as Observable<UserProfile>).subscribeError{ (error) in
                recievedError = error
                done()
            }
        })
        
        expect(recievedError).toNot(beNil())
    }

}