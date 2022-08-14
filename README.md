# Learning Ecto

## [COURSE] Design for Ecto
A layered approach to persistence in Elixir.

- [x] Go through the [Design for Ecto](https://grox.io/language/ecto/course) course.
- [x] Follow the course while considering:
  - [x] Separating runtime concerns from implementation code
  - [x] Maintaining pure computations / data manipulation in a core layer
  - [x] Pushing actions / effects to a boundary layer
- [x] Update this `README.md` file when done.

I'm leaving this Repo available mostly for my own reference.

### Folder Structure

| Folder                                  | Contents                                                                         |
| :-------------------------------------- | :------------------------------------------------------------------------------- |
| [banq](banq/lib/banq/bank.ex#L106)      | An exercise on avoiding concurrency bugs with DB transactions avoid `Ecto.Multi` |
| [count](tome/lib/counts/count.ex)       | Simple example on how concurrency bugs can occur when updating the database      |
| [tome](tome)                            | The bulk of the contents of the course                                           |
| [tome/core](tome/lib/impl/core)         | The core layer                                                                   |
| [tome/boundary](tome/lib/impl/boundary) | The boundary layer                                                               |