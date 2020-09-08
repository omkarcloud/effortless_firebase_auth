Completed Application

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Package validation found the following potential issues:

- It's strongly recommended to include a "homepage" or "repository" field in your pubspec.yaml
- Your dependency on "firebase_core" should have a version constraint. For example:

  dependencies:
  firebase_core: ^0.5.0

  Without a constraint, you're promising to support all future versions of "firebase_core".

- Your dependency on "dartz" should have a version constraint. For example:

  dependencies:
  dartz: ^0.9.1

  Without a constraint, you're promising to support all future versions of "dartz".

- Your dependency on "firebase_auth" should have a version constraint. For example:

  dependencies:
  firebase_auth: ^0.18.0+1

  Without a constraint, you're promising to support all future versions of "firebase_auth".

- Your dependency on "nice_button" should have a version constraint. For example:

  dependencies:
  nice_button: ^0.1.7

  Without a constraint, you're promising to support all future versions of "nice_button".

- Your dependency on "logger" should have a version constraint. For example:

  dependencies:
  logger: ^0.9.2
