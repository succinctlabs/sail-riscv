union clause ast = RISCV_FLI_S : (bits(5), regidx)

mapping clause encdec = RISCV_FLI_S(rs1, rd)                if (haveFExt() & haveZfa())
  <-> 0b111_1000 @ 0b00001 @ rs1 @ 0b000 @ rd @ 0b101_0011  if (haveFExt() & haveZfa())

mapping clause assembly = RISCV_FLI_S(constantidx, rd)
  <-> "fli.s" ^ spc() ^ freg_name(rd) ^ sep() ^ hex_bits_5(constantidx)

function clause execute (RISCV_FLI_S(constantidx, rd)) = {
  bits : bits(32) = zeros();
  match constantidx {
    0b00000 => { bits = 0xbf800000 },  /* -1.0 */
    0b00001 => { bits = 0x00800000 },  /* minimum positive normal */
    0b00010 => { bits = 0x37800000 },  /* 1.0 * 2^-16 */
    0b00011 => { bits = 0x38000000 },  /* 1.0 * 2^-15 */
    0b00100 => { bits = 0x3b800000 },  /* 1.0 * 2^-8  */
    0b00101 => { bits = 0x3c000000 },  /* 1.0 * 2^-7  */
    0b00110 => { bits = 0x3d800000 },  /* 1.0 * 2^-4  */
    0b00111 => { bits = 0x3e000000 },  /* 1.0 * 2^-3  */
    0b01000 => { bits = 0x3e800000 },  /* 0.25 */
    0b01001 => { bits = 0x3ea00000 },  /* 0.3125 */
    0b01010 => { bits = 0x3ec00000 },  /* 0.375 */
    0b01011 => { bits = 0x3ee00000 },  /* 0.4375 */
    0b01100 => { bits = 0x3f000000 },  /* 0.5 */
    0b01101 => { bits = 0x3f200000 },  /* 0.625 */
    0b01110 => { bits = 0x3f400000 },  /* 0.75 */
    0b01111 => { bits = 0x3f600000 },  /* 0.875 */
    0b10000 => { bits = 0x3f800000 },  /* 1.0 */
    0b10001 => { bits = 0x3fa00000 },  /* 1.25 */
    0b10010 => { bits = 0x3fc00000 },  /* 1.5 */
    0b10011 => { bits = 0x3fe00000 },  /* 1.75 */
    0b10100 => { bits = 0x40000000 },  /* 2.0 */
    0b10101 => { bits = 0x40200000 },  /* 2.5 */
    0b10110 => { bits = 0x40400000 },  /* 3 */
    0b10111 => { bits = 0x40800000 },  /* 4 */
    0b11000 => { bits = 0x41000000 },  /* 8 */
    0b11001 => { bits = 0x41800000 },  /* 16 */
    0b11010 => { bits = 0x43000000 },  /* 2^7 */
    0b11011 => { bits = 0x43800000 },  /* 2^8 */
    0b11100 => { bits = 0x47000000 },  /* 2^15 */
    0b11101 => { bits = 0x47800000 },  /* 2^16 */
    0b11110 => { bits = 0x7f800000 },  /* +inf */
    0b11111 => { bits = canonical_NaN_S() },
  };
  F(rd) = nan_box(bits);
  RETIRE_SUCCESS
}
