# Change log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [2.1.6] - 2023-01-23

* Add 2023's bovespa holidays.

## [2.1.5] - 2022-12-28

* Add 2022-12-30 holiday on Bovespa calendar.
* Added calendars for `argentina` and `norway`.

## [2.1.4] - 2022-06-28

* Add Juneteenth holiday on US calendar from 2022 to 2028.

## [2.1.3] - 2020-11-17

* Remove 2020-11-20 holiday from Bovespa calendar due to their note about
the day.
Check it here: http://www.b3.com.br/pt_br/noticias/funcionamento-da-b3-8AE490C97215B74E0172959F18F11323.htm

## [2.1.2] - 2020-04-29

* Add 2020's Good Friday holiday on US calendar

## [2.1.1] - 2020-04-15

* Remove deprecation warnings and create a note about it on README file.

## [2.1.0] - 2020-04-13

* Replace the access of `Spok::Workday` by `Spok` interface.

All methods before accessed by `Spok::Workday` module now is accessible by `Spok` interface.

```ruby
  Spok.restday?
  Spok.workday?
  Spok.weekend?
  Spok.holiday?
  Spok.last_workday
  Spok.next_workday
```

You can still use the `Spok::Workday` interface but it will warn you about the deprecation. We are planning to drop the support of `Spok::Workday` by the end of 2020.

## [2.0.1] - 2019-10-24

* Relax `activesupport` dependency to include the `6.x` series

## [2.0.0] - 2019-10-07

- Added calendars for `australia`, `austria`, `belgium`, `colombia`, `france`, `germany`,
  `guatemala`, `india`, `liechtenstein`, `singapore`, `switzerland`, `ukraine` and `united_states`.
- Added support for app specific calendars via, `Spok.add_calendar(:name, "/path/to/file.yml")`
- The existing list of calendars is frozen and we won't be accepting new calendars via Pull Requests,
  and we might deprecate existing ones in future releases to reduce the amount of assets in the project.

## [1.1.0] - 2018-10-02
- Add calendars for Canada, Costa Rica, Indonesia, Mexico, Netherlands, Poland, Portugal, Spain and Vietnam.
- Create configuration for defining a default calendar.

## [1.0.0] - 2018-09-14
- First public release.
