require("/implementations/foo");

Screw.Unit(function() {
  describe("A failing spec in foo", function() {
    it("fails", function() {
      expect(Foo.value).to(equal, false);
    })
  });
});
