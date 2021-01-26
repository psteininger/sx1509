defmodule SX1509.Registers.IO8 do
  use Wafer.Registers

  @moduledoc """
  This module provides a selective register mapping for SX1509
  The registers on SX1509 are numbered in such a way that "A" registers are located directly after the B registers.
  So, rather than needing to sort out which register to write to (A or B) based on the pin number and writing a byte at a time,
  we can simply write bytes in to the B registers instead and write to both A and B at the same time.
  The first byte is for B registers and the second byte is for A registers.
  So, for the ease of programming this code does not differentiate between A and B registers, and treats them as one 16 bit register.


  """

  @doc """
  RegInputDisableB - Input buffer disable register - I/O[15-8] (Bank B) (default: 0x00)
  RegInputDisableA - Input buffer disable register - I/O[7-0] (Bank A) (default: 0x00)

  Disables the input buffer of each IO
  0 : Input buffer is enabled (input actually being used)
  1 : Input buffer is disabled (input actually not being used or LED connection)
  """
  defregister(:input_disable_b, 0x00, :rw)
  defregister(:input_disable_a, 0x01, :rw)


  @doc """
  RegLongSlewB - Output buffer long slew register - I/O[15-8] (Bank B) (default: 0x00)
  RegLongSlewA - Output buffer long slew register - I/O[7-0] (Bank A) (default: 0x00)

  Enables increased slew rate of the output buffer of each [output-configured] IO
  0 : Increased slew rate is disabled
  1 : Increased slew rate is enabled
  """
  defregister(:long_slew_b, 0x02, :rw)
  defregister(:long_slew_a, 0x03, :rw)

  @doc """
  RegLowDriveB - Output buffer low drive register - I/O[15-8] (Bank B) (default: 0x00)
  RegLowDriveA - Output buffer low drive register - I/O[7-0] (Bank A) (default: 0x00)

  Enables reduced drive of the output buffer of each [output-configured] IO
  0 : Reduced drive is disabled
  1 : Reduced drive is enabled
  """
  defregister(:low_drive_b, 0x04, :rw)
  defregister(:low_drive_a, 0x05, :rw)

  @doc """
  RegPullUpB - Pull-up register - I/O[15-8] (Bank B) (default: 0x00)
  RegPullUpA - Pull-up register - I/O[7-0] (Bank A) (default: 0x00)

  Enables the pull-up for each IO
  0 : Pull-up is disabled
  1 : Pull-up is enabled
  """
  defregister(:pull_up_a, 0x06, :rw)
  defregister(:pull_up_b, 0x07, :rw)

  @doc """
  RegPullDownB - Pull-down register - I/O[15-8] (Bank B) (default: 0x00)
  RegPullDownA - Pull-down register - I/O[7-0] (Bank A) (default: 0x00)

  Enables the pull-down for each IO
  0 : Pull-down is disabled
  1 : Pull-down is enabled
  """
  defregister(:pull_down_b, 0x08, :rw)
  defregister(:pull_down_a, 0x09, :rw)

  @doc """
  RegOpenDrainB - Open drain register - I/O[15-8] (Bank B) (default: 0x00)
  RegOpenDrainA - Open drain register - I/O[7-0] (Bank A) (default: 0x00)

  Enables open drain operation for each [output-configured] IO
  0 : Regular push-pull operation
  1 : Open drain operation
  """
  defregister(:open_drain_b, 0x0A, :rw)
  defregister(:open_drain_a, 0x0B, :rw)

  @doc """
  SX1509 can either deliver current or sink current. SX1509 can sink more current than it can deliver.

  RegPolarityB - Polarity register - I/O[15-8] (Bank B) (default: 0x00)
  RegPolarityA - Polarity register - I/O[7-0] (Bank A) (default: 0x00)

  Enables polarity inversion for each IO
  0 : Normal polarity : RegData[x] = IO[x]
  1 : Inverted polarity : RegData[x] = !IO[x] (for both input and output configured IOs)
  """
  defregister(:polarity_b, 0x0C, :rw)
  defregister(:polarity_a, 0x0D, :rw)

  @doc """
  RegDirB - Data register - I/O[15-8] (Bank B) (default: 0xFF)
  RegDirA - Direction register - I/O[7-0] (Bank A) (default: 0xFF)

  Configures direction for each IO. By default it's configured for input
  0 : IO is configured as an output
  1 : IO is configured as an input
  """
  defregister(:dir_b, 0x0E, :rw)
  defregister(:dir_a, 0x0F, :rw)

  @doc """
  RegDataB - Data register - I/O[15-8] (Bank B) (default: 0xFF when in output mode)
  RegDataA - Data register - I/O[7-0] (Bank A) (default: 0xFF when in output mode)

  In output mode a 0 bit turns the pin on, so it is ACTIVE LOW

  Write: Data to be output to the output-configured IOs
  Read: Data seen at the IOs, independent of the direction configured.
  """
  defregister(:data_b, 0x10, :rw)
  defregister(:data_a, 0x11, :rw)

  @doc """
  RegInterruptMaskB - Interrupt mask register - I/O[15-8] (Bank B) (default: 0xFF == no interrupt triggered)
  RegInterruptMaskA - Interrupt mask register - I/O[7-0] (Bank A) (default: 0xFF == no interrupt triggered)

  Configures which [input-configured] IO will trigger an interrupt on NINT pin
  0 : An event on this IO will trigger an interrupt
  1 : An event on this IO will NOT trigger an interrupt
  """
  defregister(:interrupt_mask_b, 0x12, :rw)
  defregister(:interrupt_mask_a, 0x13, :rw)

  @doc """
  RegSenseHighB (0x14) - Sense register for I/O[15:12] (Bank B)(default: 0x00)
  RegSenseLowB (0x15) - Sense register for I/O[11:8] (Bank B) (default: 0x00)
  RegSenseHighA (0x16) - Sense register for I/O[7:4] (Bank A) (default: 0x00)
  RegSenseLowA (0x17) - Sense register for I/O[3:0] (Bank A) (default: 0x00)

  Each pin has a 2 bit configuration, which works in the following way:

  Bits | Setting
  --- | ---
   00 | None - essentially no interrupt
   01 | Rising
   10 | Falling
   11 | Both

  The bit mapping

  Bit Range | Edge sensitivity of:
  ----: | :----
        | RegSenseHighB
    7:6 | RegData[15]
    5:4 | RegData[14]
    3:2 | RegData[13]
    1:0 | RegData[12]
        | RegSenseLowB
    7:6 | RegData[11]
    5:4 | RegData[10]
    3:2 | RegData[9]
    1:0 | RegData[8]
        | RegSenseHighA
    7:6 | RegData[7]
    5:4 | RegData[6]
    3:2 | RegData[15
    1:0 | RegData[4]
        | RegSenseLowA
    7:6 | RegData[3]
    5:4 | RegData[2]
    3:2 | RegData[1]
    1:0 | RegData[0]


  """
  defregister(:sense_high_b, 0x14, :rw)
  defregister(:sense_low_b, 0x15, :rw)
  defregister(:sense_high_a, 0x16, :rw)
  defregister(:sense_low_a, 0x17, :rw)

  @doc """
  RegInterruptSourceB - Interrupt source register - I/O[15-8] (Bank B) (default: 0x00)
  RegInterruptSourceA - Interrupt source register - I/O[7-0] (Bank A) (default: 0x00)

  Interrupt source (from IOs set in RegInterruptMask)
  0 : No interrupt has been triggered by this IO
  1 : An interrupt has been triggered by this IO (an event as configured in relevant RegSense register occurred).
  Writing '1' clears the bit in RegInterruptSource and in RegEventStatus When all bits are cleared, NINT signal goes back high.
  """
  defregister(:interrupt_source_b, 0x18, :rw)
  defregister(:interrupt_source_a, 0x19, :rw)

  @doc """
  RegEventStatusB - Event status register - I/O[15-8] (Bank B) (default: 0x00)
  RegEventStatusA - Event status register - I/O[7-0] (Bank A) (default: 0x00)

  Event status of all IOs.
  0 : No event has occurred on this IO
  1 : An event has occurred on this IO (an edge as configured in relevant RegSense register occurred).
  Writing '1' clears the bit in RegEventStatus and in RegInterruptSource if relevant.
  If the edge sensitivity of the IO is changed, the bit(s) will be cleared automatically
  """
  defregister(:event_status_b, 0x1A, :rw)
  defregister(:event_status_a, 0x1B, :rw)


  @doc """
  RegLevelShifter1 - Level shifter register - I/O[15-8] (Bank B) (default: 0x00)
  RegLevelShifter2 - Level shifter register - I/O[7-0] (Bank A) (default: 0x00)

  These 2 registers are combined into one and the options are outlined below:

  Bits | Setting
  --- | ---
   00 | OFF
   01 | A->B
   10 | B->A
   11 | Reserved

  The bit mapping below adapted from [SX1509 Datasheet](http://cdn.sparkfun.com/datasheets/BreakoutBoards/sx1509.pdf):

  Bit Range | Level shifter mode for
  ----: | :----
        | RegLevelShifter1
    7:6 | IO[7] (Bank A) and IO[15] (Bank B)
    5:4 | IO[6] (Bank A) and IO[14] (Bank B)
    3:2 | IO[5] (Bank A) and IO[13] (Bank B)
    1:0 | IO[4] (Bank A) and IO[12] (Bank B)
        | RegLevelShifter1
    7:6 | IO[3] (Bank A) and IO[11] (Bank B)
    5:4 | IO[2] (Bank A) and IO[10] (Bank B)
    3:2 | IO[1] (Bank A) and IO[9] (Bank B)
    1:0 | IO[0] (Bank A) and IO[8] (Bank B)
  """
  defregister(:level_shifter_1, 0x1C, :rw)
  defregister(:level_shifter_2, 0x1D, :rw)




end
