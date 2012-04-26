(function() {

  define(["app/lib/sorted_array"], function(SortedArray) {
    describe("insertion of elements in a Sorted Array", function() {
      var arr;
      arr = null;
      beforeEach(function() {
        return arr = new SortedArray();
      });
      it("insert an element in an not empty array in the correct position", function() {
        var tmp, _i, _len, _ref;
        _ref = [1, 2, 3, 4, 5];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          tmp = _ref[_i];
          arr.push({
            x: tmp
          });
        }
        arr.insert({
          x: 3.5
        }, "x");
        return expect(arr.arr).toEqual([
          {
            x: 1
          }, {
            x: 2
          }, {
            x: 3
          }, {
            x: 3.5
          }, {
            x: 4
          }, {
            x: 5
          }
        ]);
      });
      it("insert a series of elements in an empty array", function() {
        arr.insert({
          x: 2
        }, "x");
        arr.insert({
          x: 3
        }, "x");
        arr.insert({
          x: 1
        }, "x");
        arr.insert({
          x: 4
        }, "x");
        return expect(arr.arr).toEqual([
          {
            x: 1
          }, {
            x: 2
          }, {
            x: 3
          }, {
            x: 4
          }
        ]);
      });
      it("insert a two elements in an empty array in min to max order", function() {
        arr.insert({
          x: 2
        }, "x");
        arr.insert({
          x: 3
        }, "x");
        return expect(arr.arr).toEqual([
          {
            x: 2
          }, {
            x: 3
          }
        ]);
      });
      return it("insert a two elements in an empty array in max to min order", function() {
        arr.insert({
          x: 3
        }, "x");
        arr.insert({
          x: 2
        }, "x");
        return expect(arr.arr).toEqual([
          {
            x: 2
          }, {
            x: 3
          }
        ]);
      });
    });
    return describe("Get insertion position for an element", function() {
      var arr;
      arr = null;
      beforeEach(function() {
        return arr = new SortedArray();
      });
      it("Get insertion position of an element against an empty array when we are looking for the last element in the array which is less than the one passed", function() {
        var pos;
        pos = arr.insert({
          x: 3.5
        }, "x", true, true);
        return expect(pos).toEqual(-1);
      });
      it("Get insertion position of an element against an empty array when we are looking for the first element in the array which is more than the one passed", function() {
        var pos;
        pos = arr.insert({
          x: 3.5
        }, "x", true, false);
        return expect(pos).toEqual(-1);
      });
      it("Get insertion position of an element against a one element array when the element to be inserted is less than the element in the array and we are looking for the last element in the array which is less than the one passed", function() {
        var pos;
        arr.push({
          x: 3
        });
        pos = arr.insert({
          x: 1
        }, "x", true, true);
        return expect(pos).toEqual(-1);
      });
      it("Get insertion position of an element against a one element array when the element to be inserted is less than the element in the array and we are looking for the first element in the array which is more than the one passed", function() {
        var pos;
        arr.push({
          x: 3
        });
        pos = arr.insert({
          x: 1
        }, "x", true, false);
        return expect(pos).toEqual(0);
      });
      it("Get insertion position of an element against a one element array when the element to be inserted is more than the element in the array and we are looking for the last element in the array which is less than the one passed", function() {
        var pos;
        arr.push({
          x: 1
        });
        pos = arr.insert({
          x: 3
        }, "x", true, true);
        return expect(pos).toEqual(0);
      });
      it("Get insertion position of an element against a one element array when the element to be inserted is more than the element in the array and we are looking for the first element in the array which is more than the one passed", function() {
        var pos;
        arr.push({
          x: 1
        });
        pos = arr.insert({
          x: 3
        }, "x", true, false);
        return expect(pos).toEqual(-1);
      });
      it("Get insertion position of an element against an array when the element to be inserted is less than all elements in the array and we are looking for the first element in the array which is more than the one passed", function() {
        var pos;
        arr.push({
          x: 6
        });
        arr.push({
          x: 7
        });
        arr.push({
          x: 8
        });
        arr.push({
          x: 9
        });
        pos = arr.insert({
          x: 3
        }, "x", true, false);
        return expect(pos).toEqual(0);
      });
      it("Get insertion position of an element against an array when the element to be inserted is more than all elements in the array and we are looking for the last element in the array which is less than the one passed", function() {
        var pos;
        arr.push({
          x: 6
        });
        arr.push({
          x: 7
        });
        arr.push({
          x: 8
        });
        arr.push({
          x: 9
        });
        pos = arr.insert({
          x: 10
        }, "x", true, true);
        return expect(pos).toEqual(3);
      });
      it("Get insertion position of an element against an array when the element to be inserted is less than all elements in the array and we are looking for the last element in the array which is less than the one passed", function() {
        var pos;
        arr.push({
          x: 6
        });
        arr.push({
          x: 7
        });
        arr.push({
          x: 8
        });
        arr.push({
          x: 9
        });
        pos = arr.insert({
          x: 3
        }, "x", true, true);
        return expect(pos).toEqual(-1);
      });
      return it("Get insertion position of an element against an array when the element to be inserted is less than all elements in the array and we are looking for the first element in the array which is more than the one passed", function() {
        var pos;
        arr.push({
          x: 6
        });
        arr.push({
          x: 7
        });
        arr.push({
          x: 8
        });
        arr.push({
          x: 9
        });
        pos = arr.insert({
          x: 10
        }, "x", true, false);
        return expect(pos).toEqual(-1);
      });
    });
  });

}).call(this);
