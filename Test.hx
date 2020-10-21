import sneaker.assertion.Asserter.assert;

class Test {
	static function main() {
		// trace(EmailAddressValidator.isEmail('simple@example.com'));
		assertEmail();
	}

	private static function assertEmail():Void {
		var trueMock:Array<String> = [
			'simple@example.com', 'very.common@example.com', 'disposable.style.email.with+symbol@example.com', 'other.email-with-hyphen@example.com',
			'fully-qualified-domain@example.com', 'user.name+tag+sorting@example.com', 'x@example.com', 'example-indeed@strange-example.com',
			'example@s.example', 'mailhost!username@example.org', 'user%example.com@example.org', 'admin@mailserver1', '" "@example.org',
			'"john..doe"@example.org'
		];
		var falseMock:Array<String> = [
			'Abc.example.com',
			'A@b@c@example.com',
			'1234567890123456789012345678901234567890123456789012345678901234+x@example.com',
			'i_like_underscore@but_its_not_allow_in_this_part.example.com',
			'just"not"right@example.com'
		];
		var trueIPMock:Array<String> = [
			'simple@[255.255.255.255]',
			'simple@[0.0.0.0]',
			'simple@[ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff]',
			'simple@[0:0:0:0:0:0:0:0]',
			'simple@[::]'
		];
		var falseIPMock:Array<String> = [
			'simple@[255.255.255.256]',
			'simple@[0.0.0.-1]',
			'simple@[ffff:ffff:ffff:ffff:ffff:ffff:ffff:10000]',
			'simple@[0:0:0:0:0:0:0:-0]',
			'simple@[2001:255.255.255.255:0:0:0:0:0:255.255.255.255]',
			'simple@[:]',
			'simple@[]',
			'simple@[.]'
		];
		var rejectLocalMock:Array<String> = [
			'disposable.style.email.with+symbol@example.com',
			'user.name+tag+sorting@example.com',
			'mailhost!username@example.org',
			'user%example.com@example.org',
			'" "@example.org',
			'"""@example.org'
		];
		var rejectDomainMock:Array<String> = [
			               'simple@example.com', 'very.common@example.com', 'other.email-with-hyphen@example.com',
			          'fully-qualified-domain@example.com',
			'user.name+tag+sorting@example.com',           'x@example.com',  'example-indeed@strange-example.com',
			               'mailhost!username@example.org',
			     'user%example.com@example.org',         '" "@example.org',             '"john..doe"@example.org',
			'disposable.style.email.with+symbol@example.com'
		];

		for (v in trueMock) {
			assert(EmailAddressValidator.isEmail(v) == true);
			trace("case1 " + v + " == true : passed");
		}
		for (v in falseMock) {
			assert(EmailAddressValidator.isEmail(v) == false);
			trace("case2 " + v + " == false : passed");
		}
		for (v in trueIPMock) {
			assert(EmailAddressValidator.isEmail(v) == true);
			trace("case3 " + v + " == true : passed");
		}
		for (v in falseIPMock) {
			assert(EmailAddressValidator.isEmail(v) == false);
			trace("case4 " + v + " == false : passed");
		}
		for (v in trueIPMock) {
			assert(EmailAddressValidator.isEmail(v, false) == false);
			trace("case5 " + v + " == false : passed");
		}
		for (v in rejectLocalMock) {
			assert(EmailAddressValidator.isEmail(v, {
				local: ["+", "!", "%", " ", '"']
			}) == false);
			trace("case6 " + v + " == false : passed");
		}

		for (v in rejectDomainMock) {
			assert(EmailAddressValidator.isEmail(v, {
				domain: ["o"]
			}) == false);
			trace("case7 " + v + " == false : passed");
		}
	}
}
