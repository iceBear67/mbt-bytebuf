///|
priv struct HeapByteBuf {
  mut readerIndex : Int
  mut writerIndex : Int
  mut marker : Int
  bytes : Ref[FixedArray[Byte]]
}

///|
impl ByteBuf for HeapByteBuf with len(self) -> Int {
  return self.writerIndex - self.readerIndex
}

///|
impl ByteBuf for HeapByteBuf with position(self) -> Int {
  self.readerIndex
}

///|
impl ByteBuf for HeapByteBuf with discard_read_bytes(self) -> Unit {
  if self.readerIndex == 0 {
    return
  }
  self.bytes.val.blit_to(
    self.bytes.val,
    len=self.bytes.val.length() - self.readerIndex,
    src_offset=self.readerIndex,
  )
  self.writerIndex -= self.readerIndex
  self.marker = 0 // marker is always smaller than readerIndex.
  self.readerIndex = 0
}

///|
impl ByteBuf for HeapByteBuf with shrink(self) -> Unit {
  self.bytes.val.blit_to(
    self.bytes.val,
    len=self.writerIndex,
    src_offset=0,
  )
}

///|
impl ByteBuf for HeapByteBuf with clear(self) -> Unit {
  self.readerIndex = 0
  self.writerIndex = 0
  self.marker = 0
  self.bytes.val = FixedArray::make(0, 0) // questionable
}

///|
impl ByteBuf for HeapByteBuf with mark(self) -> Int {
  self.marker = self.readerIndex
  self.marker
}

///|
impl ByteBuf for HeapByteBuf with reset(self) -> Unit {
  self.readerIndex = self.marker
}

///|
impl ByteBuf for HeapByteBuf with to_bytes(self) -> Bytes {
  return Bytes::makei(self.len(), i => self.bytes.val[self.readerIndex + i])
}

///|
impl ByteWriter for HeapByteBuf with capacity(self) -> Int? {
  return Some(self.bytes.val.length() - self.writerIndex)
}

///|
impl ByteWriter for HeapByteBuf with write_bytes(self, data : Bytes) -> Unit {
  if self.capacity().unwrap() < data.length() {
    let new_capacity = self.bytes.val.length() +
      (data.length() - self.capacity().unwrap())
    self.bytes.val = FixedArray::makei(new_capacity, i => if i < self.writerIndex {
      self.bytes.val[i]
    } else {
      data[i - self.writerIndex]
    })
    self.writerIndex += data.length()
  } else {
    for i, b in data.to_array() {
      self.bytes.val[self.writerIndex + i] = b
    }
    self.writerIndex += data.length()
  }
}

///|
impl ByteWriter for HeapByteBuf with write_byte(self, data : Byte) -> Unit {
  self.write_bytes(Bytes::make(1, data))
}

///|
impl ByteReader for HeapByteBuf with remaining(self) -> Int {
  return self.writerIndex - self.readerIndex
}

///|
impl ByteReader for HeapByteBuf with read_bytes(self, amount : Int) -> Bytes? {
  if self.remaining() < amount {
    return None
  }
  let start = self.readerIndex
  let end = start + amount
  self.readerIndex += amount
  return Some(Bytes::makei(end - start, i => self.bytes.val[start + i]))
}

///|
pub fn make_unpooled(suggest_capacity : Int) -> &ByteBuf {
  return HeapByteBuf::{
    readerIndex: 0,
    writerIndex: 0,
    marker: 0,
    bytes: @ref.new(FixedArray::make(suggest_capacity, 0)),
  }
}

///|
pub fn make_unpooled_from_bytes(data : Bytes) -> &ByteBuf {
  return HeapByteBuf::{
    readerIndex: 0,
    writerIndex: data.length(),
    marker: 0,
    bytes: @ref.new(FixedArray::makei(data.length(), i => data[i])),
  }
}

///|
pub fn make_unpooled_from_array(data : Array[Byte]) -> &ByteBuf {
  return HeapByteBuf::{
    readerIndex: 0,
    writerIndex: data.length(),
    marker: 0,
    bytes: @ref.new(FixedArray::from_array(data)),
  }
}
