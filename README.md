# Project Setting

layers
- data (package)
  - core
    - di
  - model
  - datasource
  - repository(implementation)
- domain (package)
  - core
    - di
  - entity
  - repository(interface)
  - usecases
- shared (package)
- lib (presentation layer)
  - core 
    - di
  - provider(bloc)
  - page
  - theme
  - router

### Code Gen

`
flutter pub  run melos run build:all
`
