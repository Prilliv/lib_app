import '../models/book.dart';
import '../models/reservation.dart';

/// In-memory book catalog and reservations.
class BookService {
  static final List<Book> books = [
    const Book(
      id: '1',
      title: 'Чистий код',
      author: 'Роберт Мартін',
      genre: 'Програмування',
      description:
          'Посібник з написання чистого, читабельного та підтримуваного коду. Класика для кожного розробника.',
      year: 2008,
    ),
    const Book(
      id: '2',
      title: 'Flutter у дії',
      author: 'Ерік Віндмілл',
      genre: 'Програмування',
      description:
          'Практичний посібник з розробки кросплатформних застосунків на Flutter.',
      year: 2020,
    ),
    const Book(
      id: '3',
      title: 'Алгоритми',
      author: 'Роберт Седжвік',
      genre: 'Програмування',
      description: 'Фундаментальний підручник з алгоритмів і структур даних.',
      year: 2011,
    ),
    const Book(
      id: '4',
      title: 'Дизайн-патерни',
      author: 'Еріх Ґамма та ін.',
      genre: 'Програмування',
      description: 'Класична книга про патерни проектування програмного забезпечення.',
      year: 1994,
    ),
    const Book(
      id: '5',
      title: 'Гаррі Поттер і філософський камінь',
      author: 'Джоан Роулінг',
      genre: 'Фантастика',
      description: 'Перша книга про юного чарівника Гаррі Поттера.',
      year: 1997,
    ),
    const Book(
      id: '6',
      title: 'Володар перснів',
      author: 'Дж. Р. Р. Толкін',
      genre: 'Фантастика',
      description: 'Епічна сага про Середзем\'я та боротьбу зі злом.',
      year: 1954,
    ),
    const Book(
      id: '7',
      title: 'Дюна',
      author: 'Френк Герберт',
      genre: 'Фантастика',
      description: 'Науково-фантастичний роман про пустельну планету Арракіс.',
      year: 1965,
    ),
    const Book(
      id: '8',
      title: '1984',
      author: 'Джордж Орвелл',
      genre: 'Класика',
      description: 'Антиутопія про тоталітарне суспільство та Великого Брата.',
      year: 1949,
    ),
    const Book(
      id: '9',
      title: 'Майстер і Маргарита',
      author: 'Михайло Булгаков',
      genre: 'Класика',
      description: 'Містичний роман про диявола, який відвідує Москву.',
      year: 1967,
    ),
    const Book(
      id: '10',
      title: 'Кобзар',
      author: 'Тарас Шевченко',
      genre: 'Класика',
      description: 'Збірка поезій великого українського поета.',
      year: 1840,
    ),
    const Book(
      id: '11',
      title: 'Sapiens',
      author: 'Ювал Ной Харарі',
      genre: 'Історія',
      description: 'Коротка історія людства від кам\'яної доби до сьогодення.',
      year: 2011,
    ),
    const Book(
      id: '12',
      title: 'Історія України',
      author: 'Михайло Грушевський',
      genre: 'Історія',
      description: 'Фундаментальна праця з історії українського народу.',
      year: 1898,
    ),
    const Book(
      id: '13',
      title: 'Чорнобильська молитва',
      author: 'Світлана Алексієвич',
      genre: 'Історія',
      description: 'Документальна хроніка катастрофи на ЧАЕС очима очевидців.',
      year: 1997,
    ),
    const Book(
      id: '14',
      title: 'Атомні звички',
      author: 'Джеймс Клір',
      genre: 'Саморозвиток',
      description: 'Практичний посібник зі створення хороших звичок і позбавлення від поганих.',
      year: 2018,
    ),
    const Book(
      id: '15',
      title: 'Думай повільно... вирішуй швидко',
      author: 'Даніель Канеман',
      genre: 'Саморозвиток',
      description: 'Як працює мислення: система 1 і система 2.',
      year: 2011,
    ),
    const Book(
      id: '16',
      title: 'Глибока робота',
      author: 'Кел Ньюпорт',
      genre: 'Саморозвиток',
      description: 'Правила зосередженого успіху в розсіяному світі.',
      year: 2016,
    ),
    const Book(
      id: '17',
      title: 'Математичний аналіз',
      author: 'В. А. Зорич',
      genre: 'Математика',
      description: 'Класичний підручник з математичного аналізу для університетів.',
      year: 1981,
    ),
    const Book(
      id: '18',
      title: 'Лінійна алгебра',
      author: 'Шелдон Акслер',
      genre: 'Математика',
      description: 'Сучасний підхід до лінійної алгебри.',
      year: 1995,
    ),
  ];

  static final List<Reservation> reservations = [];

  static Book? findById(String id) {
    try {
      return books.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<Book> filterByGenre(String? genre) {
    if (genre == null || genre.isEmpty || genre == 'Усі') {
      return List.from(books);
    }
    return books.where((b) => b.genre == genre).toList();
  }

  static List<String> get genres {
    final set = books.map((b) => b.genre).toSet().toList()..sort();
    return ['Усі', ...set];
  }

  static void addReservation(Reservation r) {
    reservations.add(r);
  }
}
