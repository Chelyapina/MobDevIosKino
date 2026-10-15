struct FilmPage {
    let items: [FilmListModel]
    let page: Int
    let totalPages: Int

    var hasMore: Bool { page < totalPages }
}
