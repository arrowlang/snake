
extern def realloc(ptr: *mutable byte, size: int64) -> *mutable byte;
extern def free(ptr: *mutable byte);

extern def memmove(dest: *mutable byte, src: *mutable byte, count: int64) -> *byte;

// --------------

let INT_SIZE = 16;

export struct List {
  _capacity: int,
  _size: int,
  _elements: *mutable int
}

export def new() -> List {
  return List(
    0,
    0,
    0 as *mutable int
  );
}

export def dispose(mutable self: List) {
  if self._elements != 0 as *mutable int {
    // TODO: libc.free(self._elements);
    free(self._elements as *mutable byte);
  }
}

/// Reserve additional memory for `capacity` elements to be pushed onto
/// the list. This allows for O(1) insertion if the number of elements
/// is known before a series of `push` statements.
export def reserve(mutable self: List, capacity: int) {
  // Check existing capacity and short-circuit if
  // we are already at a sufficient capacity.
  // BUG: if capacity <= self._capacity {
  //   return;
  // }

  // Ensure that we reserve space in chunks of 10 and update capacity.
  self._capacity = capacity + (10 - (capacity % 10));

  // Reallocate memory to the new requested capacity.
  self._elements = realloc(
    self._elements as *mutable byte, (self._capacity * INT_SIZE) as int64
  ) as *mutable int;
}

/// Push an element onto the list. The list is expanded if there is not
/// enough room.
export def push(mutable self: List, element: int) {
  // Request additional memory if needed.
  if self._size == self._capacity { reserve(self, self._capacity + 1); }

  // Move element into the container.
  *(self._elements + self._size) = element;

  // Increment size to keep track of element insertion.
  self._size += 1;
}

/// Get an element at `index` from the start of the list (negative indicies
/// offset from the size of the list). Attempting to access an element
/// out-of-bounds of the current size is undefined.
export def at(self: List, index: int) -> int {
  // Handle negative indexing.
  let _index: int =
    if index < 0 { self._size - ((-index) as int); }
    else         { index as int; };

  // Return the element.
  return *(self._elements + _index);
}

/// Erase the element at `index` in the list. This is O(1) for elements
/// at the end of the list and O(n) for any other element (where `n` is
/// the number of elements between the erased element and the end of the
/// list).
export def erase(mutable self: List, index: int) {
  // Handle negative indexing.
  let _index: int =
    if index < 0 { self._size - ((-index) as int); }
    else         { index as int; };

  if _index < self._size - 1 {
      // Move everything past index one place to the left,
      // overwriting index.
      memmove((self._elements + (_index)) as *mutable byte,
              (self._elements + ((_index + 1))) as *mutable byte,
              (INT_SIZE * (self._size - (_index + 1))) as int32);
  }

  // Decrement the size to keep track of the element erasure.
  self._size -= 1;
}
