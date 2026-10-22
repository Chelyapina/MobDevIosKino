enum NetworkError: Error {
    case invalidURL
    case noConnection
    case server(statusCode: Int)
    case decoding
    case unknown
    case timeout
}

extension NetworkError {
    var userMessage: String {
        switch self {
        case .invalidURL:
            return "Что-то пошло не так"
        case .noConnection:
            return "Проверьте подключение к интернету"
        case .decoding:
            return "Ошибка обработки данных"
        case .unknown:
            return "Что-то пошло не так"
        case .timeout:
            return "Превышено время ожидания. Попробуйте ещё раз"
        case .server(let code):
            switch code {
            case 400:       return "Некорректный запрос"
            case 401:       return "Ошибка авторизации"
            case 402:       return "Лимит запросов исчерпан"
            case 403:       return "Доступ запрещён"
            case 404:       return "Ничего не найдено"
            case 429:       return "Слишком много запросов, попробуйте позже"
            case 500...599: return "Ошибка на сервере"
            default:        return "Что-то пошло не так"
            }
        }
    }
}
