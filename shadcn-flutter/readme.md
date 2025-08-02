Shadcn UI for Flutter – getting started & component rules
This document summarizes the official documentation for shadcn UI for Flutter at time of writing. It explains how to install and integrate the package and gives concise rules for each of the available components. Each component section notes the important properties and describes the supported variants.

Getting started
Installation
Add the package to your Flutter project by running the following command:

csharp
Copy
Edit
flutter pub add shadcn_ui
Alternatively, add the dependency manually in pubspec.yaml:

yaml
Copy
Edit
dependencies:
shadcn_ui: ^0.2.4 # replace with the latest version
Using shadcn components without Material or Cupertino
Use the ShadApp widget as the root of your application when you want a pure shadcn UI without Material or Cupertino. The ShadApp sets up theme data, color schemes and breakpoints for all the shadcn components
flutter-shadcn-ui.mariuti.com
. If your app uses the Router API instead of Navigator you can use ShadApp.router instead
flutter-shadcn-ui.mariuti.com
.

Example:

dart
Copy
Edit
class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return ShadApp();
}
}
Mixing shadcn with Material
Shadcn UI can be used alongside Flutter’s Material components. Wrap the Material MaterialApp inside a ShadApp.custom to supply the shadcn theme and color scheme to the entire app. The appBuilder callback should return a MaterialApp so that Material widgets pick up the shadcn theme
flutter-shadcn-ui.mariuti.com
. When using Router, call MaterialApp.router instead
flutter-shadcn-ui.mariuti.com
.

When using ShadApp.custom you can also override the theme mode and provide separate light and dark ShadThemeData values (for example, using the slate dark color scheme)
flutter-shadcn-ui.mariuti.com
.

By default the ShadApp generates a complete ThemeData with the appropriate color scheme, typography and widget themes. The default Material theme uses the shadcn color scheme for primary, secondary, error, surface and text colours
flutter-shadcn-ui.mariuti.com
and sets the scaffold background, divider colours, text selection colours and scrollbar theme
flutter-shadcn-ui.mariuti.com
.

To override individual values, call Theme.of(context).copyWith(...) so you still inherit the defaults provided by shadcn UI
flutter-shadcn-ui.mariuti.com
.

Mixing shadcn with Cupertino
To combine shadcn components with Cupertino widgets, wrap a CupertinoApp inside ShadApp.custom and provide the dark and light themes. The appBuilder callback should return a CupertinoApp and call ShadAppBuilder inside its builder property so that the shadcn theme applies to all descendants
flutter-shadcn-ui.mariuti.com
. Use CupertinoApp.router when using the Router API
flutter-shadcn-ui.mariuti.com
.

The default CupertinoThemeData produced by ShadApp sets primaryColor, primaryContrastingColor, scaffoldBackgroundColor, barBackgroundColor and brightness to values from the shadcn color scheme
flutter-shadcn-ui.mariuti.com
. As with Material, you can override Cupertino theme values using CupertinoTheme.of(context).copyWith(...)
flutter-shadcn-ui.mariuti.com
.

Theme data & colour schemes
Shadcn UI supports a range of built‑in colour schemes such as blue, gray, green, neutral, orange, red, rose, slate, stone, violet, yellow and zinc
flutter-shadcn-ui.mariuti.com
. You can specify a light or dark colour scheme when creating a ShadThemeData and override particular properties—for example the background colour or button theme—by passing a new colour scheme and component themes
flutter-shadcn-ui.mariuti.com
.

If you need to let users choose a colour scheme at runtime, you can call ShadColorScheme.fromName(name, brightness: ...) to construct a scheme from the list of names
flutter-shadcn-ui.mariuti.com
. A ShadSelect can be used to build a drop‑down allowing users to pick a scheme; when the selection changes you must rebuild the app with the new scheme
flutter-shadcn-ui.mariuti.com
.

Responsive breakpoints
Shadcn UI’s theme exposes a set of breakpoints (tiny, small, medium, large, extra large and extra‑extra large). You can customise them through the breakpoints property on ShadThemeData
flutter-shadcn-ui.mariuti.com
. To query the current breakpoint at runtime, use ShadResponsiveBuilder or the extension method context.breakpoint
flutter-shadcn-ui.mariuti.com
. The breakpoint type is a sealed class so you can pattern‑match on specific values in a switch statement
flutter-shadcn-ui.mariuti.com
.

Typography
Shadcn’s typography system exposes a variety of text styles on ShadTheme.of(context).textTheme such as h1Large, h1, h2, h3, h4, p, blockquote, lead, large, small and muted
flutter-shadcn-ui.mariuti.com
. Applying these styles ensures text matches the visual language of shadcn UI.

Components
The following sections describe each component and list the available variants. Use these summaries as a quick reference when building your app.

