require("/specs/spec_helper");

Screw.Unit(function() {
  describe("A failing spec in foo", function() {
    it("fails", function() {
      expect(Foo.value).to(equal, false);
    })
  });
});
