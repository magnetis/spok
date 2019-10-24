# Change log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [2.0.0] - 2019-10-24

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
