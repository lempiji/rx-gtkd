module app;

import gtk.Main;
import gtk.MainWindow;
import gtk.Box;
import gtk.Entry;
import gtk.Label;
import gtk.Button;
import gtk.CheckButton;
import rx;
import rx.gtk;

void main(string[] args)
{
	Main.init(args);

	auto window = new MyAppWindow;
	window.addOnDestroy(_ => Main.quit());
	
	window.showAll();

	Main.run();
}

class MyAppWindow : MainWindow
{
    this()
    {
        super("example");
        setDefaultSize(640, 480);

        auto disposeBag = new CompositeDisposable;
        this.addOnDestroy(_ => disposeBag.dispose());

		// Init CheckButton
		auto checkVisible = new CheckButton("visible");
		checkVisible.setActive(true);
		auto checkSensitive = new CheckButton("sensitive");
		checkSensitive.setActive(true);
		auto checkCanFocus = new CheckButton("canFocus");
		checkCanFocus.setActive(true);

		// Link some CheckButton to Entry's properties
		auto entry = new Entry;
		entry.setVisibleWith(checkVisible.toggledAsObservable(), disposeBag);
		entry.setSensitiveWith(checkSensitive.toggledAsObservable(), disposeBag);
		entry.setCanFocusWith(checkCanFocus.toggledAsObservable(), disposeBag);

		// Link Entry to Label
		auto label = new Label("");
		label.setTextWith(entry.changedAsObservable(), disposeBag);

		// Layout
        auto box = new Box(GtkOrientation.VERTICAL, 5);
        box.packStart(checkVisible, false, false, 0);
        box.packStart(checkSensitive, false, false, 0);
        box.packStart(checkCanFocus, false, false, 0);
        box.packStart(entry, false, false, 0);
        box.packStart(label, false, false, 0);
        add(box);
    }
}
