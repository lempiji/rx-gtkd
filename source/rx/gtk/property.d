module rx.gtk.property;

import gtk.Widget;
import gtk.Label;
import rx;

private void setupCore(TObservable, TObserver)(auto ref TObservable observable,
        TObserver observer, CompositeDisposable disposeBag)
{
    static assert(isObservable!TObservable);

    auto disposable = new SingleAssignmentDisposable;
    auto subscription = observable.doSubscribe(observer, { disposable.dispose(); }, (Exception _) {
        disposable.dispose();
    });
    disposable.setDisposable(subscription);

    disposeBag.insert(disposable);
}

/**
 * Sync sensitive with a `Observable!bool`
 *
 * Params:
 *      widget = sync target
 *      observable = sync source
 *      disposeBag = register a sibscription into this
 *
 * Example:
 * -----
 * auto bag = new CompositeDisposable;
 * auto entry = new Entry;
 * auto button = new Button;
 * button.setSensitiveWith(entry.changedAsObservable().map!"a.length > 5", bag);
 * -----
 */
void setSensitiveWith(TWidget, TObservable)(auto ref TWidget widget,
        auto ref TObservable observable, CompositeDisposable disposeBag)
{
    static assert(is(TWidget : Widget));
    static assert(isObservable!(TObservable, bool));
    setupCore(observable, &widget.setSensitive, disposeBag);
}

/**
 * Sync canFocus with a `Observable!bool`
 *
 * Params:
 *      widget = sync target
 *      observable = sync source
 *      disposeBag = register a sibscription into this
 *
 * Example:
 * -----
 * auto bag = new CompositeDisposable;
 * auto entry = new Entry;
 * auto button = new Button;
 * button.setCanFocusWith(entry.changedAsObservable().map!"a.length > 5", bag);
 * -----
 */
void setCanFocusWith(TWidget, TObservable)(auto ref TWidget widget,
        auto ref TObservable observable, CompositeDisposable disposeBag)
{
    static assert(is(TWidget : Widget));
    static assert(isObservable!(TObservable, bool));
    setupCore(observable, &widget.setCanFocus, disposeBag);
}

/**
 * Sync visible with a `Observable!bool`
 *
 * Params:
 *      widget = sync target
 *      observable = sync source
 *      disposeBag = register a sibscription into this
 *
 * Example:
 * -----
 * auto bag = new CompositeDisposable;
 * auto entry = new Entry;
 * auto button = new Button;
 * button.setVisibleWith(entry.changedAsObservable().map!"a.length > 5", bag);
 * -----
 */
void setVisibleWith(TWidget, TObservable)(TWidget widget,
        auto ref TObservable observable, CompositeDisposable disposeBag)
{
    static assert(is(TWidget : Widget));
    static assert(isObservable!(TObservable, bool));
    setupCore(observable, &widget.setVisible, disposeBag);
}

/**
 * Sync text with a `Observable!string`
 *
 * Params:
 *      widget = sync target
 *      observable = sync source
 *      disposeBag = register a sibscription into this
 *
 * Example:
 * -----
 * auto bag = new CompositeDisposable;
 * auto entry = new Entry;
 * auto label = new Label;
 * label.setTextWith(entry.changedAsObservable(), bag);
 * -----
 */
void setTextWith(TLabel, TObservable)(auto ref TLabel label,
        auto ref TObservable observable, CompositeDisposable disposeBag)
{
    static assert(is(TLabel : Label));
    static assert(isObservable!(TObservable, string));
    setupCore(observable, &label.setText, disposeBag);
}

/**
 * Sync visibility with a `Observable!bool`
 *
 * Params:
 *      widget = sync target
 *      observable = sync source
 *      disposeBag = register a sibscription into this
 *
 * Example:
 * -----
 * auto bag = new CompositeDisposable;
 * auto check = new CheckButton;
 * auto entry = new Entry;
 * entry.setVisibilityWith(check.toggleedAsObservable(), bag);
 * -----
 */
void setVisibilityWith(TWidget, TObservable)(TWidget widget,
        auto ref TObservable observable, CompositeDisposable disposeBag)
{
    static assert(is(TWidget : Widget));
    static assert(isObservable!(TObservable, bool));
    setupCore(observable, &widget.setVisibility, disposeBag);
}