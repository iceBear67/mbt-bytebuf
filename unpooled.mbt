///|
priv struct HeapByteBuf {
  mut readerIndex : Int
  mut writerIndex : Int
  mut marker : Int
  mut bytes : Array[Byte]
}

///|
impl ByteBuf for HeapByteBuf with len(self) -> Int {
  return self.writerIndex - self.readerIndex
}

impl ByteBuf for HeapByteBuf with position(self) -> Int {
  self.readerIndex
}

///|
impl ByteBuf for HeapByteBuf with discard_read_bytes(self) -> Unit {
  if self.readerIndex == 0 {
    return
  }
  self.bytes = self.bytes[self.readerIndex:].to_array()
  self.writerIndex -= self.readerIndex
  self.marker = 0 // marker is always smaller than readerIndex.
  self.readerIndex = 0
}

///|
impl ByteBuf for HeapByteBuf with shrink(self) -> Unit {
  self.bytes = self.bytes[0:self.writerIndex].to_array()
}

///|
impl ByteBuf for HeapByteBuf with clear(self) -> Unit {
  self.readerIndex = 0
  self.writerIndex = 0
  self.marker = 0
  self.bytes = Array::make(0, 0)
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
  return Bytes::from_array(
    self.bytes[self.readerIndex:self.writerIndex].to_array(),
  )
}

///|
impl ByteWriter for HeapByteBuf with capacity(self) -> Int? {
  return Some(self.bytes.length() - self.writerIndex)
}

///|
impl ByteWriter for HeapByteBuf with write_bytes(self, data : Bytes) -> Unit {
  if self.capacity().unwrap() < data.length() {
    let new_capacity = self.bytes.length() +
      (data.length() - self.capacity().unwrap())
    let original_length = self.bytes.length()
    self.bytes = Array::makei(new_capacity, i => if i < self.writerIndex {
      self.bytes[i]
    } else {
      data[i - self.writerIndex]
    })
    self.writerIndex += data.length()
  } else {
    for i, b in data.to_array() {
      self.bytes[self.writerIndex + i] = b
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
  return Some(Bytes::from_array(self.bytes[start:end].to_array()))
}

///|
pub fn make_unpooled(suggest_capacity : Int) -> &ByteBuf {
  return HeapByteBuf::{
    readerIndex: 0,
    writerIndex: 0,
    marker: 0,
    bytes: Array::make(suggest_capacity, 0),
  }
}

///|
pub fn make_unpooled_from_bytes(data : Bytes) -> &ByteBuf {
  return HeapByteBuf::{
    readerIndex: 0,
    writerIndex: data.length(),
    marker: 0,
    bytes: data.to_array(),
  }
}

///|
pub fn make_unpooled_from_array(data : Array[Byte]) -> &ByteBuf {
  return HeapByteBuf::{
    readerIndex: 0,
    writerIndex: data.length(),
    marker: 0,
    bytes: data.copy(),
  }
}