Accordion
The ShadAccordion widget presents expandable sections. Supply a list of (title, content) tuples and the widget will create a vertical list of accordions. Each ShadAccordionItem displays its title and expands to reveal its content when tapped.

To allow multiple panels to stay open simultaneously, use ShadAccordion.multiple instead of the default single‑open behaviour
flutter-shadcn-ui.mariuti.com
.

Alert
Alerts show contextual messages. Use the ShadAlert constructor and provide:

iconData – an optional icon;

title – short heading; and

description – longer explanation.

For error messages use ShadAlert.destructive which automatically applies a red colour scheme
flutter-shadcn-ui.mariuti.com
.

Avatar
ShadAvatar displays a circular avatar. Provide an image to load the picture. If the image fails to load, the placeholder widget (often a Text widget with the user’s initials) is displayed
flutter-shadcn-ui.mariuti.com
.

Badge
A badge is a small label used to highlight status or categories. Use the following constructors:

Variant Constructor Notes
Primary ShadBadge() Default dark background with light text.
Secondary ShadBadge.secondary() Subtle background and darker text.
Destructive ShadBadge.destructive() Uses destructive colour scheme (red) to indicate errors.
Outline ShadBadge.outline() Transparent fill with coloured border
flutter-shadcn-ui.mariuti.com
.

Button
Buttons are essential interactive controls. The ShadButton class supports multiple visual styles via named constructors:

Variant Usage
Primary ShadButton(child: Text('...'), onPressed: ...) – default style.
Secondary ShadButton.secondary(...) – subtle background.
Destructive ShadButton.destructive(...) – red background for destructive actions.
Outline ShadButton.outline(...) – transparent fill with border.
Ghost ShadButton.ghost(...) – transparent background and minimal border.
Link ShadButton.link(...) – styled like a hyperlink.
Text and Icon Place an Icon before the label to create an icon button: ShadButton(child: Row(children:[Icon(...), Text('')])).
Loading Wrap the content in a Stack and set loading: true to display a spinner while performing an action
flutter-shadcn-ui.mariuti.com
.
Gradient & Shadow Pass gradient and shadowColor properties to add custom gradients or drop‑shadows
flutter-shadcn-ui.mariuti.com
.

Input (text field)
ShadInput provides an input field. Important properties include:

placeholder – a hint displayed when the field is empty;

keyboardType – e.g., TextInputType.emailAddress;

leading/trailing – widgets displayed before/after the text (e.g. icons or toggles). For a password field you can include a lock icon as the leading widget and a visibility toggle as the trailing widget;

onChanged – callback invoked when the text changes.

Use ShadInputFormField inside a ShadForm to integrate inputs into form validation; pass validator, label, sublabel and description as needed
flutter-shadcn-ui.mariuti.com
. You can set obscureText: true for password inputs and manage state to toggle visibility
flutter-shadcn-ui.mariuti.com
.

Calendar
ShadCalendar presents one or more month views for picking dates. Key features:

selected – the currently selected date.

fromMonth/toMonth – limit the range of months displayed.

onChanged – called when the user picks a date.

multiple – display several months at once by using ShadCalendar.multiple, which accepts a monthCount parameter
flutter-shadcn-ui.mariuti.com
.

range – use ShadCalendar.range to let users pick start and end dates (the callback receives a DateTimeRange)
flutter-shadcn-ui.mariuti.com
.

Options such as hideNavigation, showWeekNumbers, showOutsideDays, fixedWeeks and hideWeekdayNames control the look and feel
flutter-shadcn-ui.mariuti.com
.

Card
ShadCard displays a rectangular card with optional header, description, footer and custom content. Supply title, description and footer to define the header and actions, and provide a child widget to display your form or list. Cards can contain other shadcn components such as inputs, selects or switches
flutter-shadcn-ui.mariuti.com
. You can create complex cards like notification lists by composing rows with icons, text and toggles
flutter-shadcn-ui.mariuti.com
.

Checkbox
The ShadCheckbox toggles a boolean value. Set value and update the state in onChanged. You can also provide a label and sublabel to describe the checkbox
flutter-shadcn-ui.mariuti.com
. For forms, use ShadCheckboxFormField which accepts an id, initialValue, label fields and a validator to enforce acceptance of terms (for example, requiring the user to check a terms‑of‑service box)
flutter-shadcn-ui.mariuti.com
.

Context Menu
Context menus are built using ShadContextMenuRegion. Wrap any widget with this region and define the menu items through the menu callback. Create menu items with ShadContextMenuItem, which supports nested submenus, separators (ShadContextMenuItem.separator()), disabled items and icons
flutter-shadcn-ui.mariuti.com
. Submenus are just ShadContextMenuItem with a children property containing more items
flutter-shadcn-ui.mariuti.com
.

