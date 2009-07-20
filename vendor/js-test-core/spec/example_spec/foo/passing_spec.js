require("/javascripts/foo");
describe("A passing spec", {
	'passes': function() {
		value_of(Foo.value).should_be(true);
	}
})
