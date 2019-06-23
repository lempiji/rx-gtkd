# rx-gtkd
Some utility functions for using `rx` with `gtk-d`

# Example 1 (30 seconds)

```d
// If CheckButton is checked, the button is clickable

import gtk.CheckButton;
import gtk.Button;
import rx;
import rx.gtk;

auto disposeBag = new CompositeDisposable;
auto check = new CheckButton("I agree");
auto button = new Button("Next");

button.setSensitiveWith(check.toggledAsObservable(), disposeBag);
```

# Example 2 (40 seconds)

```d
// If Entry has no value, the button is not clickable

import gtk.Button;
import gtk.Entry;
import rx;
import rx.gtk;

auto disposeBag = new CompositeDisposable;
auto entry = new Entry;
auto button = new Button("Check");

button.setSensitiveWith(entry.changedAsObservable().map!"a.length > 0"(), disposeBag);
```

# Usage

Add dependencies command

```bash
dub add gtk-d rx rx-gtkd 
```
