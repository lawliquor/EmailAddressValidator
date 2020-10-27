class SimpleEmailAddressValidator {
	static public function isEmail(emailAddress:String):Bool {
		if (emailAddress.lastIndexOf("@") < 0)
			return false;
		if (emailAddress.length > 254 || emailAddress.length < 1)
			return false;
		return return checkAddress(emailAddress);
	}

	static function checkAddress(emailAddress:String):Bool {
		var domain = StringTools.replace(emailAddress.substr(emailAddress.lastIndexOf("@")), "@", "");
		var local = emailAddress.substring(0, emailAddress.lastIndexOf("@"));
		if (isDomain(domain) == false)
			return false;
		if (isLocal(local) == false)
			return false;
		return true;
	}

	static function isDomain(domain:String):Bool {
		final ALLOW_CHARS:EReg = ~/[0-9A-Z-\.]/i;
		if (domain.length > 253)
			return false;
		if (checkAllowChars(ALLOW_CHARS, domain) == false)
			return false;
		return true;
	}

	static function isLocal(local:String):Bool {
		final ALLOW_CHARS:EReg = ~/[0-9A-Z!#$%&'*+-=?^_`{|}~\/\.]/i;
		final DOUBLE_DOT:EReg = ~/\.\./g;
		final DOUBLE_QUOTED_LEFT:EReg = ~/^(")/;
		final DOUBLE_QUOTED_RIGHT:EReg = ~/(")$/;
		final BOTH_DOT:EReg = ~/^(\.)|(\.)$/;

		if (DOUBLE_QUOTED_LEFT.match(local) && DOUBLE_QUOTED_RIGHT.match(local)) {
			return isQuotedString(local);
		} else {
			if (BOTH_DOT.match(local))
				return false;
			if (local.length > 64)
				return false;
			if (checkAllowChars(ALLOW_CHARS, local) == false)
				return false;
			if (DOUBLE_DOT.match(local) == true)
				return false;
			return true;
		}
	}

	static function isQuotedString(local:String):Bool {
		final ALLOW_CHARS:EReg = ~/([ 0-9A-Z!#$%&'*+-=?^_`{|}~(),:;<>@(\\)\[\]\/\.])|(")/i;
		return checkAllowChars(ALLOW_CHARS, local);
	}

	static function checkAllowChars(regex:EReg, string:String):Bool {
		var splitString = string.split("");
		for (v in splitString) {
			if (regex.match(v) == false)
				return false;
		}
		return true;
	}
}
