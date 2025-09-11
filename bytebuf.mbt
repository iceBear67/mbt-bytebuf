///|
/// A trait that allows us to read data sequentially.
/// The reader does not allow backward reading operations. By default, the trait returns
/// numbers in big endian (the network order).
/// Operations are expanded by endianness with the hope of inlining.
pub(open) trait ByteReader {
  remaining(Self) -> Int
  has_remaining(Self) -> Bool = _
  read_bytes(Self, len : Int) -> Bytes?
  read_int(Self) -> Int? = _
  read_int_le(Self) -> Int? = _
  read_int16(Self) -> Int16? = _
  read_int16_le(Self) -> Int16? = _
  read_int64(Self) -> Int64? = _
  read_int64_le(Self) -> Int64? = _
  read_byte(Self) -> Byte? = _
  read_uint(Self) -> UInt? = _
  read_uint_le(Self) -> UInt? = _
  read_uint16(Self) -> UInt16? = _
  read_uint16_le(Self) -> UInt16? = _
  read_uint64(Self) -> UInt64? = _
  read_uint64_le(Self) -> UInt64? = _
  read_float(Self) -> Float? = _ 
  read_float_le(Self) -> Float? = _
  read_double(Self) -> Double? = _
  read_double_le(Self) -> Double? = _
}

///|
pub(open) trait ByteWriter {
  ///| Remaining spaces we can write without resizing the underlying structure.
  /// This may return None if capacity is infinity.
  capacity(Self) -> Int?

  ///| Write some bytes into the destination.
  /// The buffer will increase its capacity if needed.
  write_bytes(Self, Bytes) -> Unit
  write_byte(Self, Byte) -> Unit
  write_int(Self, Int) -> Unit = _
  write_int16(Self, Int16) -> Unit = _
  write_int64(Self, Int64) -> Unit = _
  write_uint(Self, UInt) -> Unit = _
  write_uint16(Self, UInt16) -> Unit = _
  write_uint64(Self, UInt64) -> Unit = _
  write_int_le(Self, Int) -> Unit = _
  write_int16_le(Self, Int16) -> Unit = _
  write_int64_le(Self, Int64) -> Unit = _
  write_uint_le(Self, UInt) -> Unit = _
  write_uint16_le(Self, UInt16) -> Unit = _
  write_uint64_le(Self, UInt64) -> Unit = _
  write_float(Self, Float) -> Unit = _
  write_float_le(Self, Float) -> Unit = _
  write_double(Self, Double) -> Unit = _
  write_double_le(Self, Double) -> Unit = _
}

///|
pub(open) trait ByteBuf: ByteReader + ByteWriter {
  len(Self) -> Int
  is_empty(Self) -> Bool = _
  to_bytes(Self) -> Bytes
  ///| This will reset the reader and writer index.
  /// The content will no longer be accessible.
  clear(Self) -> Unit
  ///| Mark the current reader index.
  /// You can reset to this index later.
  mark(Self) -> Unit
  ///| Reset the reader index to the previously marked index.
  /// If no index was marked, this will reset the reader index to 0.
  reset(Self) -> Unit

  ///| Discard the read bytes and move the unread bytes to the beginning.
  /// This will reset the reader index to 0 and adjust the writer index accordingly.
  /// This is useful when you want to free up space in the buffer. It creates a new underlying storage and copies the content.
  /// Marks will lose if they are earlier than the reader index.
  discard_read_bytes(Self) -> Unit

  ///| Shrink the capacity of the buffer to fit the current content.
  /// This will not affect the reader and writer indices.
  /// This method creates a new underlying storage and copies the content.
  shrink(Self) -> Unit 
}