Date Picker
Use ShadDatePicker for selecting a single date. The selected property holds the chosen date and onChanged updates it
flutter-shadcn-ui.mariuti.com
. For ranges use ShadDatePicker.range, which returns a DateTimeRange
flutter-shadcn-ui.mariuti.com
. You can provide presets by building a drop‑down ShadSelect that sets the selected dates (e.g., “Today”, “Tomorrow”, “Next Week”)
flutter-shadcn-ui.mariuti.com
.

In forms use ShadDatePickerFormField for single dates and ShadDateRangePickerFormField for ranges; these fields accept label, description and validator callbacks
flutter-shadcn-ui.mariuti.com
.

Dialog
To display a modal dialog, call showShadDialog and pass a ShadDialog widget. Provide title, description, and a list of actions (usually buttons). The dialog’s child can contain any content, such as input fields for editing a profile
flutter-shadcn-ui.mariuti.com
. For confirmation dialogs, use ShadDialog.alert and supply title, content and actions; the default style emphasises the destructive action
flutter-shadcn-ui.mariuti.com
.

Form
ShadForm collects and validates multiple form fields. Create a GlobalKey<ShadFormState> and pass it to the form. Use ShadInputFormField, ShadCheckboxFormField, ShadSelectFormField or other form field widgets inside. When submitting, call key.currentState!.validate() to run validators and key.currentState!.save() to save values. Place the submission logic in the onPressed callback of a ShadButton
flutter-shadcn-ui.mariuti.com
.

Icon Button
ShadIconButton is similar to ShadButton but displays only an icon. Variants mirror the normal button variants: ShadIconButton.secondary(), .destructive(), .outline(), .ghost() and .loading()
flutter-shadcn-ui.mariuti.com
. You can apply gradients or shadows using the same properties as ShadButton.

Input OTP
ShadInputOTP is designed for one‑time‑password codes. Use the length property to specify how many slots are displayed and pass inputFormatters to restrict input (e.g. FilteringTextInputFormatter.digitsOnly)
flutter-shadcn-ui.mariuti.com
. You can add gaps between groups by inserting custom widgets in the separator list. For forms, ShadInputOTPFormField validates that all slots are filled before submission
flutter-shadcn-ui.mariuti.com
.

Menubar
ShadMenubar displays a horizontal menu bar with items that open context menus. Define items with ShadMenubarItem, each containing a child (the label) and a submenu list of ShadContextMenuItem objects. Use separators and icons inside submenus as needed
flutter-shadcn-ui.mariuti.com
.

Popover
A popover is a floating panel that appears relative to a trigger. Use ShadPopover and provide a controller (an instance of ShadPopoverController), a trigger (often a button), and body content. The popover can contain inputs, selects or other widgets. You may specify a custom width via the width property
flutter-shadcn-ui.mariuti.com
.

Progress
ShadProgress displays a horizontal progress bar. To create a determinate progress bar supply a value between 0 and 1; to show an indeterminate loading bar omit the value
flutter-shadcn-ui.mariuti.com
.

Radio Group
ShadRadioGroup<T> allows users to select one option from a list. Provide value and a list of ShadRadio children (each with a value and child). Handle selection changes in the onChanged callback. Use ShadRadioGroupFormField for form integration with validation
flutter-shadcn-ui.mariuti.com
.

Resizable
To build resizable layouts, use ShadResizablePanelGroup. Set the axis to Axis.horizontal or Axis.vertical and provide a list of ResizablePanel widgets. Each panel has a minWidth, maxWidth and initial size. You can show a handle between panels by setting showHandle: true and customise the handle with handleIcon or handleIconSrc
flutter-shadcn-ui.mariuti.com
. The panels can be nested to create complex layouts. Double‑clicking the handle resets sizes. Vertical layouts work in the same way but use Axis.vertical
flutter-shadcn-ui.mariuti.com
.

Select
ShadSelect presents a dropdown list of ShadOptions. Set initialValue to the selected value and use the options list to define items. Provide an onChanged callback to handle selection. Additional variants include:

Scrollable select – when you have many options use ShadSelect inside a ConstrainedBox with maxHeight to make the list scrollable
flutter-shadcn-ui.mariuti.com
.

Searchable select – use ShadSelect.searchable to allow users to filter options as they type
flutter-shadcn-ui.mariuti.com
.

Multiple select – call ShadSelect.multiple and supply allowDeselection: true if the user should be allowed to clear selections; use closeOnSelect: false to keep the menu open while making multiple selections
flutter-shadcn-ui.mariuti.com
.

Separator
Use ShadSeparator.horizontal or ShadSeparator.vertical to separate content. You can set thickness, margin and borderRadius to adjust the appearance
flutter-shadcn-ui.mariuti.com
.

