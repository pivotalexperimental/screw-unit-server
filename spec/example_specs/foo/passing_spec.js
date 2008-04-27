require("/implementations/foo");

Screw.Unit(function() {
  describe("A passing spec in foo", function() {
    it("passes", function() {
      expect(Foo.value).to(equal, true);
    })
  });
});
