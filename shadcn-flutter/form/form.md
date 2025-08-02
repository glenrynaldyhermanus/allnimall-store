# Form Documentation

## Form Table Layout

Form dengan layout tabel menggunakan `FormTableLayout`:

```dart
final _usernameKey = const TextFieldKey('username');
final _passwordKey = const TextFieldKey('password');
final _confirmPasswordKey = const TextFieldKey('confirmPassword');

@override
Widget build(BuildContext context) {
  return SizedBox(
    width: 480,
    child: Form(
      onSubmit: (context, values) {
        // Get the values individually
        String? username = _usernameKey[values];
        String? password = _passwordKey[values];
        String? confirmPassword = _confirmPasswordKey[values];
        // or just encode the whole map to JSON directly
        String json = jsonEncode(values.map((key, value) {
          return MapEntry(key.key, value);
        }));
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Form Values'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username: $username'),
                  Text('Password: $password'),
                  Text('Confirm Password: $confirmPassword'),
                  Text('JSON: $json'),
                ],
              ),
              actions: [
                PrimaryButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FormTableLayout(
            rows: [
              FormField(
                key: _usernameKey,
                label: const Text('Username'),
                hint: const Text('This is your public display name'),
                validator: const LengthValidator(min: 4),
                child: const TextField(
                  initialValue: 'sunarya-thito',
                ),
              ),
              FormField(
                key: _passwordKey,
                label: const Text('Password'),
                validator: const LengthValidator(min: 8),
                child: const TextField(
                  obscureText: true,
                ),
              ),
              FormField(
                key: _confirmPasswordKey,
                label: const Text('Confirm Password'),
                validator: CompareWith.equal(_passwordKey,
                    message: 'Passwords do not match'),
                child: const TextField(
                  obscureText: true,
                ),
              ),
            ],
          ),
          const Gap(24),
          FormErrorBuilder(
            builder: (context, errors, child) {
              return PrimaryButton(
                onPressed: errors.isEmpty ? () => context.submitForm() : null,
                child: const Text('Submit'),
              );
            },
          )
        ],
      ),
    ),
  );
}
```

## Form Column Layout

Form dengan layout kolom menggunakan `Column`:

```dart
final _usernameKey = const TextFieldKey(#username);
final _passwordKey = const TextFieldKey(#password);
final _confirmPasswordKey = const TextFieldKey(#confirmPassword);
final _agreeKey = const CheckboxKey(#agree);
CheckboxState state = CheckboxState.unchecked;

@override
Widget build(BuildContext context) {
  return SizedBox(
    width: 480,
    child: Form(
      onSubmit: (context, values) {
        // Get the values individually
        String? username = _usernameKey[values];
        String? password = _passwordKey[values];
        String? confirmPassword = _confirmPasswordKey[values];
        CheckboxState? agree = _agreeKey[values];
        // or just encode the whole map to JSON directly
        String json = jsonEncode(values.map((key, value) {
          return MapEntry(key.key, value);
        }));
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Form Values'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username: $username'),
                  Text('Password: $password'),
                  Text('Confirm Password: $confirmPassword'),
                  Text('Agree: $agree'),
                  Text('JSON: $json'),
                ],
              ),
              actions: [
                PrimaryButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormField(
                key: _usernameKey,
                label: const Text('Username'),
                hint: const Text('This is your public display name'),
                validator: const LengthValidator(min: 4),
                showErrors: const {
                  FormValidationMode.changed,
                  FormValidationMode.submitted
                },
                child: const TextField(),
              ),
              FormField(
                key: _passwordKey,
                label: const Text('Password'),
                validator: const LengthValidator(min: 8),
                showErrors: const {
                  FormValidationMode.changed,
                  FormValidationMode.submitted
                },
                child: const TextField(
                  obscureText: true,
                ),
              ),
              FormField(
                key: _confirmPasswordKey,
                label: const Text('Confirm Password'),
                validator: CompareWith.equal(_passwordKey,
                    message: 'Passwords do not match'),
                showErrors: const {
                  FormValidationMode.changed,
                  FormValidationMode.submitted
                },
                child: const TextField(
                  obscureText: true,
                ),
              ),
              FormInline(
                key: _agreeKey,
                label: const Text('I agree to the terms and conditions'),
                validator: const CompareTo.equal(CheckboxState.checked,
                    message: 'You must agree to the terms and conditions'),
                showErrors: const {
                  FormValidationMode.changed,
                  FormValidationMode.submitted
                },
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Checkbox(
                      state: state,
                      onChanged: (value) {
                        setState(() {
                          state = value;
                        });
                      }),
                ),
              ),
            ],
          ).gap(24),
          const Gap(24),
          FormErrorBuilder(
            builder: (context, errors, child) {
              return PrimaryButton(
                onPressed: errors.isEmpty ? () => context.submitForm() : null,
                child: const Text('Submit'),
              );
            },
          )
        ],
      ),
    ),
  );
}
```

