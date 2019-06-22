module app;

import gtk.Main;
import gtk.MainWindow;
import gtk.Box;
import gtk.Entry;
import gtk.Label;
import gtk.Button;
import gtk.CheckButton;
import gtk.MessageDialog;

import rx;
import std.algorithm : min;

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
		super("Change Password");
		setDefaultSize(240, 300);

		auto disposeBag = new CompositeDisposable;
		this.addOnDestroy(_ => disposeBag.dispose());

		auto entryCurrentPassword = new Entry;
		entryCurrentPassword.setPlaceholderText("Current Password");
		entryCurrentPassword.setVisibility(false);

		auto entryNewPassword = new Entry;
		entryNewPassword.setPlaceholderText("New Password");
		entryNewPassword.setVisibility(false);

		auto entryConfirmPassword = new Entry;
		entryConfirmPassword.setPlaceholderText("Confirm Password");
		entryConfirmPassword.setVisibility(false);

		auto checkShowPassword = new CheckButton("show password");
		auto labelErrorMessage = new Label("");
		auto buttonLogon = new Button("Change Password");

		auto showPassword = checkShowPassword.toggledAsObservable();
		entryCurrentPassword.setVisibilityWith(showPassword, disposeBag);
		entryNewPassword.setVisibilityWith(showPassword, disposeBag);
		entryConfirmPassword.setVisibilityWith(showPassword, disposeBag);

		// Validation
		auto currentPassword = entryCurrentPassword.changedAsObservable();
		auto newPassword1 = entryNewPassword.changedAsObservable();
		auto newPassword2 = entryConfirmPassword.changedAsObservable();

		auto message = combineLatest(currentPassword, newPassword1, newPassword2).map!((ps) {
			import std.stdio;

			writeln(ps);
			if (ps[0].length == 0)
				return "Enter current password (can be any text)";
			if (ps[1].length == 0)
				return "Enter new password";
			if (ps[0] == ps[1])
				return "New password must be changed";
			if (ps[1].length < 8)
				return "New Password must contain at least 8 characters";
			if (ps[1] != ps[2])
				return "Mismatch new passwords";
			return "";
		});

		labelErrorMessage.setTextWith(message, disposeBag);
		buttonLogon.setSensitiveWith(message.map!(a => a == ""), disposeBag);

		// Logic
		buttonLogon.addOnClicked((_) {
			auto dialog = new MessageDialog(this, GtkDialogFlags.MODAL,
				GtkMessageType.INFO, GtkButtonsType.OK, "Changed!");
			scope (exit)
				dialog.destroy();

			dialog.run();
		});

		// Layout
		auto hbox = new Box(GtkOrientation.HORIZONTAL, 0);
		auto box = new Box(GtkOrientation.VERTICAL, 0);
		box.packStart(entryCurrentPassword, false, false, 5);
		box.packStart(entryNewPassword, false, false, 5);
		box.packStart(entryConfirmPassword, false, false, 5);
		box.packStart(checkShowPassword, false, false, 5);
		box.packStart(labelErrorMessage, false, false, 5);
		box.packStart(buttonLogon, false, false, 0);

		hbox.packStart(box, true, false, 0);
		add(hbox);
	}
}
