///|
priv struct TestData[T] {
  data : T
  byte_expect : Bytes
}

///|
let uint_data : Array[TestData[UInt]] = [
  TestData::{ data: 0x01020304, byte_expect: [4, 3, 2, 1] },
  TestData::{ data: 0x01020304, byte_expect: [1, 2, 3, 4] },
]

///|
let uint16_data : Array[TestData[UInt16]] = [
  TestData::{ data: 0x0102, byte_expect: [2, 1] },
  TestData::{ data: 0x0102, byte_expect: [1, 2] },
]

///|
let uint64_data : Array[TestData[UInt64]] = [
  TestData::{ data: 0x0102030405060708, byte_expect: [8, 7, 6, 5, 4, 3, 2, 1] },
  TestData::{ data: 0x0102030405060708, byte_expect: [1, 2, 3, 4, 5, 6, 7, 8] },
]

///|
let int_data : Array[TestData[Int]] = [
  TestData::{ data: 0x01020304, byte_expect: [4, 3, 2, 1] },
  TestData::{ data: 0x01020304, byte_expect: [1, 2, 3, 4] },
]

///|
let int16_data : Array[TestData[Int16]] = [
  TestData::{ data: 0x0102, byte_expect: [2, 1] },
  TestData::{ data: 0x0102, byte_expect: [1, 2] },
]

///|
let int64_data : Array[TestData[Int64]] = [
  TestData::{ data: 0x0102030405060708, byte_expect: [8, 7, 6, 5, 4, 3, 2, 1] },
  TestData::{ data: 0x0102030405060708, byte_expect: [1, 2, 3, 4, 5, 6, 7, 8] },
]

///|
test "test default read/write operations" {
  let buf = @bytebuf.make_unpooled(10)

  // uint_le
  buf.write_uint_le(uint_data[0].data)
  assert_eq(
    buf.to_bytes(),
    uint_data[0].byte_expect,
    msg="write_uint_le failed",
  )
  assert_eq(
    buf.read_uint_le(),
    Some(uint_data[0].data),
    msg="read_uint_le failed",
  )
  buf.clear()
  // uint_be
  assert_true(buf.is_empty(), msg="buf should be empty after clear")
  assert_false(buf.has_remaining(), msg="buf should have no remaining data")
  buf.write_uint(uint_data[1].data)
  assert_true(buf.has_remaining(), msg="buf should have remaining data")
  assert_eq(buf.to_bytes(), uint_data[1].byte_expect, msg="write_uint failed")
  assert_eq(buf.read_uint(), Some(uint_data[1].data), msg="read_uint_be failed")
  buf.clear()

  // uint16_le
  buf.write_uint16_le(uint16_data[0].data)
  assert_eq(
    buf.to_bytes(),
    uint16_data[0].byte_expect,
    msg="write_uint16_le failed",
  )
  assert_eq(
    buf.read_uint16_le(),
    Some(uint16_data[0].data),
    msg="write_uint16_le failed",
  )
  buf.clear()
  // uint16_be
  buf.write_uint16(uint16_data[1].data)
  assert_eq(
    buf.to_bytes(),
    uint16_data[1].byte_expect,
    msg="write_uint16 failed",
  )
  assert_eq(
    buf.read_uint16(),
    Some(uint16_data[1].data),
    msg="write_uint16 failed",
  )
  buf.clear()
  // uint64_le
  buf.write_uint64_le(uint64_data[0].data)
  assert_eq(
    buf.to_bytes(),
    uint64_data[0].byte_expect,
    msg="write_uint64_le failed",
  )
  assert_eq(
    buf.read_uint64_le(),
    Some(uint64_data[0].data),
    msg="write_uint64_le failed",
  )
  buf.clear()
  // uint64_be
  buf.write_uint64(uint64_data[1].data)
  assert_eq(
    buf.to_bytes(),
    uint64_data[1].byte_expect,
    msg="write_uint64 failed",
  )
  assert_eq(
    buf.read_uint64(),
    Some(uint64_data[1].data),
    msg="write_uint64 failed",
  )
  buf.clear()
  // int_le
  buf.write_int_le(int_data[0].data)
  assert_eq(buf.to_bytes(), int_data[0].byte_expect, msg="write_int_le failed")
  assert_eq(
    buf.read_int_le(),
    Some(int_data[0].data),
    msg="write_int_le failed",
  )
  buf.clear()

  // float_le
  buf.write_float_le(int_data[0].data.reinterpret_as_float())
  assert_eq(
    buf.to_bytes(),
    int_data[0].byte_expect,
    msg="write_float_le failed",
  )
  assert_eq(
    buf.read_float_le(),
    Some(int_data[0].data.reinterpret_as_float()),
    msg="write_float_le failed",
  )
  buf.clear()

  // int_be
  buf.write_int(int_data[1].data)
  assert_eq(buf.to_bytes(), int_data[1].byte_expect, msg="write_int failed")
  assert_eq(buf.read_int(), Some(int_data[1].data), msg="write_int failed")
  buf.clear()

  // float_be
  buf.write_float(int_data[1].data.reinterpret_as_float())
  assert_eq(buf.to_bytes(), int_data[1].byte_expect, msg="write_float failed")
  assert_eq(
    buf.read_float(),
    Some(int_data[1].data.reinterpret_as_float()),
    msg="write_float failed",
  )
  buf.clear()

  // int16_le
  buf.write_int16_le(int16_data[0].data)
  assert_eq(
    buf.to_bytes(),
    int16_data[0].byte_expect,
    msg="read_int16_le failed",
  )
  assert_eq(
    buf.read_int16_le(),
    Some(int16_data[0].data),
    msg="read_uint_le failed",
  )
  buf.clear()
  // int16_be
  buf.write_int16(int16_data[1].data)
  assert_eq(buf.to_bytes(), int16_data[1].byte_expect, msg="write_int16 failed")
  assert_eq(
    buf.read_int16(),
    Some(int16_data[1].data),
    msg="write_int16 failed",
  )
  buf.clear()
  // int64_le
  buf.write_int64_le(int64_data[0].data)
  assert_eq(
    buf.to_bytes(),
    int64_data[0].byte_expect,
    msg="write_int64_le failed",
  )
  assert_eq(
    buf.read_int64_le(),
    Some(int64_data[1].data),
    msg="write_int64_le failed",
  )
  buf.clear()

  //double le
  buf.write_double_le(int64_data[0].data.reinterpret_as_double())
  assert_eq(
    buf.to_bytes(),
    int64_data[0].byte_expect,
    msg="write_double_le failed",
  )
  assert_eq(
    buf.read_double_le(),
    Some(int64_data[0].data.reinterpret_as_double()),
    msg="write_double_le failed",
  )
  buf.clear()
  // int64_be
  buf.write_int64(int64_data[1].data)
  assert_eq(buf.to_bytes(), int64_data[1].byte_expect, msg="write_int64 failed")
  assert_eq(
    buf.read_int64(),
    Some(int64_data[1].data),
    msg="write_int64 failed",
  )
  buf.clear()
  //double be
  buf.write_double(int64_data[1].data.reinterpret_as_double())
  assert_eq(buf.to_bytes(), int64_data[1].byte_expect, msg="write_double failed")
  assert_eq(
    buf.read_double(),
    Some(int64_data[1].data.reinterpret_as_double()),
    msg="write_int_le failed",
  )
  buf.clear()
}
