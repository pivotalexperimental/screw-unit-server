Screw.Unit(function() {
  var global_before_invoked = false, global_after_invoked = false, screwUnitBeforeAndAfterOrdering = [];
  before(function() { global_before_invoked = true });
  after(function() { global_after_invoked = true });

  describe('Behaviors', function() {
    describe("level 1", function() {
      before(function() {
        screwUnitBeforeAndAfterOrdering.push("before 1");
      });

      after(function() {
        screwUnitBeforeAndAfterOrdering.push("after 1");
      });

      describe("level 2", function() {
        before(function() {
          screwUnitBeforeAndAfterOrdering.push("before 2");
        });

        after(function() {
          screwUnitBeforeAndAfterOrdering.push("after 2");
        });
        describe("level 3", function() {
          before(function() {
            screwUnitBeforeAndAfterOrdering.push("before 3");
          });

          after(function() {
            screwUnitBeforeAndAfterOrdering.push("after 3");
          });

          it("runs", function() {
            screwUnitBeforeAndAfterOrdering.push("spec");
          });
        });
      });
    });

    describe('#run', function() {
      describe("A describe with a nested describe", function() {
        it("it runs befores outside in, then the spec, then afters inside out", function() {
          expect(screwUnitBeforeAndAfterOrdering).to(equal, [
            "before 1",
            "before 2",
            "before 3",
            "spec",
            "after 3",
            "after 2",
            "after 1"
          ]);
        });
      });

      describe("elapsed time", function() {
        it("displays the elapsed time after the Suite finishes", function() {
          var status = $(".status");
          status.fn("display");
          var time_elapsed_matches = /([0-9]+\.[0-9]+) seconds/.exec(status.html());
          var time_elapsed = parseFloat(time_elapsed_matches[1]);
          expect(time_elapsed > 0.0).to(be_true);
        });
      });

      describe("a simple [describe]", function() {
        it("invokes the global [before] before an [it]", function() {
          expect(global_before_invoked).to(equal, true);
          global_before_invoked = false;
        });

        it("invokes the global [before] before each [it]", function() {
          expect(global_before_invoked).to(equal, true);
          global_after_invoked = false;
        });

        it("invokes the global [after] after an [it]", function() {
          expect(global_after_invoked).to(equal, true);
        });
      });
      
      describe("a [describe] with a [before] and [after] block", function() {
        var before_invoked = false, after_invoked = false;
        before(function() { before_invoked = true });
        after(function() { after_invoked = true });
      
        describe('[after] blocks', function() {
          it("does not invoke the [after] until after the first [it]", function() {
            expect(after_invoked).to(equal, false);
          });
          
          it("invokes the [after] after the first [it]", function() {
            expect(after_invoked).to(equal, true);
            after_invoked = false;
          });
          
          it("invokes the [after] after each [it]", function() {
            expect(after_invoked).to(equal, true);
          });
        });
      
        describe('[before] blocks', function() {
          it("invokes the [before] before an it", function() {
            expect(before_invoked).to(equal, true);
            before_invoked = false;
          });
      
          it("invokes the [before] before each it", function() {
            expect(before_invoked).to(equal, true);
          });
        });
      });

      describe("A [describe] with two [before] and two [after] blocks", function() {
        var before_invocations = [], after_invocations = [];
        before(function() { before_invocations.push('before 1') });
        before(function() { before_invocations.push('before 2') });
        
        after(function() { after_invocations.push('after 1') });
        after(function() { after_invocations.push('after 2') });
        
        it("invokes the [before]s in lexical order before each [it]", function() {
          expect(before_invocations).to(equal, ['before 1', 'before 2']);
        });

        it("invokes the [afters]s in lexical order after each [it]", function() {
          expect(after_invocations).to(equal, ['after 1', 'after 2']);
        });
      });

      describe("A describe block with exceptions", function() {
        var after_invoked = false;
        after(function() {
          after_invoked = true;
        });
        
        describe("an exception in a test", function() {
          it("fails because it throws an exception", function() {
            throw('an exception');
          });
          
          it("invokes [after]s even if the previous [it] raised an exception", function() {
            expect(after_invoked).to(equal, true);
          });
        });
      });
    });

    describe("#selector", function() {
      describe('a [describe]', function() {
        it('manufactures a CSS selector that uniquely locates the [describe]', function() {
          $('.describe').each(function() {
            expect($($(this).fn('selector')).get(0)).to(equal, $(this).get(0))
          });
        });
      });

      describe('an [it]', function() {
        it('manufactures a CSS selector that uniquely locates the [it]', function() {
          $('.it').each(function() {
            expect($($(this).fn('selector')).get(0)).to(equal, $(this).get(0))
          });
        });
      });
    });
  });
});