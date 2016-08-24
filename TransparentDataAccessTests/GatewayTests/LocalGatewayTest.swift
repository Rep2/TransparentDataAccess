import XCTest
import RxSwift
import Unbox
import Nimble
@testable import TransparentDataAccess

class LocalGatewayTest: XCTestCase {

    func test_SimpleModel_GetResource(){
        let testModel = SimpleModel(data: "Test data")
        let target = ResourceTargetExample.EmptyTarget
        var recievedModel: SimpleModel?

        waitUntil { (done) in
            _ = LocalGateway(resources: [target.key : testModel]).getResource(target).subscribeNext { (model) in
                recievedModel = model
                done()
            }
        }

        expect(recievedModel).toNot(beNil())
        expect(recievedModel!.data).to(equal(testModel.data))
    }

    func test_SimpleModel_NoData(){
        let target = ResourceTargetExample.EmptyTarget
        var recievedError: GatewayError?

        waitUntil { (done) in
            _ = LocalGateway<SimpleModel>().getResource(target).subscribeError { (error) in
                if let error = error as? GatewayError{
                    recievedError = error
                    done()
                }
            }
        }

        expect(recievedError).to(equal(GatewayError.NoDataFor(key: target.key)))
    }

    func test_SimpleModel_SetResource(){
        let testModel = SimpleModel(data: "New test data")
        let target = ResourceTargetExample.EmptyTarget
        var gateway = LocalGateway<SimpleModel>(resources: [target.key : SimpleModel(data: "Old test data")])
        var recievedModel: SimpleModel?

        gateway.setResource(target, resource: testModel)

        waitUntil { (done) in
            _ = gateway.getResource(target).subscribeNext { (model) in
                recievedModel = model
                done()
            }
        }

        expect(recievedModel).toNot(beNil())
        expect(recievedModel!.data).to(equal(testModel.data))
    }

    func test_Token_GetResource(){
        let testModel = TwitterAccessToken(data: "test token")
        let target = ResourceTargetExample.Token(key: "key", secret: "secret")
        var recievedModel: TwitterAccessToken?

        waitUntil { (done) in
            _ = LocalGateway<TwitterAccessToken>(resources: [target.key : testModel]).getResource(target).subscribeNext { (model) in
                recievedModel = model
                done()
            }
        }

        expect(recievedModel).toNot(beNil())
        expect(recievedModel!.token).to(equal(testModel.token))
    }

    func test_Token_NoData(){
        var recievedError: GatewayError?
        let target = ResourceTargetExample.Token(key: "key", secret: "secret")

        waitUntil { (done) in
            _ = LocalGateway<TwitterAccessToken>().getResource(target).subscribeError { (error) in
                if let error = error as? GatewayError{
                    recievedError = error
                    done()
                }
            }
        }

        expect(recievedError).to(equal(GatewayError.NoDataFor(key: target.key)))
    }

    func test_Token_SetResource(){
        let testModel = TwitterAccessToken(data: "new token")
        let target = ResourceTargetExample.Token(key: "key", secret: "secret")
        var gateway = LocalGateway<TwitterAccessToken>(resources: [target.key : TwitterAccessToken(data: "old token")])
        var recievedModel: TwitterAccessToken?

        gateway.setResource(target, resource: testModel)


        waitUntil { (done) in
            _ = gateway.getResource(target).subscribeNext { (model) in
                recievedModel = model
                done()
            }
        }
        
        expect(recievedModel).toNot(beNil())
        expect(recievedModel!.token).to(equal(testModel.token))
    }
}
