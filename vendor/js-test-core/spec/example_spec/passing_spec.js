require("/javascripts/foo");
Screw.Unit(function() {
  describe("A passing spec", function() {
    it("passes", function() {
      expect(Foo.value).to(equal, true);
    });
  });
});
