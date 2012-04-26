(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(function() {
    var SortedArray;
    return SortedArray = (function() {

      function SortedArray() {
        this.insert = __bind(this.insert, this);
        this.push = __bind(this.push, this);        this.arr = new Array();
      }

      SortedArray.prototype.push = function(el) {
        return this.arr.push(el);
      };

      SortedArray.prototype.insert = function(element, property, justIndex, lessThan) {
        var imax, imid, imin, moreThan, p, targetIndex, _ref;
        if (justIndex == null) justIndex = false;
        if (lessThan == null) lessThan = true;
        if (this.arr.length === 0) {
          if (!justIndex) {
            this.arr.push(element);
            return;
          } else {
            return -1;
          }
        }
        imin = 0;
        imax = this.arr.length - 1;
        imid = 0;
        while (imax > imin) {
          imid = (imax + imin) >> 1;
          p = this.arr[imid];
          if (element[property] > p[property]) {
            imin = imid + 1;
          } else if (element[property] < p[property]) {
            imax = imid - 1;
          } else {
            break;
          }
        }
        if (justIndex) {
          if (this.arr[imin][property] < element[property]) imin += 1;
          moreThan = !lessThan;
          if (moreThan) {
            if (imin === this.arr.length) {
              return -1;
            } else {
              return imin;
            }
          }
          if (lessThan) return imin - 1;
        }
        targetIndex = this.arr[imin][property] < element[property] ? imin + 1 : imin;
        return ([].splice.apply(this.arr, [targetIndex, targetIndex - targetIndex].concat(_ref = [element])), _ref);
      };

      return SortedArray;

    })();
  });

}).call(this);