## Form Dengan Validation

Form dengan validasi yang lebih kompleks:

```dart
final _dummyData = [
  'sunarya-thito',
  'septogeddon',
  'shadcn',
];

final _usernameKey = const TextFieldKey('username');
final _passwordKey = const TextFieldKey('password');
final _confirmPasswordKey = const TextFieldKey('confirmPassword');

@override
Widget build(BuildContext context) {
  return SizedBox(
    width: 480,
    child: Form(
      onSubmit: (context, values) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Form Values'),
              content: Text(jsonEncode(values.map(
                (key, value) {
                  return MapEntry(key.key, value);
                },
              ))),
              actions: [
                PrimaryButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FormTableLayout(
            rows: [
              FormField(
                key: _usernameKey,
                label: const Text('Username'),
                hint: const Text('This is your public display name'),
                validator: const LengthValidator(min: 4) &
                    ValidationMode(
                      ConditionalValidator((value) async {
                        // simulate a network delay for example purpose
                        await Future.delayed(const Duration(seconds: 1));
                        return !_dummyData.contains(value);
                      }, message: 'Username already taken'),
                      // only validate when the form is submitted
                      mode: {FormValidationMode.submitted},
                    ),
                child: const TextField(
                  initialValue: 'sunarya-thito',
                ),
              ),
              FormField(
                key: _passwordKey,
                label: const Text('Password'),
                validator: const LengthValidator(min: 8),
                showErrors: const {
                  FormValidationMode.submitted,
                  FormValidationMode.changed
                },
                child: const TextField(
                  obscureText: true,
                ),
              ),
              FormField<String>(
                key: _confirmPasswordKey,
                label: const Text('Confirm Password'),
                showErrors: const {
                  FormValidationMode.submitted,
                  FormValidationMode.changed
                },
                validator: CompareWith.equal(_passwordKey,
                    message: 'Passwords do not match'),
                child: const TextField(
                  obscureText: true,
                ),
              ),
            ],
          ),
          const Gap(24),
          const SubmitButton(
            loadingTrailing: AspectRatio(
              aspectRatio: 1,
              child: CircularProgressIndicator(
                onSurface: true,
              ),
            ),
            child: Text('Register'),
          ),
        ],
      ),
    ),
  );
}
```

## Komponen Form

### FormField

Widget untuk field form dengan label, hint, dan validator.

**Properties:**

- `key`: Key untuk mengidentifikasi field
- `label`: Label field
- `hint`: Hint text untuk field
- `validator`: Validator untuk field
- `showErrors`: Mode validasi yang menampilkan error
- `child`: Widget child (biasanya TextField, Checkbox, dll)

### FormTableLayout

Layout untuk form dengan tampilan tabel.

**Properties:**

- `rows`: List dari FormField

### FormInline

Layout untuk field yang inline (seperti checkbox dengan label).

### FormErrorBuilder

Widget untuk menampilkan error form.

**Properties:**

- `builder`: Builder function yang menerima context, errors, dan child

### SubmitButton

Button untuk submit form dengan loading state.

**Properties:**

- `loadingTrailing`: Widget yang ditampilkan saat loading
- `child`: Text button

## Validator

### LengthValidator

Validator untuk panjang minimal/maksimal.

```dart
const LengthValidator(min: 4, max: 20, message: 'Length must be between 4-20')
```

### CompareWith

Validator untuk membandingkan dengan field lain.

```dart
CompareWith.equal(_passwordKey, message: 'Passwords do not match')
```

### ConditionalValidator

Validator dengan kondisi custom.

```dart
ConditionalValidator((value) async {
  // async validation logic
  return isValid;
}, message: 'Custom error message')
```

### CompareTo

Validator untuk membandingkan dengan nilai tertentu.

```dart
const CompareTo.equal(CheckboxState.checked, message: 'Must be checked')
```

## FormValidationMode

Mode validasi yang tersedia:

- `FormValidationMode.changed`: Validasi saat field berubah
- `FormValidationMode.submitted`: Validasi saat form disubmit
- `FormValidationMode.blur`: Validasi saat field kehilangan focus

## Penggunaan

1. **Buat Form Keys:**

```dart
final _usernameKey = const TextFieldKey('username');
final _passwordKey = const TextFieldKey('password');
```

2. **Buat Form:**

```dart
Form(
  onSubmit: (context, values) {
    // Handle form submission
  },
  child: Column(
    children: [
      // Form fields
    ],
  ),
)
```

3. **Buat FormField:**

```dart
FormField(
  key: _usernameKey,
  label: const Text('Username'),
  validator: const LengthValidator(min: 4),
  child: const TextField(),
)
```

4. **Handle Submission:**

```dart
FormErrorBuilder(
  builder: (context, errors, child) {
    return PrimaryButton(
      onPressed: errors.isEmpty ? () => context.submitForm() : null,
      child: const Text('Submit'),
    );
  },
)
```
