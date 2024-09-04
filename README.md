# chal_pal

### Pre-req

The following packages are heavily utilized;

1) [Freezed](https://pub.dev/packages/freezed)
2) [Riverpod](https://riverpod.dev/docs/introduction/why_riverpod) for state management

Both of these packages feature automatic code generation. To run the code generator, execute the following command in the terminal;
```
dart run build_runner build
```


Then we use the following the class structure and architecture as seen [here](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/)


Some big riverpod notes:

1) Many state management solutions rely on immutable objects in order to propagate state changes and ensure that our widgets rebuild only when they should. The rule is that when we need to mutate state in our models, we should do so by making a new, immutable copy.
2) When a @riverpod annotation is placed on a class, that class is called a "Notifier".
3) It is recommended to use ref.read when logic is performed in event handlers such as "onPressed".

