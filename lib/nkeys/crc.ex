defmodule NKEYS.CRC do
  @moduledoc """
  Calculates a CRC16 checksum (CCITT - XMODEM)

  This is based on the [go nkeys](https://github.com/nats-io/nkeys/blob/ca6c74a24daca36cbe07d7389d7b2619d0fbc177/crc16.go) package implementation
  """
  import Bitwise,
    only: [
      bxor: 2,
      &&&: 2,
      >>>: 2,
      <<<: 2
    ]

  def compute(binary) when is_binary(binary) do
    compute(binary, 0)
  end

  def compute(<<>>, crc), do: crc
  def compute(<<byte, rem::binary>>, crc) do
    key = bxor((crc >>> 8), byte) &&& 0xff
    crc = bxor((crc <<< 8), Map.get(table(), key))
    compute(rem, crc &&& 0xffff)
  end

  def table do
    %{
      0x00 => 0x0000, 0x01 => 0x1021, 0x02 => 0x2042, 0x03 => 0x3063,
      0x04 => 0x4084, 0x05 => 0x50a5, 0x06 => 0x60c6, 0x07 => 0x70e7,
      0x08 => 0x8108, 0x09 => 0x9129, 0x0a => 0xa14a, 0x0b => 0xb16b,
      0x0c => 0xc18c, 0x0d => 0xd1ad, 0x0e => 0xe1ce, 0x0f => 0xf1ef,
      0x10 => 0x1231, 0x11 => 0x0210, 0x12 => 0x3273, 0x13 => 0x2252,
      0x14 => 0x52b5, 0x15 => 0x4294, 0x16 => 0x72f7, 0x17 => 0x62d6,
      0x18 => 0x9339, 0x19 => 0x8318, 0x1a => 0xb37b, 0x1b => 0xa35a,
      0x1c => 0xd3bd, 0x1d => 0xc39c, 0x1e => 0xf3ff, 0x1f => 0xe3de,
      0x20 => 0x2462, 0x21 => 0x3443, 0x22 => 0x0420, 0x23 => 0x1401,
      0x24 => 0x64e6, 0x25 => 0x74c7, 0x26 => 0x44a4, 0x27 => 0x5485,
      0x28 => 0xa56a, 0x29 => 0xb54b, 0x2a => 0x8528, 0x2b => 0x9509,
      0x2c => 0xe5ee, 0x2d => 0xf5cf, 0x2e => 0xc5ac, 0x2f => 0xd58d,
      0x30 => 0x3653, 0x31 => 0x2672, 0x32 => 0x1611, 0x33 => 0x0630,
      0x34 => 0x76d7, 0x35 => 0x66f6, 0x36 => 0x5695, 0x37 => 0x46b4,
      0x38 => 0xb75b, 0x39 => 0xa77a, 0x3a => 0x9719, 0x3b => 0x8738,
      0x3c => 0xf7df, 0x3d => 0xe7fe, 0x3e => 0xd79d, 0x3f => 0xc7bc,
      0x40 => 0x48c4, 0x41 => 0x58e5, 0x42 => 0x6886, 0x43 => 0x78a7,
      0x44 => 0x0840, 0x45 => 0x1861, 0x46 => 0x2802, 0x47 => 0x3823,
      0x48 => 0xc9cc, 0x49 => 0xd9ed, 0x4a => 0xe98e, 0x4b => 0xf9af,
      0x4c => 0x8948, 0x4d => 0x9969, 0x4e => 0xa90a, 0x4f => 0xb92b,
      0x50 => 0x5af5, 0x51 => 0x4ad4, 0x52 => 0x7ab7, 0x53 => 0x6a96,
      0x54 => 0x1a71, 0x55 => 0x0a50, 0x56 => 0x3a33, 0x57 => 0x2a12,
      0x58 => 0xdbfd, 0x59 => 0xcbdc, 0x5a => 0xfbbf, 0x5b => 0xeb9e,
      0x5c => 0x9b79, 0x5d => 0x8b58, 0x5e => 0xbb3b, 0x5f => 0xab1a,
      0x60 => 0x6ca6, 0x61 => 0x7c87, 0x62 => 0x4ce4, 0x63 => 0x5cc5,
      0x64 => 0x2c22, 0x65 => 0x3c03, 0x66 => 0x0c60, 0x67 => 0x1c41,
      0x68 => 0xedae, 0x69 => 0xfd8f, 0x6a => 0xcdec, 0x6b => 0xddcd,
      0x6c => 0xad2a, 0x6d => 0xbd0b, 0x6e => 0x8d68, 0x6f => 0x9d49,
      0x70 => 0x7e97, 0x71 => 0x6eb6, 0x72 => 0x5ed5, 0x73 => 0x4ef4,
      0x74 => 0x3e13, 0x75 => 0x2e32, 0x76 => 0x1e51, 0x77 => 0x0e70,
      0x78 => 0xff9f, 0x79 => 0xefbe, 0x7a => 0xdfdd, 0x7b => 0xcffc,
      0x7c => 0xbf1b, 0x7d => 0xaf3a, 0x7e => 0x9f59, 0x7f => 0x8f78,
      0x80 => 0x9188, 0x81 => 0x81a9, 0x82 => 0xb1ca, 0x83 => 0xa1eb,
      0x84 => 0xd10c, 0x85 => 0xc12d, 0x86 => 0xf14e, 0x87 => 0xe16f,
      0x88 => 0x1080, 0x89 => 0x00a1, 0x8a => 0x30c2, 0x8b => 0x20e3,
      0x8c => 0x5004, 0x8d => 0x4025, 0x8e => 0x7046, 0x8f => 0x6067,
      0x90 => 0x83b9, 0x91 => 0x9398, 0x92 => 0xa3fb, 0x93 => 0xb3da,
      0x94 => 0xc33d, 0x95 => 0xd31c, 0x96 => 0xe37f, 0x97 => 0xf35e,
      0x98 => 0x02b1, 0x99 => 0x1290, 0x9a => 0x22f3, 0x9b => 0x32d2,
      0x9c => 0x4235, 0x9d => 0x5214, 0x9e => 0x6277, 0x9f => 0x7256,
      0xa0 => 0xb5ea, 0xa1 => 0xa5cb, 0xa2 => 0x95a8, 0xa3 => 0x8589,
      0xa4 => 0xf56e, 0xa5 => 0xe54f, 0xa6 => 0xd52c, 0xa7 => 0xc50d,
      0xa8 => 0x34e2, 0xa9 => 0x24c3, 0xaa => 0x14a0, 0xab => 0x0481,
      0xac => 0x7466, 0xad => 0x6447, 0xae => 0x5424, 0xaf => 0x4405,
      0xb0 => 0xa7db, 0xb1 => 0xb7fa, 0xb2 => 0x8799, 0xb3 => 0x97b8,
      0xb4 => 0xe75f, 0xb5 => 0xf77e, 0xb6 => 0xc71d, 0xb7 => 0xd73c,
      0xb8 => 0x26d3, 0xb9 => 0x36f2, 0xba => 0x0691, 0xbb => 0x16b0,
      0xbc => 0x6657, 0xbd => 0x7676, 0xbe => 0x4615, 0xbf => 0x5634,
      0xc0 => 0xd94c, 0xc1 => 0xc96d, 0xc2 => 0xf90e, 0xc3 => 0xe92f,
      0xc4 => 0x99c8, 0xc5 => 0x89e9, 0xc6 => 0xb98a, 0xc7 => 0xa9ab,
      0xc8 => 0x5844, 0xc9 => 0x4865, 0xca => 0x7806, 0xcb => 0x6827,
      0xcc => 0x18c0, 0xcd => 0x08e1, 0xce => 0x3882, 0xcf => 0x28a3,
      0xd0 => 0xcb7d, 0xd1 => 0xdb5c, 0xd2 => 0xeb3f, 0xd3 => 0xfb1e,
      0xd4 => 0x8bf9, 0xd5 => 0x9bd8, 0xd6 => 0xabbb, 0xd7 => 0xbb9a,
      0xd8 => 0x4a75, 0xd9 => 0x5a54, 0xda => 0x6a37, 0xdb => 0x7a16,
      0xdc => 0x0af1, 0xdd => 0x1ad0, 0xde => 0x2ab3, 0xdf => 0x3a92,
      0xe0 => 0xfd2e, 0xe1 => 0xed0f, 0xe2 => 0xdd6c, 0xe3 => 0xcd4d,
      0xe4 => 0xbdaa, 0xe5 => 0xad8b, 0xe6 => 0x9de8, 0xe7 => 0x8dc9,
      0xe8 => 0x7c26, 0xe9 => 0x6c07, 0xea => 0x5c64, 0xeb => 0x4c45,
      0xec => 0x3ca2, 0xed => 0x2c83, 0xee => 0x1ce0, 0xef => 0x0cc1,
      0xf0 => 0xef1f, 0xf1 => 0xff3e, 0xf2 => 0xcf5d, 0xf3 => 0xdf7c,
      0xf4 => 0xaf9b, 0xf5 => 0xbfba, 0xf6 => 0x8fd9, 0xf7 => 0x9ff8,
      0xf8 => 0x6e17, 0xf9 => 0x7e36, 0xfa => 0x4e55, 0xfb => 0x5e74,
      0xfc => 0x2e93, 0xfd => 0x3eb2, 0xfe => 0x0ed1, 0xff => 0x1ef0
    }
  end
end
