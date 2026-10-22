import XCTest
@testable import MobDevIosKino

final class MockGetFilmFactsUseCase: GetFilmFactsUseCase {
    var result: Result<[FunFactModel], Error> = .success([])
    var getFactsWasCalled = false
    
    func getFacts(filmId : Int) async throws -> [FunFactModel] {
        getFactsWasCalled = true    // проверка взаимодействия
        return try result.get()    // извлекаем результат из result
    }
}

final class MockSaveViewedFunFactUseCase: SaveViewedFunFactUseCase {
    var saveWasCalled = false
    
    func execute(
        filmId: Int,
        filmTitle: String,
        fact: FunFactModel
    ) async throws {
        saveWasCalled = true
    }
}

final class MockGetViewedFactsUseCase: GetViewedFactsUseCase {
    var result: Result<[ViewedFunFactModel], Error> = .success([])
    
    func execute() async throws -> [ViewedFunFactModel] {
        try result.get()
    }
}

/// Unit-тесты для FunFactViewModel`
@MainActor
final class FunFactViewModelTests: XCTestCase {
    
    private var getFactsMock: MockGetFilmFactsUseCase!
    private var saveFactMock: MockSaveViewedFunFactUseCase!
    private var getViewedMock: MockGetViewedFactsUseCase!
    private var viewModel: FunFactViewModel!
    
    let settings = UserDefaultsSettings()
    
    override func setUp() {
        super.setUp()
        
        getFactsMock = MockGetFilmFactsUseCase()
        saveFactMock = MockSaveViewedFunFactUseCase()
        getViewedMock = MockGetViewedFactsUseCase()
        
        viewModel = FunFactViewModel(
            getFilmFacts: getFactsMock,
            filmId: 123,
            filmTitle: "Тестовый фильм",
            settings: settings,
            saveViewedFact: saveFactMock,
            getViewedFacts: getViewedMock
        )
        
        settings.hideSpoilers = false
    }
    
    override func tearDown() {
        viewModel = nil
        getFactsMock = nil
        saveFactMock = nil
        getViewedMock = nil
        
        settings.hideSpoilers = false
        
        super.tearDown()
    }
    
    // Unit test-1. Успешная загрузка факта
    func testSuccessfulLoad() async {
        // arrange
        let fact = FunFactModel(
            text: "Тестовый факт",
            type: .fact,
            isSpoiler: false
        )
        
        // задаём mock ответ
        getFactsMock.result = .success([fact])
        
        
        // act
        await viewModel.load()
        
        // assert
        XCTAssertTrue(getFactsMock.getFactsWasCalled)
        
        XCTAssertEqual(viewModel.state, .loaded(fact))
        
        // факт передан на сохранение
        XCTAssertTrue(saveFactMock.saveWasCalled)
    }
    
    // Unit test-2. Загрузка факта из кэша, когда сервер недоступен
    func testCachedFactLoad() async {
        // arrange: сервер возвращает HTTP 500
        getFactsMock.result = .failure(
            NetworkError.server(statusCode: 500)
        )
        
        // в локальном хранилище есть сохранённый факт
        let cachedFact = ViewedFunFactModel(
            id: 100,
            filmId: 123,
            text: "Сохранённый факт",
            filmTitle: "Тестовый фильм",
            type: .fact,
            isSpoiler: false,
            viewedAt: Date()
        )
        
        getViewedMock.result = .success([cachedFact])
        
        // act
        await viewModel.load()
        
        // assert - попытка загрузки с сервера была
        XCTAssertTrue(getFactsMock.getFactsWasCalled)
        
        // ViewModel использовала локальные данные
        XCTAssertEqual(
            viewModel.state,
            .loaded(
                FunFactModel(
                    text: "Сохранённый факт",
                    type: .fact,
                    isSpoiler: false
                )
            )
        )
        
        // повторно сохранять факт не нужно
        XCTAssertFalse(saveFactMock.saveWasCalled)
    }
    
    // Unit test-3. Фильтрация спойлеров
    func testHideSpoilers() async {
        // arrange
        settings.hideSpoilers = true // Пользователь выбрал, что скрываем спойлеры

        let spoiler = FunFactModel(
            text: "Спойлер",
            type: .fact,
            isSpoiler: true
        )
        
        let normalFact = FunFactModel(
            text: "Обычный факт",
            type: .fact,
            isSpoiler: false
        )
        
        getFactsMock.result = .success([spoiler, normalFact])
        
        // act
        await viewModel.load()
        
        // assert
        XCTAssertEqual(viewModel.state, .loaded(normalFact)) // ViewModel должна выбрать НЕ спойлер
    }
}
