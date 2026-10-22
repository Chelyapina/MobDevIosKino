import XCTest

final class MobDevIosKinoUITests: XCTestCase {

    func test_tapFilm_opensDetail() {
        let app = XCUIApplication()
        app.launch()
        
        let firstFilm = app.buttons
        .matching(NSPredicate(format: "identifier BEGINSWITH 'filmList.film.'"))
        .firstMatch
        XCTAssertTrue(firstFilm.waitForExistence(timeout: 10))
        
        firstFilm.tap()
        XCTAssertTrue(app.descendants(matching:.any)["filmDetail.screen"]
            .waitForExistence(timeout: 5))
    }
    
    func test_searchTyping_showsCards() {
        let app = XCUIApplication()
        app.launch()

        let searchButton = app.buttons["filmList.search"]
        XCTAssertTrue(searchButton.waitForExistence(timeout: 10),
                      "Не нашли кнопку поиска на главном экране")
        searchButton.tap()

        XCTAssertTrue(app.descendants(matching: .any)["search.screen"].waitForExistence(timeout: 5),
                      "Экран поиска не открылся")

        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 5),
                      "Поле поиска не найдено")
        searchField.tap()
        searchField.typeText("матрица")

        let firstCard = app.descendants(matching: .any)
            .matching(NSPredicate(format: "identifier BEGINSWITH 'searchFilm.card.'"))
            .firstMatch
        XCTAssertTrue(firstCard.waitForExistence(timeout: 10),
                      "По запросу 'матрица' не появилось ни одной карточки")
       
    }
}
