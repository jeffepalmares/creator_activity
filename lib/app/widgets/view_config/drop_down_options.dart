import 'package:creator_activity/app/utils/lib_date_utils.dart';

class DropDownOption<T> {
  T? value;
  DateTime? end;

  final String name;

  DropDownOption(this.value, this.name, {this.end});
}

enum SortActivityBy { Name, Date }

enum SortType { Asc, Desc }

enum GroupBy { T, PA }

class DefaultOptions {
  static final DropDownOption<DateTime> defaultPeriod =
      DropDownOption(null, 'Período Completo');
  static final DropDownOption<SortActivityBy> defaultOrderBy =
      DropDownOption(SortActivityBy.Name, 'Nome da atividade');
  static final DropDownOption<SortType> defaultMode =
      DropDownOption<SortType>(SortType.Asc, 'Ordem crescente');
  static final DropDownOption<GroupBy> defaultGroupBy =
      DropDownOption(GroupBy.T, 'Turmas');
}

class DropDowOptionsHelper {
  static var now = DateTime.now();

  static var addDays = LibDateUtils.addDay;

  static final List<DropDownOption<DateTime>> periods = [
    DropDownOption(addDays(now, -7), 'Útimos 7 dias'),
    DropDownOption(addDays(now, -14), 'Útimos 14 dias'),
    DropDownOption(addDays(now, -28), 'Útimos 28 dias'),
    DropDownOption(addDays(now, -30), 'Útimos 30 dias'),
    DropDownOption(now, 'Hoje', end: now),
    DropDownOption(addDays(now, -1), 'Ontem', end: addDays(now, -1)),
    DropDownOption(LibDateUtils.getFirstDayOfCurrentWeek(isSunday: true),
        'Esta semana(dom)',
        end: LibDateUtils.getLastDayOfCurrentWeek(isSunday: true)),
    DropDownOption(LibDateUtils.getFirstDayOfCurrentWeek(), 'Esta semana(seg)',
        end: LibDateUtils.getLastDayOfCurrentWeek()),
    DropDownOption(LibDateUtils.getFirstDayOfLastWeek(isSunday: true),
        'Semana Passada(dom)',
        end: LibDateUtils.getFirstDayOfLastWeek(isSunday: true)),
    DropDownOption(LibDateUtils.getFirstDayOfLastWeek(), 'Semana Passada(seg)',
        end: LibDateUtils.getLastDayOfLastWeek()),
    DropDownOption(LibDateUtils.getFirstDayOfCurrentMonth(), 'Este mês',
        end: LibDateUtils.getLastDayOfCurrentMonth()),
    DropDownOption(LibDateUtils.getFirstDayOfLastMonth(), 'Mês passado',
        end: LibDateUtils.getLastDayOfLastMonth()),
    DropDownOption(LibDateUtils.getFirstDayOfCurrentYear(), 'Este ano',
        end: LibDateUtils.getLastDayOfCurrentYear()),
    DropDownOption(LibDateUtils.getFirstDayOfLastYear(), 'Ano passado',
        end: LibDateUtils.getLastDayOfLastYear()),
    DefaultOptions.defaultPeriod
  ];

  static final List<DropDownOption<SortActivityBy>> orderOptions = [
    DropDownOption(SortActivityBy.Date, 'Data da atividade'),
    DefaultOptions.defaultOrderBy
  ];

  static final List<DropDownOption<SortActivityBy>> orderByOptions = [
    DropDownOption(SortActivityBy.Date, 'Data da atividade'),
    DefaultOptions.defaultOrderBy
  ];

  static final List<DropDownOption<SortType>> modeOptions = [
    DropDownOption(SortType.Desc, 'Ordem decrescente'),
    DefaultOptions.defaultMode
  ];

  static final List<DropDownOption<GroupBy>> groupByOptions = [
    DropDownOption(GroupBy.PA, 'Provas e aulas'),
    DefaultOptions.defaultGroupBy
  ];
}
