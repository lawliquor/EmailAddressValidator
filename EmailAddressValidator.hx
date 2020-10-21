class EmailAddressValidator {
	var forbidChars:{
		domain:Array<String>,
		local:Array<String>
	}

	static public function isEmail(emailAddress:String, forbidChars, ?allowIPDomain:Bool = true):Bool {
		// This pattern is very fast. ^^)/
		// final allowEmail:EReg = ~/[\w-.]+@[\w-.]+/;
		// return allowEmail.match(emailAddress);

		if (emailAddress.lastIndexOf("@") < 0)
			return false;
		var domain = StringTools.replace(emailAddress.substr(emailAddress.lastIndexOf("@")), "@", "");
		var local = emailAddress.substring(0, emailAddress.lastIndexOf("@"));
		if (emailAddress.length > 254 || emailAddress.length < 1)
			return false;
		if (isDomain(domain, forbidChars.domain, allowIPDomain) == false)
			return false;
		if (isLocal(local, forbidChars.local) == false)
			return false;
		return true;
	}

	static function isDomain(domain:String, ?forbidChars:Array<String>, ?allowIP):Bool {
		final ALLOW_CHARS:EReg = ~/[0-9A-Z-\.]/i;
		final BRACKET:EReg = ~/^(\[)|(\])$/g;

		if (domain.length > 253)
			return false;
		if (BRACKET.match(domain) == true && allowIP == true) {
			if (isIPv4(BRACKET.replace(domain, "")) == true) {
				return true;
			} else if (isIPv6(BRACKET.replace(domain, "")) == true) {
				return true;
			} else {
				return false;
			};
		} else {
			if (checkAllowChars(ALLOW_CHARS, domain) == false)
				return false;
			return checkForbidChars(forbidChars, domain);
		}
		return true;
	}

	static function isIPv4(ipv4:String):Bool {
		final ALLOW_CHARS:EReg = ~/[0-9\.]/i;
		var array:Array<String> = ipv4.split(".");
		if (ipv4.length > 15 || array.length != 4)
			return false;
		if (checkAllowChars(ALLOW_CHARS, ipv4) == false)
			return false;
		if (rangeNumberStrings(array, 0, 255) == false)
			return false;
		return true;
	}

	static function isIPv6(ipv6:String):Bool {
		final ALLOW_CHARS:EReg = ~/[0-9A-Z:]/i;
		var array:Array<String> = ipv6.split(":");
		if (array.length < 3 || array.length > 8)
			return false;
		if (checkAllowChars(ALLOW_CHARS, ipv6) == false)
			return false;
		return rangeNumberStrings(array.slice(0, array.length), 0x0, 0xffff, true);
	}

	static function isLocal(local:String, ?forbidChars:Array<String>):Bool {
		final ALLOW_CHARS:EReg = ~/[0-9A-Z!#$%&'*+-=?^_`{|}~\/\.]/i;
		final DOUBLE_DOT:EReg = ~/\.\./g;
		final DOUBLE_QUOTED_LEFT:EReg = ~/^(")/;
		final DOUBLE_QUOTED_RIGHT:EReg = ~/(")$/;
		final BOTH_DOT:EReg = ~/^(\.)|(\.)$/;

		if (DOUBLE_QUOTED_LEFT.match(local) && DOUBLE_QUOTED_RIGHT.match(local)) {
			return isQuotedString(local, forbidChars);
		} else {
			if (BOTH_DOT.match(local))
				return false;
			if (local.length > 64)
				return false;
			if (checkAllowChars(ALLOW_CHARS, local) == false)
				return false;
			if (DOUBLE_DOT.match(local) == true)
				return false;
			return checkForbidChars(forbidChars, local);
		}
	}

	static function isQuotedString(local:String, ?forbidChars:Array<String>):Bool {
		final ALLOW_CHARS:EReg = ~/([ 0-9A-Z!#$%&'*+-=?^_`{|}~(),:;<>@(\\)\[\]\/\.])|(")/i;
		if (checkAllowChars(ALLOW_CHARS, local) == false)
			return false;
		return checkForbidChars(forbidChars, local);
	}

	static function checkAllowChars(regex:EReg, string:String):Bool {
		var splitString = string.split("");
		for (v in splitString) {
			if (regex.match(v) == false)
				return false;
		}
		return true;
	}

	static function checkForbidChars(forbidChars:Array<String>, string:String):Bool {
		var splitString = string.split("");
		for (v in splitString) {
			for (fc in forbidChars) {
				if (v == fc)
					return false;
			}
		}
		return true;
	}

	static function rangeNumberStrings(array:Array<String>, min:Int, max:Int, ?isHex = false):Bool {
		var values:Array<Int> = [];
		if (isHex == true) {
			for (i in 0...array.length) {
				values.push(Std.parseInt("0x" + array[i]));
			}
		} else {
			for (i in 0...array.length) {
				values.push(Std.parseInt(array[i]));
			}
		}
		for (i in 0...array.length) {
			if (values[i] > max || values[i] < min) {
				return false;
			}
		}
		return true;
	}

	// static function isTeredo() {} // RFC 4380
	// static function is6to4() {} // RFC 3056,7526
}
