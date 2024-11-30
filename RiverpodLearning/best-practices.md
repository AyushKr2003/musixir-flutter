# Riverpod Best Practices

## 1. State Management
- Keep providers focused and single-purpose
- Use AsyncValue for async operations
- Handle all states (loading, error, data)
- Consider state immutability

## 2. Code Organization
- Generate providers using @riverpod
- Keep provider files separate
- Use meaningful provider names
- Group related providers in feature folders

## 3. Performance
- Use ref.read() for one-time actions
- Use ref.watch() only when needed
- Avoid watching providers in build methods if possible
- Consider using select() for fine-grained rebuilds

## 4. Error Handling
- Always handle error states
- Provide meaningful error messages
- Use AsyncValue for consistent error handling
- Log errors appropriately

## 5. Dependencies
- Inject dependencies through providers
- Avoid global state
- Use provider modifiers when needed (.family, .autoDispose)
- Consider dependency lifecycles

## 6. Testing
- Mock providers in tests
- Test all state transitions
- Verify error handling
- Test async operations

## 7. Memory Management
- Use auto-dispose by default
- Only use keepAlive when necessary
- Clean up resources in dispose
- Watch for memory leaks

## 8. Code Generation
- Run build_runner after changes
- Keep generated files up to date
- Handle conflicts appropriately
- Version control generated files

[Back to README](README.md)
