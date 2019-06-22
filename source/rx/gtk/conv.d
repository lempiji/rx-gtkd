///
module rx.gtk.conv;

import rx;
import gtk.Entry;
import gtk.ToggleButton;
import gobject.Signals;
import std.range : put;

/**
 * Convert `addOnChanged` to a `Observable!string`.
 *
 * Params:
 *     entry = event source
 *     putInitialState = put a initial state to observer on subscribe
 *
 * Example:
 * -----
 * auto bag = new CompositeDisposable;
 * auto entry = new Entry;
 * auto label = new Label;
 * label.setTextWith(entry.changedAsObservable(), bag);
 * -----
 */
Observable!string changedAsObservable(Entry entry, bool putInitialState = true)
{
    return defer!string((Observer!string observer) {
        auto disposable = new SingleAssignmentDisposable;

        auto changedHandle = entry.addOnChanged((_) {
            .put(observer, entry.getText());
        });
        auto destroyHandle = entry.addOnDestroy((_) {
            observer.completed();
            disposable.dispose();
        });

        auto disconnect = new AnonymousDisposable({
            Signals.handlerDisconnect(entry, changedHandle);
            Signals.handlerDisconnect(entry, destroyHandle);
        });
        disposable.setDisposable(disconnect);

        if (putInitialState)
            .put(observer, entry.getText());

        return disposable;
    }).observableObject!string();
}

/**
 * Convert 'addOnToggled' to a `Observable!bool`.
 *
 * Params:
 *     button = event source
 *     putInitialState = put a initial state to observer on subscribe
 *
 * Example:
 * -----
 * auto bag = new CompositeDisposable;
 * auto checkButton = new CheckButton;
 * auto entry = new Entry;
 * entry.setSensitiveWith(checkButton.toggledAsObservable(), bag);
 * -----
 */
Observable!bool toggledAsObservable(ToggleButton button, bool putInitialState = true)
{
    return defer!bool((Observer!bool observer) {
        auto disposable = new SingleAssignmentDisposable;

        auto toggledHandle = button.addOnToggled((_) {
            .put(observer, button.getActive());
        });
        auto destroyHandle = button.addOnDestroy((_) {
            observer.completed();
            disposable.dispose();
        });

        auto disconnect = new AnonymousDisposable({
            Signals.handlerDisconnect(button, toggledHandle);
            Signals.handlerDisconnect(button, destroyHandle);
        });
        disposable.setDisposable(disconnect);

        if (putInitialState)
            .put(observer, button.getActive());

        return disposable;
    }).observableObject!bool();
}
