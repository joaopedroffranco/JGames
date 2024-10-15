import XCTest
@testable import JData

/// Tests for the `ForecastService`.
///
/// This suite verifies that the service correctly decodes a `Forecast` object from various possible JSON responses.
final class ForecastServiceTests: XCTestCase {
	func testRegularResponse() throws {
		// given
		let service = ForecastService(dataSource: FakeDataSource(jsonFile: JSONFile.regular))
		
		// when
		var expectedResponse: Forecast?
		service.fetch(latitude: .zero, longitude: .zero)
			.sink(receiveValue: { response in
				expectedResponse = response
			})
			.cancel()
		
		// then
		XCTAssertEqual(
			expectedResponse,
			.init(
				id: 100,
				current: .init(
					temperature: .init(value: 17.3, feelsLike: 16.3, min: 13, max: 15.8),
					wind: .init(degrees: 181, speed: 8.3),
					condition: .init(iconUrl: URL(string: "https://image.png")!, label: "Light rain"),
					rainPrecipitation: 0.79,
					snowPrecipitation: 0.12
				),
				warnings: [
					.init(
						headline: "Flood Warning issued",
						instruction: "A Flood Warning means"
					)
				]
			)
		)
	}
	
	func testRegularResponseWithNoPrecipitationAndAlerts() throws {
		// given
		let service = ForecastService(dataSource: FakeDataSource(jsonFile: JSONFile.regularNoPrecipitationAndAlerts))
		
		// when
		var expectedResponse: Forecast?
		service.fetch(latitude: .zero, longitude: .zero)
			.sink(receiveValue: { response in
				expectedResponse = response
			})
			.cancel()
		
		// then
		XCTAssertEqual(
			expectedResponse,
			.init(
				id: 100,
				current: .init(
					temperature: .init(value: 17.3, feelsLike: 16.3, min: 13, max: 15.8),
					wind: .init(degrees: 181, speed: 8.3),
					condition: .init(iconUrl: URL(string: "https://image.png")!, label: "Light rain"),
					rainPrecipitation: nil,
					snowPrecipitation: nil
				),
				warnings: []
			)
		)
	}
	
	func testIrregularResponse() throws {
		// given
		let service = ForecastService(dataSource: FakeDataSource(jsonFile: JSONFile.irregular))
		
		// when
		var expectedResponse: Forecast?
		service.fetch(latitude: .zero, longitude: .zero)
			.sink(receiveValue: { response in
				expectedResponse = response
			})
			.cancel()
		
		// then
		XCTAssertNil(expectedResponse)
	}
	
	func testRegularResponseNoCondition() throws {
		// given
		let service = ForecastService(dataSource: FakeDataSource(jsonFile: JSONFile.regularNoCondition))
		
		// when
		var expectedResponse: Forecast?
		service.fetch(latitude: .zero, longitude: .zero)
			.sink(receiveValue: { response in
				expectedResponse = response
			})
			.cancel()
		
		// then
		XCTAssertNil(expectedResponse)
	}
	
	func testEmptyResponse() throws {
		// given
		let service = ForecastService(dataSource: FakeDataSource(jsonFile: JSONFile.empty))
		
		// when
		var expectedResponse: Forecast?
		service.fetch(latitude: .zero, longitude: .zero)
			.sink(receiveValue: { response in
				expectedResponse = response
			})
			.cancel()
		
		// then
		XCTAssertNil(expectedResponse)
	}
}