Sheet
showShadSheet displays a sliding panel that appears from any screen edge. Pass the context, a side (top, bottom, left or right) and a builder that returns the sheet content. For example, a profile editing sheet might contain a form with inputs and actions. Use ShadSheetSide.right to slide in from the right
flutter-shadcn-ui.mariuti.com
.

Slider
The ShadSlider widget lets users select a numeric value within a range. Configure initialValue, min, max and onChanged to receive updates
flutter-shadcn-ui.mariuti.com
.

Sonner
ShadSonner is an opinionated toast provider. To show a toast call ShadSonner.of(context).show() with a ShadToast specifying the title, description and an optional action that hides the toast when pressed
flutter-shadcn-ui.mariuti.com
.

Switch
ShadSwitch toggles between on and off states. Provide value and update it in the onChanged callback. You can add a label to display text next to the switch
flutter-shadcn-ui.mariuti.com
. For forms use ShadSwitchFormField which accepts an id, initialValue, inputLabel, inputSublabel and validator to enforce acceptance (e.g. terms of service)
flutter-shadcn-ui.mariuti.com
.

Table
The table component renders responsive data tables. There are two creation methods:

Static list: use ShadTable.list and provide a list of rows. Each row is a list of ShadTableCells; you can also supply header and footer cells and customise column widths via columnSpanExtent
flutter-shadcn-ui.mariuti.com
. Use this method for small tables because all cells are built at once.

Builder: for large datasets use ShadTable, set columnCount and rowCount and supply header, builder and footer callbacks. The builder receives row/column indices and should return a ShadTableCell. You can control column widths in columnSpanExtent and customise footer totals【376022796316383†L346-L567】.

Tabs
ShadTabs<T> organizes content into tab panels. Set the value to the active tab’s key and provide a list of ShadTabs, each with a value, child (label widget) and content (the panel content). Optional tabBarConstraints and contentConstraints restrict the maximum width of the tab bar and panel. See the example of an account/password settings page
flutter-shadcn-ui.mariuti.com
.

Textarea
Use ShadTextarea for multi‑line input. Set a placeholder to guide the user. For forms, ShadTextareaFormField accepts an id, label, placeholder, description and validator to enforce requirements like minimum character count
flutter-shadcn-ui.mariuti.com
.

Time Picker
ShadTimePicker lets users select a time. The basic picker has an optional trailing widget (e.g. a clock icon)
flutter-shadcn-ui.mariuti.com
. In forms use ShadTimePickerFormField or ShadTimePickerFormField.period. Both constructors accept label, description and validator and return null when no time is selected
flutter-shadcn-ui.mariuti.com
.

Toast
To display toast notifications, obtain a ShadToaster using ShadToaster.of(context) and call show(...) with a ShadToast. Toasts support several patterns:

Simple: only a description text
flutter-shadcn-ui.mariuti.com
.

With title: add a title above the description
flutter-shadcn-ui.mariuti.com
.

With action: provide an action button (e.g. “Try again”) that hides the toast or performs another task
flutter-shadcn-ui.mariuti.com
.

Destructive: call ShadToast.destructive to style the toast with destructive colours and supply an action via a ShadButton.destructive
flutter-shadcn-ui.mariuti.com
.

Tooltip
ShadTooltip shows a small hint when a control gains focus or the pointer hovers over it. Provide a builder that returns the tooltip text and wrap the trigger widget (such as a button) in the tooltip
flutter-shadcn-ui.mariuti.com
.

Decorator
ShadDecoration defines border, padding and text styles used throughout the library. You can override the default decoration by creating a ShadDecoration and assigning it to components via ShadDecorator. Properties such as secondaryBorder, secondaryFocusedBorder, labelStyle, errorStyle, labelPadding, descriptionStyle and errorPadding control how focused, labelled and error states look
flutter-shadcn-ui.mariuti.com
.

The ShadThemeData includes a disableSecondaryBorder flag. Setting this flag removes the secondary focus border and makes the primary border bolder, but the documentation warns that this may impact accessibility
flutter-shadcn-ui.mariuti.com
.

Responsive
Shadcn UI emphasises responsive design. Define custom breakpoint values on ShadThemeData.breakpoints (tiny, small, medium, large, extra large, extra‑extra large)
flutter-shadcn-ui.mariuti.com
. To query the current breakpoint, wrap a widget in ShadResponsiveBuilder or call context.breakpoint
flutter-shadcn-ui.mariuti.com
. The breakpoint is a sealed class so you can switch on the exact size category
flutter-shadcn-ui.mariuti.com
.

Conclusion
This document covers installation, theme customisation and every component available in the shadcn UI library as of August 2025. Use it as a quick reference when building Flutter apps with shadcn components. For more detailed examples and up‑to‑date information, see the official documentation site.
