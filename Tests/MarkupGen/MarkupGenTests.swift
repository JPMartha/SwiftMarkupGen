import XCTest
@testable import MarkupGen

class MarkupGenTests: XCTestCase {
    func testBasic() throws {
        let gen = try parseFunction(funcString: "func hello(a: Int, b: Double) {}")
        let theFunc = Function(name: "hello(a:b:)", params: ["a", "b"], returns: false, throws: false) 
        XCTAssertEqual(gen, theFunc)
    }

    func testBasicThrows() throws {
        let gen = try parseFunction(funcString: "func hello(a: Int, b: Double) throws {}")
        let theFunc = Function(name: "hello(a:b:)", params: ["a", "b"], returns: false, throws: true) 
        XCTAssertEqual(gen, theFunc)
    }

    func testBasicReturns() throws {
        let gen = try parseFunction(funcString: "func hello(a: Int, b: Double) -> SomeType {}")
        let theFunc = Function(name: "hello(a:b:)", params: ["a", "b"], returns: true, throws: false) 
        XCTAssertEqual(gen, theFunc)
    }

    func testBasicThrowsAndReturns() throws {
        let gen = try parseFunction(funcString: "func hello(a: Int, b: Double) throws -> Da {}")
        let theFunc = Function(name: "hello(a:b:)", params: ["a", "b"], returns: true, throws: true) 
        XCTAssertEqual(gen, theFunc)
    }

    func testGenericFunction() throws {
        let gen = try parseFunction(funcString: "@noreturn public func hello<T: where B: A>(a: Int, b: T, c: (AType)->()) throws -> T {}")
        let theFunc = Function(name: "hello(a:b:c:)", params: ["a", "b", "c"], returns: true, throws: true) 
        XCTAssertEqual(gen, theFunc)
    }

    func testLabels() throws {
        let gen = try parseFunction(funcString: "func hello(_ a: Int, boo b: Double, cool: Type) throws -> CoolType {}")
        let theFunc = Function(name: "hello(_:boo:cool:)", params: ["a", "boo", "cool"], returns: true, throws: true) 
        XCTAssertEqual(gen, theFunc)
    }

    func testIncomplete1() throws {
        let gen = try parseFunction(funcString: "func hello(a: Int, b: Type) throws {")
        let theFunc = Function(name: "hello(a:b:)", params: ["a", "b"], returns: false, throws: true) 
        XCTAssertEqual(gen, theFunc)
    }

    func testIncomplete2() throws {
        let gen = try parseFunction(funcString: "func hello(a: Int, b: Type) throws -> COol")
        let theFunc = Function(name: "hello(a:b:)", params: ["a", "b"], returns: true, throws: true) 
        XCTAssertEqual(gen, theFunc)
    }

    func testMultiLine() throws {
        let gen = try parseFunction(funcString: "func hello(a: Int\n, b: Double\n c: TheInt)\n throws -> COol")
        let theFunc = Function(name: "hello(a:b:c:)", params: ["a", "b", "c"], returns: true, throws: true) 
        XCTAssertEqual(gen, theFunc)
    }

    func testFirstDeclIsNotFunc() throws {
        let gen = try parseFunction(funcString: "class A {}\n class B{}\n struct C{} \nfunc hello(a: Int\n, b: Double\n c: TheInt)\n throws -> COol")
        let theFunc = Function(name: "hello(a:b:c:)", params: ["a", "b", "c"], returns: true, throws: true) 
        XCTAssertEqual(gen, theFunc)
    }
}
